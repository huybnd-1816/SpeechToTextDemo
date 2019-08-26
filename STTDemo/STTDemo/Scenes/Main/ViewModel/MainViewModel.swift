//
//  MainViewModel.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import AVFoundation
import googleapis

// We recommend sending samples in 100ms chunks
let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
    * Double(16000) /* samples/second */
    * 2 /* bytes/sample */);

final class MainViewModel: NSObject{
    private var transcripts: [CellData] = [] {
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
    var didPressCopyText: ((String) -> Void)?
    
    var arrConversion : [CellData] = []
    
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
        UIApplication.shared.isIdleTimerDisabled = true // Screen never sleep
        print("RECORDING START")
    }
    
    func stopAudio() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
        UIApplication.shared.isIdleTimerDisabled = false
        print("RECORDING STOP")
    }
    
    func restartRecord () {
        self.stopAudio()
        delay(0.2) {
            self.startAudio()
        }
    }
    
    private func translatingText( inputData: CellData, givenLangFromCode: String, givenLangToCode: String) {
        print("TRANSLATION: from \(givenLangFromCode) to \(givenLangToCode)")
        
        
        translationRepository.translateText(text: inputData.strTextRecognizedFromSpeech,
                                            sourceLangCode: givenLangFromCode,
                                            targetLangCode: givenLangToCode) { result in
            switch result {
            case .success(let response):
                guard let res = response?.translationData?.translations?.first?.translatedText,
                    res != "" else { return }
                print("TRANSLATE:", res)
                
                // update Transcript data
                var dataChange = self.transcripts[inputData.dataIndex]
                dataChange.strTextTranslated = res
                self.transcripts[inputData.dataIndex] = dataChange
                
                // write to firebase store
                self.writeTextToFireBase(text: dataChange.strTextRecognizedFromSpeech + "[&]" + res)

                // clear text video
                self.didShowValue?("...")
                
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

extension MainViewModel: UITableViewDataSource, TableCellDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transcripts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        let transcript = transcripts[indexPath.row]
        cell.configCell(transcript, givenIndexPath: indexPath)
        return cell
    }
    
    func didPressCopyText(at index: IndexPath) {
        let dataItem = self.transcripts[index.row]
        
        // copy to clipboard
        let pasteboard = UIPasteboard.general
        pasteboard.string = dataItem.strTextRecognizedFromSpeech
        
        self.didPressCopyText?(dataItem.strTextRecognizedFromSpeech)
    }
}

extension MainViewModel: AudioControllerDelegate {
    func processSampleData(_ data: Data) -> Void {
        audioData.append(data)
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData, languagueCode: LanguageHelper.shared.getCurrentSTT().langCodeSTT!) { [weak self] (response, error) in
                guard let self = self else {
                    return
                }

                if let error = error {
                    print("Did failed with error code : \(error.code) des: \(error.description)")
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
                                    let dataItem : CellData = CellData(givenTextRecog: alternative?.transcript ?? "",
                                                                       givenTextTranslated: "",
                                                                       givenIndex: self.transcripts.count,
                                                                       givenSenderType: .OnLeft)
                                    self.transcripts.append(dataItem)
                                    self.didShowValue?(alternative?.transcript ?? "")

                                    // TRANSLATE SCRIPTS
                                    self.translatingText(inputData: dataItem,
                                                         givenLangFromCode: LanguageHelper.shared.getCurrentSTT().langCodeSTT!,
                                                         givenLangToCode: LanguageHelper.shared.getCurrentTrans().langCodeTrans!)
                                    
                                    // continue record
                                    self.restartRecord()
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
        } else {
            // audio length to little, no need to do anything else here
        }
    }
}
