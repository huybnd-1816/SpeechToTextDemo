//
//  ShortAudioViewModel.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

final class ShortAudioViewModel: NSObject {
    private let repoRepository = STTRepositoryImpl(api: APIService.shared)
    
    private var results: [Alternatives] = [] {
        didSet {
            didChanged?()
        }
    }
    
    var didChanged: (() -> Void)?
    private var apiIsCalled: Bool = false
    
    override init() {
        super.init()
    }
    
    func transcribeData(_ audioPath: URL) {
        guard !apiIsCalled else { return }
        
        do {
            let audioData = try Data(contentsOf: audioPath)
            apiIsCalled = true
            repoRepository.transcribeAudio(audioData: audioData, languagueCode: Languages.Vietnamese.getLangCode()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    guard let res = response?.results?.first?.alternatives else { return }
                    self.results = res.sorted {
                        $0.confidence! > $1.confidence!
                    }
                case .failure(let error):
                    print(error?.errorMessage ?? "")
                }
                self.apiIsCalled = false
            }
        } catch let error {
            print("ERROR: ", error.localizedDescription)
            apiIsCalled = false
        }
    }
}

extension ShortAudioViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ShortAudioViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ShortAudioCell = tableView.dequeueReusableCell(for: indexPath)
        guard let transcript = results[indexPath.row].transcript else { return UITableViewCell() }
        cell.configShortAudioCell(transcript)
        return cell
    }
}
