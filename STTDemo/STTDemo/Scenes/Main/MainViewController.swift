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
    @IBOutlet private weak var translateButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var recordTextView: UITextView!
    
    private var backButton: UIBarButtonItem!
    private var widthButton: CGFloat!
    private var viewModel: MainViewModel!
    private var isRecording: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        setupWidthConstraintForTranslationButton()
        setupBarButton()
    }
    
    private func setupWidthConstraintForTranslationButton() {
        widthButton = UIScreen.main.bounds.width - 128
        translateButtonWidthConstraint.constant = widthButton
    }
    
    private func setupBarButton() {
        backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "ic-back"), style: .plain, target: self, action: #selector(handleBackButtonTapped))
        navigationItem.leftBarButtonItem = backButton
    }
    
    private func config() {
        navigationItem.hidesBackButton = false
        viewModel = MainViewModel()
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 20
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.separatorStyle = .none
        tableView.register(UINib(nibName: "TableCell", bundle: nil), forCellReuseIdentifier: "TableCell")
        
        viewModel.didChanged = { [weak self] errorMessage in
            guard let self = self else { return }
            if let errorMessage = errorMessage {
                self.showAlert(title: "Error", message: errorMessage)
                print(errorMessage)
            } else {
                self.tableView.reloadData()
                
                // Scroll To Bottom
                let indexPath = IndexPath(
                    row: self.tableView.numberOfRows(inSection:  self.tableView.numberOfSections - 1) - 1,
                    section: self.tableView.numberOfSections - 1)
                guard indexPath.row >= 0 else { return }
                self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        viewModel.deselectedButton = { [weak self] in
            guard let self = self else { return }
            self.translateButton.setTitle("Start To Translate", for: .normal)
            self.animationButtonWhenStopTranslating()
        }
        
        viewModel.audioName = navigationItem.title
        
        viewModel.didShowValue = { [weak self] record in
            guard let self = self, record != "" else { return }
            self.recordTextView.text = record
        }
    }
    
    @IBAction func handleTranscribeButtonTapped(_ sender: Any) {
        // Check Internet
        guard Reachability.isConnectedToNetwork() else {
            showAlert(title: "Error", message: "Internet connection not available")
            return
        }
        
        if !isRecording {
            translateButton.setTitle("...", for: .normal)
            animationButtonWhenTranslating()
            viewModel.startAudio()
        } else {
            translateButton.setTitle("Start To Translate", for: .normal)
            animationButtonWhenStopTranslating()
            viewModel.stopAudio()
        }
        isRecording = !isRecording
    }
    
    private func animationButtonWhenTranslating() {
        self.translateButtonWidthConstraint.constant = 64
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
            self.addPulse()
        })
        
    }
    
    private func animationButtonWhenStopTranslating() {
        self.translateButtonWidthConstraint.constant = widthButton
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
        })
        removePulse()
    }
    
    @objc
    func handleBackButtonTapped() {
        if AudioController.sharedInstance.isRecording {
            showFullAlert(title: "Message", msg: "You will lost the record if back to main page") { [weak self] res in
                guard let self = self else { return }
                if res {
                    self.viewModel.stopAudio()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}

extension MainViewController {
    func addPulse(){
        let pulse = Pulsing(radius: 80, position: translateButton.center)
        pulse.animationDuration = 1.5
        pulse.backgroundColor = UIColor(red: 255.0/255.0, green: 75.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor
        
        self.view.layer.insertSublayer(pulse, below: translateButton.layer)
    }
    
    func removePulse() {
        if let sublayers = view.layer.sublayers {
            for layer in sublayers {
                if layer.name == "pulsingLayer" {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}

extension MainViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
