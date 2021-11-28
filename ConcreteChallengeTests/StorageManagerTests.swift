//
//  StorageManagerTests.swift
//  ConcreteChallengeTests
//
//  Created by Neylor Bagagi on 17/11/21.
//

import XCTest
@testable import ConcreteChallenge

class StorageManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSave() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let movie = Movie(id: 1, adult: false, backdropPath: "", genreIDS: [1,2], originalLanguage: "en", originalTitle: "Title", overview: "Overview", popularity: 0.0, posterPath: "poster", releaseDate: "", title: "title", video: false, voteAverage: 0.0, voteCount: 1)
        
        do {
            try StorageManager.share.save(movie: movie)
        } catch _ {
            XCTFail()
        }
        
    }
    
    func testListMovies() throws {
        
        do {
            let movies = try StorageManager.share.listMovies()
            print(movies)
        } catch _ {
            XCTFail()
        }
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
