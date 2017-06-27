//
//  Hydra+Post.swift
//  HydraKit
//
//  Created by maxime marinel on 26/06/2017.
//

import Foundation

extension Hydra {
    func post<T:HydraObject>(_ hydraObject:T.Type, parameters: [String:Any] = [:], completion: @escaping (Result<T>) -> ()) {
        let url = URL(string: endpoint + hydraObject.hydraPoint())
        
        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = URLRequest.httpMethod.POST.rawValue
        request.httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let task = urlSession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                completion(Result.success(hydraObject.init(hydra: json)))
            } catch let errorjson {
                print(errorjson)
            }
        }
        task.resume()
    }
}
