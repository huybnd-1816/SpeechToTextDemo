//
//  DetailViewModel.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/6/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

final class DetailViewModel: NSObject {
    private var messages: [MessageModel] = [] {
        didSet {
            didChanged?()
        }
    }
    
    var didChanged: (() -> Void)?
    var didPressCopyText: ((String) -> Void)?
    
    override init() {
        super.init()
    }
    
    func reloadData(_ audioName: String) {
        messages.removeAll()
        
        FirebaseService.shared.addObserverRead(audioName: audioName) { messages in
            guard messages.count > 0 else { return }
            // update data source
            self.messages.append(contentsOf: messages)
        }
    }
}

extension DetailViewModel: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension DetailViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessageCell = tableView.dequeueReusableCell(for: indexPath)
        cell.delegate = self
        cell.configDetailCell(messages[indexPath.row], givenIndexPath: indexPath)
        return cell
    }
}

extension DetailViewModel: MessageCellDelegate {
    func didPressCopyText(_ copyText: String) {
        // copy to clipboard
        let pasteboard = UIPasteboard.general
        pasteboard.string = copyText

        self.didPressCopyText?(copyText)
    }
}
