//
//  YSettingsViewController.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import UIKit

class YSettingsViewController: UIViewController {
    let viewModel = YSettingsViewModel()
    var castView: YSettingsView! //easier to talk to later vs casting self.view all the time
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.title
    }

    override func loadView() {
        let view = YSettingsView()
        self.castView = view
        view.sortOrderSegment.selectedSegmentIndex = self.viewModel.sortOrderSelectedIndex
        view.sortOrderSegment.addTarget(self, action: #selector(self.sortSegmentChanged), for: .valueChanged)
        self.view = view
    }
    
    @objc func sortSegmentChanged() {
        self.viewModel.updateSortOrder(self.castView.sortOrderSegment.selectedSegmentIndex)
    }
}

