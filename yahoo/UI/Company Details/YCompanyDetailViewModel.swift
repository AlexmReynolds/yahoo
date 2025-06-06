//
//  YCompanyDetailViewModel.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import Foundation

class YCompanyDetailViewModel {
    let company: YCompany
    let title: String
    private let dataService = YDataService()
    init(company: YCompany) {
        self.company = company
        self.title = company.name
    }
    
    func favoriteCompany(isFavorite: Bool) {
        self.company.isFavorite = isFavorite
        self.dataService.saveCompany(self.company)
    }
}
