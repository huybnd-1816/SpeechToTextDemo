//
//  SpeechRecognitionService.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import googleapis

let HOST = "speech.googleapis.com"

typealias SpeechRecognitionCompletionHandler = (StreamingRecognizeResponse?, NSError?) -> (Void)

final class SpeechRecognitionService {
    var sampleRate: Int = 16000
    private var streaming = false
    
    private var client: Speech!
    private var writer: GRXBufferedPipe!
    private var call: GRPCProtoCall!
    
    static let sharedInstance = SpeechRecognitionService()
    
    func streamAudioData(_ audioData: NSData, languagueCode: String,  completion: @escaping SpeechRecognitionCompletionHandler) {
        if (!streaming) {
            // if we aren't already streaming, set up a gRPC connection
            client = Speech(host: HOST)
            writer = GRXBufferedPipe()
            call = client.rpcToStreamingRecognize(withRequestsWriter: writer,
                                                  eventHandler: { (done, response, error) in
                    completion(response, error as NSError?)
            })
            
            // authenticate using an as key obt?ained from the Google Cloud Console
            call.requestHeaders.setObject(NSString(string: APIKey.apiKey),
                                          forKey:NSString(string:"X-Goog-Api-Key"))
            // if the API key has a bundle ID restriction, specify the bundle ID like this
            call.requestHeaders.setObject(NSString(string: Bundle.main.bundleIdentifier!),
                                          forKey: NSString(string:"X-Ios-Bundle-Identifier"))
            call.timeout = 5000
            call.start()
            streaming = true
            
            // send an initial request message to configure the service
            let recognitionConfig = RecognitionConfig()
            recognitionConfig.encoding = .linear16
            recognitionConfig.sampleRateHertz = Int32(sampleRate)
            recognitionConfig.languageCode = languagueCode
            recognitionConfig.maxAlternatives = 30
            recognitionConfig.enableWordTimeOffsets = true
            recognitionConfig.profanityFilter = true
            
            let streamingRecognitionConfig = StreamingRecognitionConfig()
            streamingRecognitionConfig.config = recognitionConfig
            streamingRecognitionConfig.singleUtterance = false
            streamingRecognitionConfig.interimResults = true // if set 'true', it shows temp results with "is_final" flag is false
            
            let streamingRecognizeRequest = StreamingRecognizeRequest()
            streamingRecognizeRequest.streamingConfig = streamingRecognitionConfig
            
            writer.writeValue(streamingRecognizeRequest)
        }
        
        // send a request message containing the audio data
        let streamingRecognizeRequest = StreamingRecognizeRequest()
        streamingRecognizeRequest.audioContent = audioData as Data
        writer.writeValue(streamingRecognizeRequest)
    }
    
    func stopStreaming() {
        if (!streaming) {
            return
        }
        writer.finishWithError(nil)
        streaming = false
    }
    
    func isStreaming() -> Bool {
        return streaming
    }
}
