//
//  MainViewModel.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import AVFoundation
import googleapis

final class MainViewModel: NSObject{
    private var transcripts: [String] = [] {
        didSet {
            didChanged?(nil)
        }
    }
    
    var audioName: String!
    private var createdDate: String!
    private let translationRepository = TranslationRepositoryImpl(api: APIService.shared)
    private let sampleRate = 16000
    private var audioData: NSMutableData!
    private var finished: Bool = false
    
    var didChanged: ((String?) -> Void)?
    var deselectedButton: (() -> Void)?
    var didShowValue: ((String) -> Void)?
    
    override init() {
        super.init()
        transcripts.removeAll()
        AudioController.sharedInstance.delegate = self
        
        // Setup CreatedDate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        createdDate = formatter.string(from: Date())
    }
    
    func startAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
        } catch {
            print(error.localizedDescription)
        }
        
        audioData = NSMutableData()
        let status = AudioController.sharedInstance.prepare(specifiedSampleRate: sampleRate)
        if status != noErr {
            
        }
        SpeechRecognitionService.sharedInstance.sampleRate = sampleRate
        _ = AudioController.sharedInstance.start()
        print("RECORDING START")
    }
    
    func stopAudio() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
        print("RECORDING STOP")
    }
    
    private func translatingText(_ inputText: String, translationCode: String) {
        print("TRANSLATION: ", ForeignLanguages.shared.selectedTransToLanguage!)
        guard let desTransCode = ForeignLanguages.shared.selectedTransToLanguage?.desTransCode else { return }
        
        translationRepository.translateText(text: inputText, sourceLangCode: translationCode,
                                            targetLangCode: desTransCode) { result in
            switch result {
            case .success(let response):
                guard let res = response?.translationData?.translations?.first?.translatedText,
                    res != "" else { return }
                print("TRANSLATE:", res)
                self.writeTextToFireBase(text: res)
            case .failure(let err):
                print("ERROR: ", err?.errorMessage ?? "")
            }
        }
    }
    
    private func writeTextToFireBase(text: String) {
        FirebaseService.shared.write(audioName: audioName, createdDate: createdDate, message: text)
    }
}

extension MainViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MainViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transcripts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCell = tableView.dequeueReusableCell(for: indexPath)
        let transcript = transcripts[indexPath.row]
        cell.configCell(transcript)
        return cell
    }
}

extension MainViewModel: AudioControllerDelegate {
    func processSampleData(_ data: Data) -> Void {
        guard data != nil else { return }
        audioData.append(data)
        
        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
            * Double(sampleRate) /* samples/second */
            * 2 /* bytes/sample */);

        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData, languagueCode: (ForeignLanguages.shared.selectedSTTLanguage?.sttCode)!) { [weak self] (response, error) in
                guard let self = self else {
                    return
                }

                if let error = error {
                    self.didChanged?(error.localizedFailureReason)
                    self.deselectedButton?()
                    self.stopAudio()
                } else if let response = response {
                    self.finished = false

                    for result in response.resultsArray! {
                        if let result = result as? StreamingRecognitionResult {
                            if result.isFinal {
                                self.finished = true
                                
                                if let res = result.alternativesArray as? [SpeechRecognitionAlternative] {
                                    let alternative =  res.max(by: { (a, b) -> Bool in
                                        a.confidence < b.confidence
                                    })
                                    
                                    self.transcripts.append(alternative?.transcript ?? "")
                                    self.didShowValue?(alternative?.transcript ?? "")
                                    // TRANSLATE SCRIPTS
                                    self.translatingText(alternative?.transcript ?? "", translationCode: (ForeignLanguages.shared.selectedSTTLanguage?.sourceTransCode)!)
                                }
                            } else {
                                if let res = result.alternativesArray as? [SpeechRecognitionAlternative] {
                                    self.didShowValue?(res.first?.transcript ?? "")
                                }
                            }
                        }
                    }
                }
            }
            self.audioData = NSMutableData()
        }
    }
}
