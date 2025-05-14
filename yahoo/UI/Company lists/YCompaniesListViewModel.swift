//
//  YCompaniesListViewModel.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import UIKit

class YCompaniesListViewModel: NSObject, UITableViewDataSource {
    let title = NSLocalizedString("Companies", comment: "company list title")
    var companies = [YCompany]()
    var modelDidUpdate: (()->Void)? = nil
    private var settings = YAppSettings()
    private let dataService = YDataService()
    
    override init() {
        super.init()
        self.settings = self.dataService.getAppSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(self.settingsChanged(_:)), name: YNotificationName.settingsChanged.toName(), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() async throws {
        self.companies = self.dataService.getCompanies()
        if self.companies.isEmpty {
            let api = YApi()
            self.companies = try await api.fetchCompanies()
            self.sortCompanies()
            self.dataService.saveCompanies(self.companies)
        }
    }
    
    @objc func settingsChanged(_ notification: Notification) {
        if let updatedSettings = notification.object as? YAppSettings {
            self.settings = updatedSettings
            self.sortCompanies()
            DispatchQueue.main.async {
                self.modelDidUpdate?()
            }
        }
    }
    
    private func sortCompanies() {
        self.companies.sort {
            if self.settings.companyListSort == .symbol {
                return $0.symbol > $1.symbol
            } else {
                return $0.name > $0.name
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.companies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? YCompanyTableViewCell else {
            return UITableViewCell()
        }
        if self.companies.count > indexPath.row {
            let company = self.companies[indexPath.row]
            cell.loadCompany(company)
        }
        return cell
    }
}
