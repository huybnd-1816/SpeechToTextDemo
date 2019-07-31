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
    
    private let translationRepository = TranslationRepositoryImpl(api: APIService.shared)
    private let sampleRate = 16000
    private var audioData: NSMutableData!
    var finished: Bool = false
    
    var didChanged: ((String?) -> Void)?
    var deselectedButton: (() -> Void)?
    
    override init() {
        super.init()
        transcripts.removeAll()
        AudioController.sharedInstance.delegate = self
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
    }
    
    func stopAudio() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
        print("RECORDING STOP")
    }
    
    private func translatingText(_ inputText: String) {
        translationRepository.translateText(text: inputText, sourceLangCode: TranslationLanguagues.English.getLangCode(), targetLangCode: TranslationLanguagues.Vietnamese.getLangCode()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let res = response?.translationData?.translations?.first?.translatedText,
                    res != "" else { return }
//                self.transcripts.append(res)
                print("TRANSLATE:", res)
//                self.writeTextToFireBase(text: res)
            case .failure(let err):
                print("ERROR: ", err?.errorMessage ?? "")
            }
        }
    }
    
    private func writeTextToFireBase(text: String) {
        FirebaseService.shared.write(message: text)
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
        audioData.append(data)
        // We recommend sending samples in 100ms chunks
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
            * Double(sampleRate) /* samples/second */
            * 2 /* bytes/sample */);

        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData) { [weak self] (response, error) in
                guard let self = self else {
                    return
                }

                if let error = error {
                    self.didChanged?(error.localizedFailureReason)
                    self.deselectedButton?()
                    self.stopAudio()
                } else if let response = response {
                    self.finished = false
                    print(response)
                    
                    for result in response.resultsArray! {
                        if let result = result as? StreamingRecognitionResult {
                            if result.isFinal {
                                self.finished = true
//                                print(result.alternativesArray)

                                if let res = result.alternativesArray as? [SpeechRecognitionAlternative] {
                                    let alternative =  res.max(by: { (a, b) -> Bool in
                                        a.confidence < b.confidence
                                    })

                                    self.transcripts.append(alternative?.transcript ?? "")
                                    // TRANSLATE SCRIPTS
                                    self.translatingText(alternative?.transcript ?? "")
                                }
                            }
                        }
                    }

                    if self.finished {
                        self.stopAudio()
                        self.startAudio()
                    }
                }
            }
            self.audioData = NSMutableData()
        }
    }
}
