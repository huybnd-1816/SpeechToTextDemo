//
//  ListTransLanguagesVM.swift
//  STTDemo
//
//  Created by nguyen.duc.huyb on 8/9/19.
//  Copyright © 2019 nguyen.duc.huyb. All rights reserved.
//

final class ListTransLanguagesVM: NSObject {
    override init() {
        super.init()
    }
}

extension ListTransLanguagesVM: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ListTransLanguagesVM: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ForeignLanguages.shared.translatingLanguages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TransLanguageCell = tableView.dequeueReusableCell(for: indexPath)
        guard let langName = ForeignLanguages.shared.translatingLanguages[indexPath.row].name,
            let isSelected = ForeignLanguages.shared.translatingLanguages[indexPath.row].isSelected else { return UITableViewCell() }
        cell.config(langName: langName, isSelected: isSelected)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<ForeignLanguages.shared.listLanguages.count {
            ForeignLanguages.shared.translatingLanguages[i].isSelected = false
        }
        
        ForeignLanguages.shared.translatingLanguages[indexPath.row].isSelected = true
        tableView.reloadData()
    }
}
