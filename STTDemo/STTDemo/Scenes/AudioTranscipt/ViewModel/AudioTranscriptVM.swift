//
//  AudioTranscriptVM.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class AudioTranscriptVM: NSObject {
    private var messages: [MessageModel] = [] {
        didSet {
            didChanged?()
        }
    }
    
    var didChanged: (() -> Void)?
    
    override init() {
        super.init()
        reloadData()
    }
    
    private func reloadData() {
        FirebaseService.shared.addObserverRead { messages in
            // update data source
            self.messages.append(contentsOf: messages)
        }
    }
}

extension AudioTranscriptVM: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AudioTranscriptVM: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configCell(data: messages[indexPath.row])
        return cell
    }
}
