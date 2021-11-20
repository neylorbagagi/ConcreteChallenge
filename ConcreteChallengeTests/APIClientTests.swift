//
//  APIClientTests.swift
//  ConcreteChallengeTests
//
//  Created by Neylor Bagagi on 15/11/21.
//

import XCTest
@testable import ConcreteChallenge

/// TODO: test private methods

class APIClientTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testRequest() {
        
        APIClient.share.getMovies(forPage: "1") { (data, error) in
            XCTAssertNil(error)
            XCTAssert(data.count > 0, "message")
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
