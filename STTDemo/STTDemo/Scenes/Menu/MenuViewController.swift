//
//  MenuViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/5/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class MenuViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        navigationItem.title = "Home"
    }
    
    @IBAction func handleRecordingAutomaticallyButtonTapped(_ sender: Any) {
        let vc = CreateRecordVC.instantiate()
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        vc.transitingToMain = { [weak self] title in
            guard let self = self else { return }
            let vc = MainViewController.instantiate()
            vc.navigationItem.title = title
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        present(vc, animated: true)
    }
    
    @IBAction func handleRecordingManuallyButtonTapped(_ sender: Any) {
        let vc = RecordingManuallyViewController.instantiate()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
}
