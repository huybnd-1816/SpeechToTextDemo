//
//  UIViewController+.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/25/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


extension UIViewController {
    func showAlert(title: String?, message: String?) {
        let ac = UIAlertController(title: title,
                                   message: message,
                                   preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel)
        
        ac.addAction(okAction)
        present(ac, animated: true, completion: nil)
    }
    
    
    func showToast(message: String) {
        let sWidth = view.frame.width - 50
        let messageLabel = PaddingLabel()
        messageLabel.frame = CGRect(x: 0,
                          y: 0,
                          width: sWidth,
                          height: 45)
        messageLabel.center = CGPoint(x: view.frame.width / 2, y: 100)
        messageLabel.text = message
        messageLabel.font = UIFont.systemFont(ofSize: 14)
        messageLabel.textColor = .white
        messageLabel.textAlignment = .center
        messageLabel.backgroundColor = .white
        messageLabel.numberOfLines = 0
        messageLabel.layer.cornerRadius = 22.5
        messageLabel.clipsToBounds = true
        messageLabel.backgroundColor = UIColor(red: 255.0/255.0, green: 75.0/255.0, blue: 110.0/255.0, alpha: 1.0)
        
        view.addSubview(messageLabel)
        
        UIView.animate(withDuration: 2.0,
                       delay: 0.5,
                       options: .curveEaseOut,
                       animations: {
                        messageLabel.alpha = 0.0
        }, completion: { (_) in
            messageLabel.removeFromSuperview()
        })
    }
    
    func showFullAlert(title: String, msg: String, completion: ((Bool) -> Void)?) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            completion?(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func hideKeyboardWhenTapped() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func dismissKeyboard() {
        view.endEditing(true)
    }
}
