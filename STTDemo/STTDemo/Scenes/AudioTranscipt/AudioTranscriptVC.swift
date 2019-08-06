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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        viewModel.reloadData()
    }
    
    private func config() {
        navigationItem.title = "Audio"
        viewModel = AudioTranscriptVM()
        audioTransciptTableView.delegate = viewModel
        audioTransciptTableView.dataSource = viewModel
        audioTransciptTableView.tableFooterView = UIView(frame: .zero)
        audioTransciptTableView.register(UINib(nibName: "AudioCell", bundle: nil), forCellReuseIdentifier: "AudioCell")
        audioTransciptTableView.rowHeight = UITableView.automaticDimension
        audioTransciptTableView.estimatedRowHeight = 44
        
        viewModel.didChanged = { [weak self] in
            guard let self = self else { return }
            self.audioTransciptTableView.reloadData()
        }
        
        viewModel.didMoveToDetail = { [weak self] name in
            guard let self = self else { return }
            let vc = DetailViewController.instantiate()
            vc.audioName = name
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
