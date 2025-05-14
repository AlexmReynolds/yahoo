//
//  YCompaniesListViewModel.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import UIKit

class YCompaniesListViewModel: NSObject, UITableViewDataSource {
    let title = NSLocalizedString("Companies", comment: "company list title")
    var companies = [YCompany]()//we will assume for now all companies will be stored in memory. In a pagination system we might only store 1 page at a time. It all would depend on pagination requirements and style like infite scroll
    
    var modelDidUpdate: (()->Void)? = nil
    private var isFiltered = false
    private var filteredCompanies: [YCompany] = []
    private var settings = YAppSettings()
    private let dataService = YDataService()
    private var currentPage = 0
    private let pageSize = 100
    private var pollingTimer: Timer?
    override init() {
        super.init()
        self.settings = self.dataService.getAppSettings()
        NotificationCenter.default.addObserver(self, selector: #selector(self.settingsChanged(_:)), name: YNotificationName.settingsChanged.toName(), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadData() async throws {
        //We could have more than 1 page of companies in our DB. We can pass offset but to ensure the results don't get weird we must sort during the query. Pass in the sort option to ensure our offset is correct.
        self.companies = self.dataService.getCompanies(offset: 0, sortBySymbol: self.settings.companyListSort == .symbol)

        if self.companies.isEmpty {
            let api = YApi()
            self.companies = try await api.fetchCompanies()
            self.dataService.saveCompanies(self.companies)
        }
        //we are sorting in the DB query so this sort isn't super needed. If we saved the api results into the DB then fetched them back out with a sort, we wouldn't need this sort at all. So much would change depending on how pagination on the api works that in production we would either keep VM sorting or do it all in the DB level
        self.sortCompanies()
        self.queueNextAPIFetch()
    }
    
    //Eventually we could either have infinite scroll or pagination. This is seetup for simple pagination where we would show a next page button or such in the ui. Infinite scroll we would just keep appending data.
    
    //Our endpoint doesn't support pagination so in that case the api call could get 100000 objects which is bad. If we have that many I'm not sure the main problem is ui page sizes. Pagination makes most sense when the api supports it unless your local obejcts are also pretty big mem footprint
    func hasPages() -> Bool {
        return self.currentCompanies().count > self.pageSize
    }
        
    func currentCompanies() -> [YCompany] {
        return self.isFiltered ? self.filteredCompanies : self.companies
    }
    
    func getCompany(at index: Int) -> YCompany? {
        if self.companiesOnCurrentPage().count > index {
            let company = self.companiesOnCurrentPage()[index]
            //For now let's assume we are polling data from the api and market cap has changed then we will have the freshest stuff in the db so fetch from there for details page. This is not idea since a list api won't return details in general so we would ping the details api for fesh data anyways
            if let fresh = self.dataService.getCompany(symbol: company.symbol) {
                return fresh
            } else {
                return company
            }
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
    
    @objc func timerFired() {
        self.fetchCompaniesInBKG()
    }
    
    private func queueNextAPIFetch() {
        let timer = Timer(timeInterval: 60.0, target: self, selector: #selector(self.timerFired), userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
    }
    
    private func fetchCompaniesInBKG() {
        Task {
            do {
                let api = YApi()
                self.companies = try await api.fetchCompanies()
                self.dataService.saveCompanies(self.companies)
                self.sortCompanies()
                self.modelDidUpdate?()//Not sure I like this because I don't like UI changing while the user is using it. Also no presentable data here like name or symbol changes every minute like a quote would.
                self.queueNextAPIFetch()
            } catch {
                //do nothing this is a background fetch
                //This will kill polling. We could in production have a retry count before killing it.
            }
        }
    }
    
    
    private func companiesOnCurrentPage() -> [YCompany] {
        let all = self.currentCompanies()
        let offset = self.pageSize * self.currentPage
        var endIndex = offset + self.pageSize
        if all.count < endIndex {
            endIndex = all.count
        }
        if offset == endIndex {
             return []
        }
        return Array(all[offset..<endIndex])
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
        return self.companiesOnCurrentPage().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? YCompanyTableViewCell else {
            return UITableViewCell()
        }
        if self.companies.count > indexPath.row {
            let company = self.companiesOnCurrentPage()[indexPath.row]
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
