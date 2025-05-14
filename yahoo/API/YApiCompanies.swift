//
//  YApiCompanies.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//
import Foundation

extension YApi {
    func fetchCompanies() async throws -> [YCompany] {
        let paths = [
            YApiURLEndpointPath(path: .companies)
        ]
        
        let endpoint = YApiEndpoint()
        let baseURL = endpoint.baseComponentsFor(paths: paths)
        let request = endpoint.makeRequest(components: baseURL, method: .get, queryItems: nil)
        //TODO: We can pass offset to the Query items if the API supports it.
        let result = try await self.dataTask(request: request)
        
        do {
            //Why does our data contain nulls? For now we will make the obj optional but an api shouldn't return bad data
            let response =  try JSONDecoder().decode([YCompanyWebObject?].self, from: result.data)
            var companies = [YCompany]()
            for item in response {
                //name and url are required so if the api gave us bad data, let's ignore it
                if let mCap = item?.marketCap, let name = item?.name, let symbol = item?.symbol {
                    let marCap = YCompanyMarketCap(formattedString: mCap.fmt ?? "", longFormattedString: mCap.longFmt ?? "", value: mCap.raw ?? 0)
                    companies.append(YCompany(marketCap: marCap, name: name, symbol: symbol))
                }
            }
            return companies


        } catch let err {
            print(err)
            //make our own better error to bubble to UI
            let error = NSError(domain: "com.api.error", code: 500, userInfo: [NSLocalizedDescriptionKey:NSLocalizedString("Data format was invalid", comment: "api data format error")])
            throw error
        }
    }
}
