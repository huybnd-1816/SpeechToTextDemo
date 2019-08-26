//
//  RecordManualViewModel.swift
//  STTDemo
//
//  Created by vu.hoang.anh on 8/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import UIKit
import googleapis
import AVFoundation

enum OnTranslating : Int {
    case None = 0
    case Left
    case Right
}

class RecordManualViewModel: NSObject {
    
    // properties
    private let translationRepository = TranslationRepositoryImpl(api: APIService.shared)
    private let sampleRate = 16000
    private var audioData: NSMutableData!
    private var finished: Bool = false
    
    var onTranslating : OnTranslating = .Left
    
    var didChanged: ((String?) -> Void)?
    var didShowValue: ((String) -> Void)?
    var didPressCopyText: ((String) -> Void)?
    
    private var transcripts: [CellData] = [] {
        didSet {
            didChanged?(nil)
        }
    }
    
    override init() {
        super.init()
        transcripts.removeAll()
        AudioController.sharedInstance.delegate = self
        
    }
}

extension RecordManualViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension RecordManualViewModel: UITableViewDataSource, TableCellDelegate {
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
    
    // cell delegate
    func didPressCopyText(at index: IndexPath) {
        let dataItem = self.transcripts[index.row]
        
        // copy to clipboard
        let pasteboard = UIPasteboard.general
        pasteboard.string = dataItem.strTextRecognizedFromSpeech
        
        self.didPressCopyText?(dataItem.strTextRecognizedFromSpeech)
    }
}

// MARK: - Handle Translation service, Speech Recognizing service
extension RecordManualViewModel {
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
                                                    
//                                                    // write to firebase store
//                                                    self.writeTextToFireBase(text: dataChange.strTextRecognizedFromSpeech + "[&]" + res)
//
//                                                    // clear text video
                                                    self.didShowValue?("...")
                                                    
                                                case .failure(let err):
                                                    print("ERROR: ", err?.errorMessage ?? "")
                                                }
        }
    }
}

extension RecordManualViewModel : AudioControllerDelegate {
    func processSampleData(_ data: Data) -> Void {
        audioData.append(data)
        
        var processLanguageCode = ""
        switch onTranslating {
        case .Left:
            processLanguageCode = LanguageHelper.shared.getCurrentSpeakerLeft().langCodeSTT!
        case .Right:
            processLanguageCode = LanguageHelper.shared.getCurrentSpeakerRight().langCodeSTT!
        default:
            processLanguageCode = LanguageHelper.shared.getCurrentSpeakerLeft().langCodeSTT!
        }
        
        if (audioData.length > chunkSize) {
            SpeechRecognitionService.sharedInstance.streamAudioData(audioData,
                                                                    languagueCode: processLanguageCode) { [weak self] (response, error) in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    print("Did failed with error code : \(error.code) des: \(error.description)")
                    self.didChanged?(error.localizedFailureReason)
//                    self.deselectedButton?()
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
                                                                       givenSenderType: (self.onTranslating == .Left ? .OnLeft : .OnRight))
                                    self.transcripts.append(dataItem)
                                    self.didShowValue?(alternative?.transcript ?? "")
                                    
                                    // TRANSLATE SCRIPTS
                                    if self.onTranslating == .Left {
                                        self.translatingText(inputData: dataItem,
                                                             givenLangFromCode: LanguageHelper.shared.getCurrentSpeakerLeft().langCodeTrans!,
                                                             givenLangToCode: LanguageHelper.shared.getCurrentSpeakerRight().langCodeTrans!)
                                    } else if self.onTranslating == .Right {
                                        self.translatingText(inputData: dataItem,
                                                             givenLangFromCode: LanguageHelper.shared.getCurrentSpeakerRight().langCodeTrans!,
                                                             givenLangToCode: LanguageHelper.shared.getCurrentSpeakerLeft().langCodeTrans!)
                                    }
                                    
//                                    // continue record
//                                    self.restartRecord()
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
