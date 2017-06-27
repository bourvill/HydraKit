//
//  Stub.swift
//  HydraKit_Tests
//
//  Created by maxime marinel on 21/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Foundation
import HydraKit

class HydraObj: HydraObject {
    var hydraId: String

    required init(hydra: [String : Any]) {
        hydraId = hydra["@id"] as! String
    }

    static func hydraPoint() -> String {
        return "/api/hydraObjs"
    }
}

class Task: URLSessionDataTask {
    var resumeCall = false
    override func resume() {
        resumeCall = true
    }
}

class MockURLSession: URLSessionProtocol {
    private (set) var lastURL: URL?
    var nextDataTask = Task()
    var nextData: Data?
    var nextError: Error?
    var lastMethod: String = "GET"
    var lastBody: Data?

    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        lastURL = url
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTask {
        lastURL = request.url!
        lastMethod = request.httpMethod!
        lastBody = request.httpBody
        completionHandler(nextData, nil, nextError)
        return nextDataTask
    }
}


enum MockError: Error {
    case invalid(String)
}
