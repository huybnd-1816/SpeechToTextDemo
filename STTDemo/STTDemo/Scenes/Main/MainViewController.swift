//
//  ViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var translateButton: UIButton!
    
    private var viewModel: MainViewModel!
    var isRecording: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        viewModel = MainViewModel()
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        
        viewModel.didChanged = { [weak self] errorMessage in
            guard let self = self else { return }
            if let errorMessage = errorMessage {
                self.showAlert(title: "Error", message: errorMessage)
                print(errorMessage)
            } else {
                self.tableView.reloadData()
            }
        }
        
        viewModel.deselectedButton = { [weak self] in
            guard let self = self else { return }
            self.translateButton.setTitle("Start To Translate", for: .normal)
        }
    }
    
    @IBAction func handleTranscribeButtonTapped(_ sender: Any) {
        if !isRecording {
            translateButton.setTitle("Translating...", for: .normal)
            viewModel.startAudio()
        } else {
            translateButton.setTitle("Start To Translate", for: .normal)
            viewModel.stopAudio()
        }
        isRecording = !isRecording
    }
}

