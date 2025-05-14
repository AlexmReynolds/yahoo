//
//  YCompany.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import UIKit

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
    
    func getLocalizedMarketCap() -> String? {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
        formatter.numberStyle = .currency
        var val = Double(self.marketCap.value)
        var suffix = ""
        if self.marketCap.value > 1000000000000 {
            val /= 1000000000000.0
            suffix = "T"
        } else if self.marketCap.value > 1000000000 {
            val /= 1000000000.0
            suffix = "B"
        } else if self.marketCap.value > 1000000 {
            val /= 1000000.0
            suffix = "M"
        }
        formatter.negativeSuffix = suffix
        formatter.positiveSuffix = suffix

        return formatter.string(for: val)
    }
}
