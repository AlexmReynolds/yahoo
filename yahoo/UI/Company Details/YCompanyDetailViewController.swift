//
//  YCompanyDetailViewController.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import UIKit
protocol YCompanyDetailViewControllerDelegate: AnyObject {
    func favoriteUpdated()
}

class YCompanyDetailViewController: UIViewController {
    weak var delegate: YCompanyDetailViewControllerDelegate? = nil
    let viewModel: YCompanyDetailViewModel
    var castView: YCompanyDetailView! //easier to talk to later vs casting self.view all the time
    init(viewModel: YCompanyDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.viewModel.title

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(self.favoriteTapped))
    }

    override func loadView() {
        let view = YCompanyDetailView()
        self.castView = view
        view.load(company: self.viewModel.company)
        self.view = view
    }
    
    @objc func favoriteTapped() {
        self.viewModel.favoriteCompany()
        self.delegate?.favoriteUpdated()
    }
 
}
