
import XCTest
@testable import HydraKit

class HydraTests: XCTestCase {
    func testHydraGetSuccess() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        session.nextData = "{\"hydra:member\":[{\"@id\":\"/api/hydraObjs/7508\",\"@type\":\"hydraObjs\"}]}".data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        let expect = expectation(description: "Get completion")

        hydra.get(HydraObj.self) { results in
            expect.fulfill()
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
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testHydraGetWithParametersSuccess() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        session.nextData = "{\"hydra:member\":[{\"@id\":\"/api/hydraObjs/7508\",\"@type\":\"hydraObjs\"}]}".data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        let expect = expectation(description: "Get completion")

        hydra.get(HydraObj.self, parameters: ["name": "myTest", "note": 3, "extra": "my extra arg"]) { results in
            expect.fulfill()
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
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testHydraGetIdSuccess() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        session.nextData = "{\"@id\":\"/api/hydraObjs/7508\",\"@type\":\"hydraObjs\"}".data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        let expect = expectation(description: "Get completion")

        hydra.get(HydraObj.self, id: 7508) { results in
            expect.fulfill()
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
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testHydraGetError() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        session.nextError = MockError.invalid("Invalid")

        //session.nextData = "{\"hydra:member\":[{\"@id\":\"/api/hydraObjs/7508\",\"@type\":\"hydraObjs\"}]}".data(using: .utf8)
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)

        let expect = expectation(description: "Get completion")

        hydra.get(HydraObj.self) { results in
            expect.fulfill()
            switch results {
            case .success(_):
                //never call
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (HydraKit_Tests.MockError error 0.)")
            }
        }

        XCTAssertEqual(session.lastURL?.absoluteString, "http://url.test/api/hydraObjs?")
        XCTAssertTrue(dataTask.resumeCall)
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testHydraGetWithoutDataError() {
        let session = MockURLSession()
        let dataTask = Task()
        session.nextDataTask = dataTask
        let hydra: Hydra = Hydra(endpoint: "http://url.test", urlSession: session)
        let expect = expectation(description: "Get completion")

        hydra.get(HydraObj.self) { results in
            expect.fulfill()
            switch results {
            case .success(_):
                //never call
                XCTAssertTrue(false)
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "The operation couldn’t be completed. (HydraKit.HydraError error 0.)")
            }
        }

        XCTAssertEqual(session.lastURL?.absoluteString, "http://url.test/api/hydraObjs?")
        XCTAssertTrue(dataTask.resumeCall)
        waitForExpectations(timeout: 5, handler: nil)
    }
}
