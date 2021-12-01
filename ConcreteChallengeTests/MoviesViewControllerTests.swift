//
//  MoviesViewControllerTests.swift
//  ConcreteChallengeTests
//
//  Created by Neylor Bagagi on 01/12/21.
//

import XCTest
@testable import ConcreteChallenge

class MoviesViewControllerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testManageBackgroundView() throws {
        // ARRANGE
        let viewModel = MoviesViewModel()
        let viewController = MoviesViewController(viewModel: viewModel)

        let configurations = [(ControllerBackgroundViewType.searchDataEmpty, UIView(), true, false, true),
                              (ControllerBackgroundViewType.loadingData, UIView(), false, true, true),
                              (ControllerBackgroundViewType.loadDataFail, UIView(), false, false, true),
                              (nil, UIView(), false, false, false)]

        for config in configurations {
            // ACT
            let backgroundView = viewController.manageBackgroundView(for: config.1,
                                                                     onSearch: config.2,
                                                                     onDataRequest: config.3,
                                                                     dataIsEmpty: config.4)

            // ASSERT
            XCTAssertEqual(backgroundView?.type, config.0)
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
