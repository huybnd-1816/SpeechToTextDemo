//
//  NavigationController.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/5/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavigation()
    }
    
    private func configNavigation() {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
//        let attributes = [NSAttributedString.Key.font: UIFont(name: Fonts.SFsemibold.rawValue, size: 20)]
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes as [NSAttributedString.Key : Any]
    }
}
