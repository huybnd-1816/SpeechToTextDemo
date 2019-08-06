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
    @IBOutlet weak var viewLeadingConstraint: NSLayoutConstraint!
    
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
    }

    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func handleDoneButtonTapped(_ sender: Any) {
        guard recordNameTextField.text != nil,
            recordNameTextField.text?.removeWhitespace() != "" else {
                showAlert(title: "Error", message: "The record's name is empty")
                return
        }

        dismiss(animated: true)
        transitingToMain?(recordNameTextField.text!)
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
