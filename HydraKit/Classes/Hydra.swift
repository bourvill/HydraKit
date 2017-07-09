//
//  Hydra.swift
//  HydraKit
//
//  Created by maxime marinel on 26/06/2017.
//
import Foundation

public class Hydra {

    /**
     Encapsulate result
     - success: return the T
     - failure: return error
     */
    public enum Result<T:HydraObject> {
        case success(Results<T>)
        case failure(Error)
    }

    /// endpoint url
    let endpoint: String
    /// session for task
    let urlSession: URLSessionProtocol

    /**
     Create a new hydra query manager

     - Parameter endpoint: The string endpoint
     - Parameter urlSession: urlSession needed for task
     */
    public init(endpoint: String, urlSession: URLSessionProtocol) {
        self.endpoint = endpoint
        self.urlSession = urlSession
    }

    /**
     Create a new hydra query manager

     - Parameter endpoint: The string endpoint
     */
    public convenience init (endpoint: String) {
        self.init(endpoint: endpoint, urlSession: URLSession.shared)
    }

    /**
     Get results from endpoint, a collection of HydraObject

     - Parameter hydraObject: an object Type conform to protocol HydraObject
     - Parameter parameters: Optional dictionary with url parameters
     - Parameter completion: Result from task
     */
    public func get<T:HydraObject>(_ hydraObject:T.Type, parameters: [String:Any] = [:], completion: @escaping (Result<T>) -> ()) {
        var urlComponents = URLComponents(string: endpoint + hydraObject.hydraPoint())
        urlComponents?.queryItems = []
        for (key,value) in parameters {
            urlComponents?.queryItems?.append(URLQueryItem(name: key, value: (String(describing: value))))
        }
        urlSession.dataTask(with: urlComponents!.url!) { data, response, error in
            guard error == nil else {
                completion(Result.failure(error!))
                return
            }
            guard let data = data else {
                completion(Result.failure(HydraError.emptyData))
                print("Data is empty")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                var members: [T] = []
                for member in json["hydra:member"] as! [[String:Any]] {
                    members.append(hydraObject.init(hydra: member))
                }

                completion(Result.success(Results<T>(hydraObject, json: json)))
            } catch let errorjson {
                print(errorjson)
            }
            }.resume()
    }

    /**
     Get one result from endpoint

     - Parameter hydraObject: an object Type conform to protocol HydraObject
     - Parameter id: id of ressource
     - Parameter completion: Result from task
     */
    public func get<T:HydraObject>(_ hydraObject:T.Type, id: Int,  completion: @escaping (Result<T>) -> ()) {
        let url = URL(string: endpoint + hydraObject.hydraPoint() + "/" + String(id))

        urlSession.dataTask(with: url!) { data, response, error in
            guard error == nil else {
                completion(Result.failure(error!))
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]                
                completion(Result.success(Results<T>(hydraObject, json: json)))
            } catch let errorjson {
                completion(Result.failure(errorjson))
                print(errorjson)
            }
            }.resume()
    }
}
