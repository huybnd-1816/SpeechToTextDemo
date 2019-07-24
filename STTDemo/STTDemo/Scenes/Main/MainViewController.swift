//
//  ViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/23/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel: MainViewModel!
    
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
        
        viewModel.didChanged = { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    @IBAction func handleTranscribeButtonTapped(_ sender: Any) {
        viewModel.transcribeData()
    }
    
}

