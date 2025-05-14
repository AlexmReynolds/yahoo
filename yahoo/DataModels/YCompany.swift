//
//  YCompany.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import Foundation

class YCompanyMarketCap {
    let formattedString: String
    let longFormattedString: String
    let value: Int
    
    init(formattedString: String, longFormattedString: String, value: Int) {
        self.formattedString = formattedString
        self.longFormattedString = longFormattedString
        self.value = value
    }
}

class YCompany {
    let marketCap: YCompanyMarketCap
    let name: String
    let symbol: String
    var isFavorite = false
    
    init(marketCap: YCompanyMarketCap, name: String, symbol: String) {
        self.marketCap = marketCap
        self.name = name
        self.symbol = symbol
    }
}
