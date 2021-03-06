//
//  Hydra+PostTests.swift
//  HydraKit_Tests
//
//  Created by maxime marinel on 26/06/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import XCTest
@testable import HydraKit

class HydraPostTests: XCTestCase {
    func testHydraPostSuccess() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        let path = Bundle(for: type(of: self)).path(forResource: "single", ofType: "json")
        session.nextData = try! String(contentsOfFile: path!).data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        let expect = expectation(description: "Post completion")

        hydra.post(HydraObj.self, parameters: ["name": "my name"]) { results in
            expect.fulfill()
            switch results {
            case .success(let results):
                XCTAssertEqual(results.members.first?.hydraId, "/api/annonces/10907")
            case .failure(_):
                //never call
                XCTAssertTrue(false)
            }
        }

        let json = try! JSONSerialization.jsonObject(with: session.lastBody!, options: []) as! [String:Any]

        XCTAssertEqual(json["name"] as! String, "my name")
        XCTAssertEqual(session.lastURL?.absoluteString, "http://url.test/api/annonces")
        XCTAssertEqual(session.lastMethod, "POST")
        XCTAssertTrue(dataTask.resumeCall)

        waitForExpectations(timeout: 5, handler: nil)
    }
}
