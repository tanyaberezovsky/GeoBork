//
//  ApiManager.swift
//  GeoBork
//
//  Created by Tania on 11/04/2017.
//  Copyright © 2017 Tania Berezovski. All rights reserved.
//


import Foundation
import Alamofire

//Networking
typealias Parametrs=[String:Any]

public class ApiManager {
    
    //MARK: - Properities
    static var sharedInstance = ApiManager()
    
    private init(){}
    
    @discardableResult
    func loadBorks(parameters: Parameters, completionHandler: @escaping ([Bork]) -> Void) -> Alamofire.DataRequest {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
     
        return Alamofire.request(Router.readBorks(parameters: parameters)).responseCollection(queue: utilityQueue)  { (response: DataResponse<[Bork]>) in
            debugPrint(response)
            
            if let borks = response.result.value {
                borks.forEach { print("- \($0)") }
                DispatchQueue.main.async {
                    completionHandler(borks)
                }
            }
        }
    }
    
    @discardableResult
    func createBork(parameters: Parameters, completionHandler: @escaping (Int) -> Void) -> Alamofire.DataRequest {
        let utilityQueue = DispatchQueue.global(qos: .utility)
        
        
        return Alamofire.request(Router.createBork(parameters: parameters))
            .responseJSON(queue: utilityQueue)   { response in
            print(response)
            //to get status code
            if let status = response.response?.statusCode {
                switch(status){
                case 200:
                    print("post create bork success")
                    completionHandler(1)
                default:
                    print("error with response status: \(status)")
                    completionHandler(0)
                }
            }
        }
    }
}

protocol ResponseObjectSerializable {
    init?(response: HTTPURLResponse, representation: Any)
}

protocol ResponseCollectionSerializable {
    static func collection(from response: HTTPURLResponse, withRepresentation representation: Any) -> [Self]
}

extension ResponseCollectionSerializable where Self: ResponseObjectSerializable {
    static func collection(from response: HTTPURLResponse, withRepresentation result: Any) -> [Self] {
        var collection: [Self] = []
        
        
        if let dict = result as? Dictionary<String, AnyObject>{
            if let list = dict["result"] as? [Dictionary<String, AnyObject>]{
                
                for obj in list{
                    if let item = Self(response: response, representation: obj) {
                        collection.append(item)
                    }
                }
            }
        }

      /*  if let representation = representation as? [String: Any] {
            for itemRepresentation in representation {
                if let item = Self(response: response, representation: itemRepresentation) {
                    collection.append(item)
                }
            }
        }*/
        return collection
    }
}

extension DataRequest {
    @discardableResult
    func responseCollection<T: ResponseCollectionSerializable>(
        queue: DispatchQueue? = nil,
        completionHandler: @escaping (DataResponse<[T]>) -> Void) -> Self
    {
        let responseSerializer = DataResponseSerializer<[T]> { request, response, data, error in
            guard error == nil else { return .failure(BackendError.network(error: error!)) }
            
            let jsonSerializer = DataRequest.jsonResponseSerializer(options: .allowFragments)
            let result = jsonSerializer.serializeResponse(request, response, data, nil)
            
            guard case let .success(jsonObject) = result else {
                return .failure(BackendError.jsonSerialization(error: result.error!))
            }
            
            guard let response = response else {
                let reason = "Response collection could not be serialized due to nil response."
                return .failure(BackendError.objectSerialization(reason: reason))
            }
            return .success(T.collection(from: response, withRepresentation: jsonObject))
        }
        return response(responseSerializer: responseSerializer, completionHandler: completionHandler)
    }
}

