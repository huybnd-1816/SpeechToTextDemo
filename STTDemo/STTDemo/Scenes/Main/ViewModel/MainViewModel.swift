//
//  MainViewModel.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

final class MainViewModel: NSObject{
    private let repoRepository = STTRepositoryImpl(api: APIService.shared)
    private var results: [Alternatives] = [] {
        didSet {
            didChanged?()
        }
    }
    
    var didChanged: (() -> Void)?
    var apiIsCalled: Bool = false
    
    override init() {
        super.init()
    }
    
    func soundFilePath() -> URL? {
        let folderURL = URL(fileURLWithPath: Bundle.main.resourcePath!)
        do {
            let audioPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for audio in audioPath {
                let myAudio = audio.absoluteString // Get song's url
                if myAudio.contains(".wav") {
                    return audio
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
    
    func transcribeData() {
        guard !apiIsCalled else { return }
        guard let soundPath = soundFilePath() else { return }
        do {
            let audioData = try Data(contentsOf: soundPath)
            apiIsCalled = true
            repoRepository.transcribeAudio(audioData: audioData, languagueCode: Languages.Japanese.getLangCode()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    guard let res = response?.results?.first?.alternatives else { return }
                    self.results = res.sorted {
                        $0.confidence! > $1.confidence!
                    }
                     print(self.results)
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

extension MainViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
}

extension MainViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TableCell = tableView.dequeueReusableCell(for: indexPath)
        guard let transcript = results[indexPath.row].transcript else { return UITableViewCell() }
        cell.configCell(transcript)
        return cell
    }
}
