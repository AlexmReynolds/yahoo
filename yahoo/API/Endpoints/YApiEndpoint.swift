//
//  YApiEndpoint.swift
//  yahoo
//
//  Created by Alex Reynolds on 5/14/25.
//

import Foundation

struct YApiEndpoint {
    enum HostURLString: String {
        case production = "https://us-central1-fbconfig-90755.cloudfunctions.net"
    }
    enum Path : String, CaseIterable {
        case companies = "getAllCompanies"
    }
    
    enum Method : String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"

    }
    
    var baseURL: URL {
        //FOR NOW ! since we know it to be valid
        return URL(string: HostURLString.production.rawValue)!
    }
    
    
    func baseComponentsFor(paths:[YApiURLEndpointPath]) -> URLComponents {
        var url = self.baseURL
        
        for path in paths {
            url = url.appendingPathComponent(path.path.rawValue)
            if let resourceId = path.resourceId {
                url = url.appendingPathComponent(resourceId)
            }
        }
        
        return URLComponents(url: url, resolvingAgainstBaseURL: true)!
    }
    
    
    
    func makeRequest(components: URLComponents, method:Method, queryItems: [URLQueryItem]?) -> URLRequest {
        var locComp = components
        locComp.queryItems = queryItems

        var request = URLRequest(url: locComp.url!)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}


struct YApiURLEndpointPath {
    var path: YApiEndpoint.Path
    var resourceId: String?
}
