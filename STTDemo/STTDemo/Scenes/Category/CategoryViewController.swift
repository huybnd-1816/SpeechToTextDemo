//
//  CategoryViewController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 7/26/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class CategoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        navigationItem.title = "Category"
    }
    
    @IBAction func handleTranslateShortAudioButtonTapped(_ sender: Any) {
        let vc = ShortAudioViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func handleTranslateLongAudioButtonTapped(_ sender: Any) {
        let vc = LongAudioViewController.instantiate()
        navigationController?.pushViewController(vc, animated: true)
    }
}
