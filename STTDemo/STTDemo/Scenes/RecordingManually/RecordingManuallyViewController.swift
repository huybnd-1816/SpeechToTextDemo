//
//  RecordingManuallyViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/22/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class RecordingManuallyViewController: UIViewController {

    @IBOutlet private weak var recordingTextView: UITextView!
    @IBOutlet private weak var translatedTextView: UITextView!
    @IBOutlet private weak var leftView: UIView!
    @IBOutlet private weak var rightView: UIView!
    @IBOutlet private weak var leftButton: UIButton!
    @IBOutlet private weak var rightButton: UIButton!
    
    private var isRecording: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizer()
        config()
    }
    
    private func config() {
        recordingTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 0, right: 16)
        translatedTextView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 8, right: 16)
    }
    
    private func setupGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLeftButtonTapped))
        leftButton.addGestureRecognizer(longPressGesture)
        
        let longPressGesture2 = UILongPressGestureRecognizer(target: self, action: #selector(handleRightButtonTapped))
        rightButton.addGestureRecognizer(longPressGesture2)
    }
    
    @objc
    private func handleLeftButtonTapped(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
           animationButtonWhenStopTranslating()
        }
        else if sender.state == .began {
            animationButtonWhenTranslating(leftView)
        }
    }
    
    @objc
    private func handleRightButtonTapped(_ sender: UIGestureRecognizer) {
        if sender.state == .ended {
            animationButtonWhenStopTranslating()
        }
        else if sender.state == .began {
            animationButtonWhenTranslating(rightView)
        }
    }
    
    private func animationButtonWhenTranslating(_ view: UIView) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
            self.addPulse(view)
        })
        isRecording = true
    }
    
    private func animationButtonWhenStopTranslating() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveLinear], animations: {
            self.view.layoutIfNeeded()
        })
        removePulse()
        isRecording = false
    }
}

extension RecordingManuallyViewController {
    func addPulse(_ view: UIView){
        let pulse = Pulsing(radius: 300, position: view.center)
        pulse.animationDuration = 1.0
        pulse.backgroundColor = UIColor(red: 255.0/255.0, green: 75.0/255.0, blue: 110.0/255.0, alpha: 1.0).cgColor
        
        self.view.layer.insertSublayer(pulse, below: view.layer)
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

extension RecordingManuallyViewController : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView == recordingTextView || textView == translatedTextView {
            return false
        }
        return true
    }
}

extension RecordingManuallyViewController: StoryboardSceneBased {
    static var sceneStoryboard: UIStoryboard = Storyboards.main
}
