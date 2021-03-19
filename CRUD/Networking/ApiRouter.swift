//
//  ApiRouter.swift
//  CRUD
//
//  Created by Дмитрий Кондратьев on 19.03.2021.
//

import Foundation
import Alamofire

enum ApiRouter: URLRequestConvertible {
    case login([String: String])
    case all_post
    case profile
    
    var baseURL: URL {
            return URL(string: "http://api.dev.local")!
    }
        
    var method: HTTPMethod {
        switch self {
        case .login:
            return .post
        case .all_post:
            return .get
        case .profile:
        return .post
        }
    }

    var path: String {
        switch self {
        case .login:
            return "/api/login"
        case .all_post:
            return "/api/all_posts"
        case .profile:
            return "/api/profile"
        }
    }

    
    
    func asURLRequest() throws -> URLRequest {
        print(path)
        let urlString = baseURL.appendingPathComponent(path).absoluteString.removingPercentEncoding!
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.method = method
        print(urlString)
        
        let token = (UserDefaults.standard.value(forKey: "TOKEN") ?? "") as! String
        
        switch self {
        case let .login(parameters):
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request = try JSONParameterEncoder().encode(parameters, into: request)
            
        case .all_post:
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
        case .profile:
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.setValue(" Bearer " + token, forHTTPHeaderField: "Authorization")
            
        }
        
        return request
        //request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        //request = try URLEncoding.default.encode(request, with: parameters)
    }
}
