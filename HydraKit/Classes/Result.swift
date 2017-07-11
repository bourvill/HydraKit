//
//  Result.swift
//  HydraKit
//
//  Created by maxime marinel on 09/07/2017.
//

import Foundation

public class Results<T: HydraObject> {
    var hydraObject: T.Type
    var members: [T] = []
    var firstPage: Int = 1
    var nextPage: Int = 1
    var lastPage: Int =  0
    var currentPage: Int = 1
    var totalItems: Int = 0

    init(_ hydraObject: T.Type, json: [String: Any]) {
        self.hydraObject = hydraObject

        if (json["@type"] as? String) == "hydra:Collection" {
            loadCollection(json)
        }
        if (json["@type"] as? String) == hydraObject.hydraType() {
            loadSingle(json)
        }
    }

    private func loadCollection(_ json: [String: Any]) {
        for member in (json["hydra:member"] as? [[String:Any]]) ?? [] {
            members.append(hydraObject.init(hydra: member))
        }
    }

    private func loadSingle(_ json: [String: Any]) {
        members.append(hydraObject.init(hydra: json))
    }
}
