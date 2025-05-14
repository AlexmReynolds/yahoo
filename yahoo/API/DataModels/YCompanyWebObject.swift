//
//  YCompanyWebObject.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
struct YCompanyMarketCapWebObject: Codable {
    let fmt: String?
    let longFmt: String?
    let raw: Int?
}

struct YCompanyWebObject: Codable {
    let marketCap: YCompanyMarketCapWebObject?
    let name: String?
    let symbol: String?
}
