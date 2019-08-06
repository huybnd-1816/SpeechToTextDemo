//
//  AudioTranscriptVM.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class AudioTranscriptVM: NSObject {
    private var audioTranscripts: [AudioTranscript] = [] {
        didSet {
            didChanged?()
        }
    }
    
    var didChanged: (() -> Void)?
    var didMoveToDetail: ((String) -> Void)?
    
    override init() {
        super.init()
        reloadData()
    }
    
    private func reloadData() {
        audioTranscripts.removeAll()
        FirebaseService.shared.addObserverReadRoot { audiosInfo in
            guard audiosInfo.count > 0 else { return }
            
            audiosInfo.forEach {
                let date = $0.1
                let audio = $0.0
                
                if !self.audioTranscripts.contains(where: { $0.title == date }) { // If audioTranscripts does not contain date
                    let audioTranscript = AudioTranscript(title: date)
                    audioTranscript.audios.append(audio)
                    self.audioTranscripts.append(audioTranscript)
                } else {
                    self.audioTranscripts = self.audioTranscripts.filter { $0.title == date }
                    self.audioTranscripts.first?.audios.append(audio)
                    self.didChanged?()
                }
            }
            
            self.audioTranscripts = self.audioTranscripts.sorted {
                $0.title < $1.title
            }
        }
    }
}

extension AudioTranscriptVM: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return audioTranscripts[section].title.stringBy(format: "dd-MM-yyyy")
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
}

extension AudioTranscriptVM: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return audioTranscripts.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audioTranscripts[section].audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AudioCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configCell(audio: audioTranscripts[indexPath.section].audios[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioName = audioTranscripts[indexPath.section].audios[indexPath.row]
        didMoveToDetail?(audioName)
        // Change the selected background view of the cell.
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
