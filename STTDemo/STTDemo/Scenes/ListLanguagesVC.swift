//
//  ListLanguagesVC.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class ListLanguagesVC: UIViewController {
    @IBOutlet private weak var languagesTableView: UITableView!
    
    private var viewModel: ListLanguagesVM!
    var didChangedLanguage:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        viewModel = ListLanguagesVM()
        languagesTableView.delegate = viewModel
        languagesTableView.dataSource = viewModel
        languagesTableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        languagesTableView.tableFooterView = UIView(frame: .zero)
        languagesTableView.rowHeight = UITableView.automaticDimension
        languagesTableView.estimatedRowHeight = 44
    }
    
    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true)
        didChangedLanguage?()
    }
}

extension ListLanguagesVC: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
