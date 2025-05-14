//
//  YSettingsViewModel.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import Foundation

class YSettingsViewModel {
    let title = NSLocalizedString("Settings", comment: "settings title")
    var sortOrderSelectedIndex = 0
    private var settings = YAppSettings()
    private let dataService = YDataService()
    
    init() {
        self.settings = self.dataService.getAppSettings()
        self.sortOrderSelectedIndex = self.settings.companyListSort.rawValue
    }
    
    func updateSortOrder(_ value: Int) {
        self.settings.companyListSort = YAppSettings.CompanyListSort(rawValue: value) ?? .name
        self.dataService.save(appSettings: self.settings)
        NotificationCenter.default.post(name: YNotificationName.settingsChanged.toName(), object: self.settings)
    }
}
