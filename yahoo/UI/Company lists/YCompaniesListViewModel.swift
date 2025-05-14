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
    private var isFiltered = false
    private var filteredCompanies: [YCompany] = []
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
            self.dataService.saveCompanies(self.companies)
        }
        self.sortCompanies()
    }
    func currentCompanies() -> [YCompany] {
        return self.isFiltered ? self.filteredCompanies : self.companies
    }
    
    func getCompany(at index: Int) -> YCompany? {
        if self.currentCompanies().count > index {
            return  self.currentCompanies()[index]
        } else {
            return nil
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
    
    private func filterByName(_ name: String) {
        self.filteredCompanies = self.companies.filter { company in
            return company.name.lowercased().contains(name.lowercased())
        }
        self.modelDidUpdate?()
    }
    
    private func filterBySymbol(_ symbol: String) {
        self.filteredCompanies = self.companies.filter { company in
            return company.symbol.lowercased().contains(symbol.lowercased())
        }
        self.modelDidUpdate?()
    }
    
    private func sortCompanies() {
        self.companies = self.companies.sorted {
            if self.settings.companyListSort == .symbol {
                return $0.symbol < $1.symbol
            } else {
                return $0.name < $1.name
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCompanies().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? YCompanyTableViewCell else {
            return UITableViewCell()
        }
        if self.companies.count > indexPath.row {
            let company = self.currentCompanies()[indexPath.row]
            cell.loadCompany(company)
        }
        return cell
    }
}


extension YCompaniesListViewModel: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsScope(true, animated: true)
        self.isFiltered = true
        return true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsScope(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = nil
        self.isFiltered = false
        self.modelDidUpdate?()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.selectedScopeButtonIndex == 0) {//name
            if let name = searchBar.text {
                self.filterByName(name)
            }
            
        } else {//symbol
            if let symbol = searchBar.text {
                self.filterBySymbol(symbol)
            }
        }
        
    }
}
