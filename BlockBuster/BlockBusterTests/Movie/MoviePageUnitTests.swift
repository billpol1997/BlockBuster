//
//  MoviePageUnitTests.swift
//  BlockBusterTests
//
//  Created by Bill on 19/8/25.
//

import XCTest
import Combine
@testable import BlockBuster

final class MoviePageUnitTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    var viewModel: MoviePageViewModel!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        viewModel = MoviePageViewModel(movieId: 550, dataFactory: MoviePageDataFactory())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    /// Tests if movie loads
    @MainActor func testMovieLoads() {
        let exp = expectation(description: "Movie loads")
        viewModel.$movie
            .dropFirst() // skip initial value
            .sink { val in
                if val?.title?.isEmpty.not() ?? false { exp.fulfill() } ///Even if call fails the movie property is not nil but empty
            }
            .store(in: &cancellables)
        viewModel.fetchData(true)
        wait(for: [exp], timeout: 5)
        XCTAssert(viewModel.movie?.title?.isEmpty.not() ?? false)
    }
    
    /// Tests if credits loads
    @MainActor func testCreditsLoad() {
        let exp = expectation(description: "Credits load")
        viewModel.$movie
            .dropFirst() // skip initial value
            .sink { val in
                if val?.cast?.isEmpty.not() ?? false { exp.fulfill() } ///Even if call fails the movie property is not nil but empty
            }
            .store(in: &cancellables)
        viewModel.fetchData(true)
        wait(for: [exp], timeout: 5)
        XCTAssert(viewModel.movie?.cast?.isEmpty.not() ?? false)
    }
}
