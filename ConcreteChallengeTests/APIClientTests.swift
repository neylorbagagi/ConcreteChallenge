//
//  APIClientTests.swift
//  ConcreteChallengeTests
//
//  Created by Neylor Bagagi on 15/11/21.
//

import XCTest
@testable import ConcreteChallenge

class APIClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetMovies() throws {
        // ARRANGE
        let page = 1

        // ACT
        var data: [Movie] = []
        var error: Error?

        let expectation = self.expectation(description: "Load API Data")
        APIClient.share.getMovies(forPage: String(page)) { (result) in
            switch result {
            case .failure(let resultError):
                error = resultError
            case .success(let resultData):
                data = resultData
            }
            expectation.fulfill()
        }

        // ASSERT
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNil(error, "result must not fail \(error.debugDescription)")
        XCTAssertFalse(data.isEmpty, "result data must not be empty")
    }

    func testGetMoviesIncrement() throws {
        // ARRANGE
        let pages = 2

        // ACT
        var totalData: [Movie] = []
        let expectation = self.expectation(description: "Load API Data")
        expectation.expectedFulfillmentCount = 2

        for page in 1...pages {
            APIClient.share.getMovies(forPage: String(page)) { (result) in
                switch result {
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                case .success(let data):
                    totalData.append(contentsOf: data)
                }
                expectation.fulfill()
            }
        }

        // ASSERT
        waitForExpectations(timeout: 15.0, handler: nil)
        XCTAssertFalse(totalData.isEmpty)
        XCTAssertTrue(totalData.count == 40, "totalData must to contain 40 objects on second iteration")

    }

    func testGetGenres() throws {
        // ARRANGE

        // ACT
        var data: [Genre] = []
        var error: Error?

        let expectation = self.expectation(description: "Load API Data")
        APIClient.share.getGenres { (result) in
            switch result {
            case .failure(let resultError):
                error = resultError
            case .success(let resultData):
                data = resultData
            }
            expectation.fulfill()
        }

        // ASSERT
        waitForExpectations(timeout: 5.0, handler: nil)
        XCTAssertNil(error, "result must not fail \(error.debugDescription)")
        XCTAssertFalse(data.isEmpty, "result data must not be empty")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
