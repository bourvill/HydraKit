import UIKit
import XCTest
@testable import HydraKit

class HydraTests: XCTestCase {
    func testHydraGetSuccess() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        session.nextData = "{\"hydra:member\":[{\"@id\":\"/api/hydraObjs/7508\",\"@type\":\"hydraObjs\"}]}".data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        hydra.get(HydraObj.self) { results in

            switch results {
            case .success(let results):
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.hydraId, "/api/hydraObjs/7508")
            case .failure(_):
                //never call
                XCTAssertTrue(false)
            }
        }

        XCTAssertEqual(session.lastURL?.absoluteString, "http://url.test/api/hydraObjs?")
        XCTAssertTrue(dataTask.resumeCall)
    }

    func testHydraGetWithParametersSuccess() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        session.nextData = "{\"hydra:member\":[{\"@id\":\"/api/hydraObjs/7508\",\"@type\":\"hydraObjs\"}]}".data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        hydra.get(HydraObj.self, parameters: ["name": "myTest", "note": 3, "extra": "my extra arg"]) { results in
            switch results {
            case .success(let results):
                XCTAssertEqual(results.count, 1)
                XCTAssertEqual(results.first?.hydraId, "/api/hydraObjs/7508")
            case .failure(_):
                //never call
                XCTAssertTrue(false)
            }
        }

        XCTAssertEqual(session.lastURL?.absoluteString, "http://url.test/api/hydraObjs?name=myTest&note=3&extra=my%20extra%20arg")
        XCTAssertTrue(dataTask.resumeCall)
    }

    func testHydraGetIdSuccess() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        session.nextData = "{\"@id\":\"/api/hydraObjs/7508\",\"@type\":\"hydraObjs\"}".data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        hydra.get(HydraObj.self, id: 7508) { results in
            switch results {
            case .success(let results):
                XCTAssertEqual(results.hydraId, "/api/hydraObjs/7508")
            case .failure(_):
                //never call
                XCTAssertTrue(false)
            }
        }

        XCTAssertEqual(session.lastURL?.absoluteString, "http://url.test/api/hydraObjs/7508")
        XCTAssertTrue(dataTask.resumeCall)
    }
}
