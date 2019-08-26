//
//  ListLanguagesVC.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/31/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class ListLanguagesVC: UIViewController {
    @IBOutlet private weak var languagesTableView: UITableView!
    @IBOutlet private weak var viewLeadingConstraint: NSLayoutConstraint!
    
    var languageSelectionMode : LanguageSelectionMode = .SpeechToText
    private var viewModel: ListLanguagesVM!
    var didChangedLanguage:((_ languageIndex : Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        viewModel = ListLanguagesVM()
        viewModel.languageSelectionMode = self.languageSelectionMode
        languagesTableView.delegate = viewModel
        languagesTableView.dataSource = viewModel
        languagesTableView.register(UINib(nibName: "LanguageCell", bundle: nil), forCellReuseIdentifier: "LanguageCell")
        languagesTableView.tableFooterView = UIView(frame: .zero)
        languagesTableView.rowHeight = UITableView.automaticDimension
        languagesTableView.estimatedRowHeight = 64
        
        // Set view size of iphone 5/5s
        if UIDevice.current.screenType == UIDevice.ScreenType.iPhones_5_5s_5c_SE {
            viewLeadingConstraint.constant = 16
        }
    }
    
    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true)
        didChangedLanguage?(1)
    }
}

extension ListLanguagesVC: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
