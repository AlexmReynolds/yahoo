//
//  YCompaniesListViewController.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import UIKit

class YCompaniesListViewController: UIViewController {
    let viewModel = YCompaniesListViewModel()
    var castView: YCompaniesListView! //easier to talk to later vs casting self.view all the time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.title
        self.viewModel.modelDidUpdate = { [weak self] in
            self?.castView.tableView.reloadData()
        }
        
        Task { @MainActor in
            do {
                try await self.viewModel.loadData()
                self.castView.tableView.reloadData()
            } catch {
                //TODO: Show Error in ui
            }
        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(self.settingsTapped))
    }

    override func loadView() {
        let view = YCompaniesListView()
        self.castView = view
        view.tableView.dataSource = self.viewModel
        view.tableView.delegate = self
        self.view = view
    }
    
    @objc func settingsTapped () {
        let vc = YSettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension YCompaniesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
     //   let vc = self.viewModel.detailController(at: indexPath)
    //    self.navigationController?.pushViewController(vc, animated: true)
    }
}
