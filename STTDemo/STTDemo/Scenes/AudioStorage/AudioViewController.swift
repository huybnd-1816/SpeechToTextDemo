//
//  AudioViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/24/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class AudioViewController: UIViewController {
    @IBOutlet private weak var audioTableView: UITableView!
    
    private var viewModel: AudioViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.fetchData()
    }
    
    private func config() {
        viewModel = AudioViewModel()
        audioTableView.delegate = viewModel
        audioTableView.dataSource = viewModel
        audioTableView.register(UINib(nibName: "AudioCell", bundle: nil), forCellReuseIdentifier: "AudioCell")
        audioTableView.tableFooterView = UIView(frame: .zero)
        audioTableView.rowHeight = UITableView.automaticDimension
        audioTableView.estimatedRowHeight = 64
        
        viewModel.didChanged = { [weak self] in
            guard let self = self else { return }
            UIView.transition(with: self.audioTableView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.audioTableView.reloadData() })
            
        }
    }
}
