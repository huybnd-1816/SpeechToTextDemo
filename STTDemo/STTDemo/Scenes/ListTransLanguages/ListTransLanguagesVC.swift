//
//  ListTransLanguages.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/9/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class ListTransLanguagesVC: UIViewController {
    @IBOutlet private weak var transLanguagesTableView: UITableView!
    @IBOutlet private weak var viewLeadingConstraint: NSLayoutConstraint!
    
    private var viewModel: ListTransLanguagesVM!
    var didChangedLanguage:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        viewModel = ListTransLanguagesVM()
        transLanguagesTableView.delegate = viewModel
        transLanguagesTableView.dataSource = viewModel
        transLanguagesTableView.register(UINib(nibName: "TransLanguageCell", bundle: nil), forCellReuseIdentifier: "TransLanguageCell")
        transLanguagesTableView.tableFooterView = UIView(frame: .zero)
        transLanguagesTableView.rowHeight = UITableView.automaticDimension
        transLanguagesTableView.estimatedRowHeight = 64
        
        // Set view size of iphone 5/5s
        if UIDevice.current.screenType == UIDevice.ScreenType.iPhones_5_5s_5c_SE {
            viewLeadingConstraint.constant = 16
        }
    }
    
    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true)
        didChangedLanguage?()
    }
}

extension ListTransLanguagesVC: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
