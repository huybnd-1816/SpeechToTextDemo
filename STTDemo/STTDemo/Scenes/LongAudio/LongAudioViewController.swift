//
//  LongAudioViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class LongAudioViewController: UIViewController {

    private let repoRepository = STTRepositoryImpl(api: APIService.shared)
    
    let storageLocationURL = "gs://fir-storagesample-b4ad2.appspot.com/audios/Japanese Audio Lessons for Beginners.wav"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Long Audio"
    }
    
    private func sendTranslationRequest() {
        repoRepository.transcribeLongAudio(audioURL: storageLocationURL, languageCode: STTLanguages.Japanese.getLangCode()) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let res = response?.name else { return }
                self.fetchAudioTranslation(res)
            case .failure(let error):
                print(error?.errorMessage ?? "")
            }
        }
    }
    
    private func fetchAudioTranslation(_ nameCode: String) {
        repoRepository.getAudioTransciption(nameCode: nameCode) {  result in
//            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                guard let res = response?.response?.results?.first?.alternatives,
                    let finished = response?.done else { return }
                if finished {
                    let alternative = res.max(by: { (a, b) -> Bool in
                        a.confidence! < b.confidence!
                    })
                    
//                    print(alternative?.transcript)
                }
            case .failure(let error):
                print(error?.errorMessage ?? "")
            }
        }
    }
    
    @IBAction func handleTranslateAudioButtonTapped(_ sender: Any) {
        sendTranslationRequest()
    }
}

extension LongAudioViewController: StoryboardSceneBased {
     static var sceneStoryboard = Storyboards.main
}
