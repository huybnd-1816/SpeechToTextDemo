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
    @IBOutlet private weak var vietnameseButton: UIButton!
    @IBOutlet private weak var englishButton: UIButton!
    
    
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
        
        vietnameseButton.isSelected = ForeignLanguages.shared.translatingLanguagues[0].isSelected
        englishButton.isSelected = ForeignLanguages.shared.translatingLanguagues[1].isSelected
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
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        for i in 0..<ForeignLanguages.shared.translatingLanguagues.count {
            ForeignLanguages.shared.translatingLanguagues[i].isSelected = false
        }

        if sender == vietnameseButton {
            ForeignLanguages.shared.translatingLanguagues[0].isSelected = true
        } else if sender == englishButton {
            ForeignLanguages.shared.translatingLanguagues[1].isSelected = true
        }
        
        vietnameseButton.isSelected = ForeignLanguages.shared.translatingLanguagues[0].isSelected
        englishButton.isSelected = ForeignLanguages.shared.translatingLanguagues[1].isSelected
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
