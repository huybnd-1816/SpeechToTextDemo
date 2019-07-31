//
//  AudioTranscriptVC.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//



final class AudioTranscriptVC: UIViewController {
    @IBOutlet private weak var audioTransciptTableView: UITableView!
    
    private var viewModel: AudioTranscriptVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        viewModel = AudioTranscriptVM()
        audioTransciptTableView.delegate = viewModel
        audioTransciptTableView.dataSource = viewModel
        audioTransciptTableView.tableFooterView = UIView(frame: .zero)
        audioTransciptTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        audioTransciptTableView.rowHeight = UITableView.automaticDimension
        audioTransciptTableView.estimatedRowHeight = 44
        
        viewModel.didChanged = { [weak self] in
            guard let self = self else { return }
            self.audioTransciptTableView.reloadData()
            
            // Scroll To Bottom
            let indexPath = IndexPath(
                row: self.audioTransciptTableView.numberOfRows(inSection:  self.audioTransciptTableView.numberOfSections - 1) - 1,
                section: self.audioTransciptTableView.numberOfSections - 1)
            self.audioTransciptTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}
