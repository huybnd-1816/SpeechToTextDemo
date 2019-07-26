//
//  AudioViewModel.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

import AVFoundation

final class AudioViewModel: NSObject {
    private var audios: [RecordedAudio] = [] {
        didSet {
            didChanged?()
        }
    }
    
    var didChanged: (() -> Void)?
    
    override init() {
        super.init()
    }
    
    func fetchData() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        do {
            let audioPaths = try FileManager.default.contentsOfDirectory(at: paths[0], includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            audios.removeAll()
    
            for audio in audioPaths {
                print(audio)
                
                var myAudio = audio.absoluteString // Get audio's url
                if myAudio.contains(".wav") {
                    let findString = myAudio.components(separatedBy: "/") // Separate string has "/" into an array
                    myAudio = findString[findString.count - 1] // Get the original audio title
                    myAudio = myAudio.replacingOccurrences(of: "%20", with: " ")
                    myAudio = myAudio.replacingOccurrences(of: ".wav", with: "")
                    
                    let newAudio = RecordedAudio(audioName: myAudio, audioUrl: audio)
                    audios.append(newAudio)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func deleteAudio(_ fileUrl: URL) {
        do {
            try FileManager.default.removeItem(at: fileUrl)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension AudioViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return audios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AudioCell = tableView.dequeueReusableCell(for: indexPath)
        guard let audioName = audios[indexPath.row].audioName else { return UITableViewCell() }
        cell.configAudioCell(audioName)
        cell.didDeleteAudio = { [weak self] in
            guard let self = self else { return }
            
            AlertMessage.showMessage(title: "Message", msg: "Do you want to delete this audio?") { result in
                if result {
                    guard let fileURL = self.audios[indexPath.row].audioUrl else { return }
                    self.deleteAudio(fileURL)
                    self.audios.remove(at: indexPath.row)
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            // Get File Size
            let resourceValues = try audios[indexPath.row].audioUrl!.resourceValues(forKeys: [.fileSizeKey])
            let fileSize = resourceValues.fileSize!
            print("File size = " + ByteCountFormatter().string(fromByteCount: Int64(fileSize)))
            
            // Get Audio Duration
            let audioAsset = AVURLAsset.init(url: audios[indexPath.row].audioUrl!, options: nil)
            let duration = audioAsset.duration
            let durationInSeconds = CMTimeGetSeconds(duration)
            print(durationInSeconds)
        } catch {
            print(error.localizedDescription)
        }
    }
}

extension AudioViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
