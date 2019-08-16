//
//  DetailViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/6/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class DetailViewController: UIViewController {
    @IBOutlet private weak var detailTableView: UITableView!
    
    private var viewModel: DetailViewModel!
    var audioName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        navigationItem.title = audioName
        viewModel = DetailViewModel()
        detailTableView.delegate = viewModel
        detailTableView.dataSource = viewModel
        detailTableView.tableFooterView = UIView(frame: .zero)
        detailTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        detailTableView.rowHeight = UITableView.automaticDimension
        detailTableView.estimatedRowHeight = 44
        
        detailTableView.separatorStyle = .none
                
        viewModel.reloadData(audioName)
        
        viewModel.didChanged = { [weak self] in
            guard let self = self else { return }
            self.detailTableView.reloadData()
            
            
            // Scroll To Bottom
            let indexPath = IndexPath(
                row: self.detailTableView.numberOfRows(inSection:  self.detailTableView.numberOfSections - 1) - 1,
                section: self.detailTableView.numberOfSections - 1)
            self.detailTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

extension DetailViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
