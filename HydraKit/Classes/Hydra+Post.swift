//
//  Hydra+Post.swift
//  HydraKit
//
//  Created by maxime marinel on 26/06/2017.
//
import Foundation

extension Hydra {
    /**
     Post resource

     - Parameter hydraObject: an object Type conform to protocol HydraObject
     - Parameter parameters: dictonary needed to create resource
     - Parameter completion: Result from task
     */
    public func post<T: HydraObject>(_ hydraObject: T.Type, parameters: [String:Any] = [:], completion: @escaping (Result<T>) -> Void) {
        let url = URL(string: endpoint + hydraObject.hydraPoint())

        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = URLRequest.HttpMethod.POST.rawValue
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            //@todo error
        }

        urlSession.dataTask(with: request) { data, _, error in
            guard error == nil else {
                completion(Result.failure(error!))
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    completion(Result.success(Results<T>(hydraObject, json: json)))
                }
            } catch let errorjson {
                completion(Result.failure(errorjson))
            }
        }.resume()
    }
}
