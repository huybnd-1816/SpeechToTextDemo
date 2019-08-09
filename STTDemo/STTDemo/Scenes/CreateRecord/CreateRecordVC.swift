//
//  CreateRecordVC.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/5/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class CreateRecordVC: UIViewController {
    @IBOutlet private weak var recordNameTextField: UITextField!
    @IBOutlet private weak var createdDateTextField: UITextField!
    @IBOutlet private weak var viewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var translateFromButton: UIButton!
    @IBOutlet private weak var translateToButton: UIButton!
    
    var transitingToMain: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTapped()
        config()
    }
    
    private func config() {
        // Set createdDateTextfield's value
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let today = formatter.string(from: Date())
        createdDateTextField.text = today
        
        // Set view size of iphone 5/5s
        if UIDevice.current.screenType == UIDevice.ScreenType.iPhones_5_5s_5c_SE {
            viewLeadingConstraint.constant = 16
        }
        translateFromButton.setTitle(ForeignLanguages.shared.selectedSTTLanguage?.name, for: .normal)
        translateToButton.setTitle(ForeignLanguages.shared.selectedTransToLanguage?.name, for: .normal)
    }

    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func handleDoneButtonTapped(_ sender: Any) {
        guard let recordName = recordNameTextField.text,
            recordNameTextField.text?.removeWhitespace() != "" else {
                showAlert(title: "Error", message: "The record's name is empty")
                return
        }
        
        if recordName.hasSpecialCharacters() {
            showAlert(title: "Error", message: "The record's name has special characters")
            return
        }

        dismiss(animated: true)
        transitingToMain?(recordName)
    }
    
    @IBAction func handleTranslateFromButtonTapped(_ sender: Any) {
        let vc = ListLanguagesVC.instantiate()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        vc.didChangedLanguage = { [weak self] in
            guard let self = self else { return }
            self.translateFromButton.setTitle(ForeignLanguages.shared.selectedSTTLanguage?.name, for: .normal)
        }
    }
    
    @IBAction func handleTranslateToButtonTapped(_ sender: Any) {
        let vc = ListTransLanguagesVC.instantiate()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true)
        
        vc.didChangedLanguage = { [weak self] in
            guard let self = self else { return }
            self.translateToButton.setTitle(ForeignLanguages.shared.selectedTransToLanguage?.name, for: .normal)
        }
    }
}

extension CreateRecordVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension CreateRecordVC: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
