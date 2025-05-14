//
//  YAppSettings.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import Foundation
class YAppSettings {
    enum CompanyListSort: Int {
        case name
        case symbol
    }
    var companyListSort = CompanyListSort.name
}
