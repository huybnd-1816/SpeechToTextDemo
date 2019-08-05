//
//  ListLanguagesVM.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/1/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//


final class ListLanguagesVM: NSObject {
    override init() {
        super.init()
    }
}

extension ListLanguagesVM: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListLanguagesVM: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ForeignLanguages.shared.listLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: LanguageCell = tableView.dequeueReusableCell(for: indexPath)
        guard let langName = ForeignLanguages.shared.listLanguages[indexPath.row].name,
            let isSelected = ForeignLanguages.shared.listLanguages[indexPath.row].isSelected else { return UITableViewCell() }
        cell.config(langName: langName, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<ForeignLanguages.shared.listLanguages.count {
            ForeignLanguages.shared.listLanguages[i].isSelected = false
        }
        
        ForeignLanguages.shared.listLanguages[indexPath.row].isSelected = true
        tableView.reloadData()
    }
}
