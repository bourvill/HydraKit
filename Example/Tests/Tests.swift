import UIKit
import XCTest
@testable import HydraKit

class HydraTests: XCTestCase {
    func testHydraGetWithSuccess() {
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
}
