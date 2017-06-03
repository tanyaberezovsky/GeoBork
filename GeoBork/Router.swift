//
//  router.swift
//  GeoBork
//
//  Created by Tania on 11/04/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//

import Alamofire
/*
 REQ CREATE:
 URL: { APIURL }/v1/borks
 METHOD : POST
 HEADERS: Content-Type: application/json
 BODY: {
 "type": [ vet, park, inspector ],
 "name": String,
 "lng": Number,
 "lat": Number
 }
 
 RES : {
 "result":{
 "n":1,
 "ok":1
 }
 }
 */
enum Router: URLRequestConvertible {
    case createBork(parameters: Parameters)
    case readBorks(parameters: Parameters)
    case updateUser(username: String, parameters: Parameters)
    case destroyUser(username: String)
    
    static let baseURLString = "http://geobork.gregory.beer:3000/v1/"
    
    var method: HTTPMethod {
        switch self {
        case .createBork:
            return .post
        case .readBorks:
            return .get
        case .updateUser:
            return .put
        case .destroyUser:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .createBork:
            return "borks"
        case .readBorks(_):
            return "borks"
        case .updateUser(let username, _):
            return "/users/\(username)"
        case .destroyUser(let username):
            return "/users/\(username)"
        }
    }
    
    // MARK: URLRequestConvertible
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        switch self {
        case .createBork(let parameters):
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
            } catch {
                // No-op
            }
           // let data : NSData = NSKeyedArchiver.archivedData(withRootObject: parameters) as NSData
           // urlRequest.httpBody = data as Data
            // set header fields
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Content-Type")
            urlRequest.setValue("application/json",
                                forHTTPHeaderField: "Accept")
 
        case .readBorks(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .updateUser(_, let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default:
            break
        }
        
        return urlRequest
    }
}
