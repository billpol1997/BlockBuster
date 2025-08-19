//
//  HomePagePopularUnitTests.swift
//  BlockBusterTests
//
//  Created by Bill on 19/8/25.
//

import XCTest
import Combine
@testable import BlockBuster

final class HomePagePopularUnitTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    var viewModel: HomePageViewModel!
    
    // MARK: - Setup & Teardown
    
    override func setUp() {
        super.setUp()
        viewModel = HomePageViewModel(dataFactory: HomePageDataFactory())
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    /// Tests if movies are loading with initial fetching
    
    @MainActor func testLoadPopularMovies() {
        let exp = expectation(description: "Popular movies loaded")
        viewModel.$movies
                    .dropFirst() // skip initial value
                    .sink { movies in
                        if movies.isEmpty.not() { exp.fulfill() }
                    }
                    .store(in: &cancellables)
        viewModel.movies.removeAll()
        viewModel.fetchData(for: .popular, true)
        wait(for: [exp], timeout: 5)
        XCTAssert(viewModel.movies.isEmpty.not())
    }
    
    /// Tests if movies are loading with pagination
   
    @MainActor func testPopularMoviesPagination() {
        let firstPageLoaded = expectation(description: "First page loaded")
        let secondPageLoaded = expectation(description: "Second page loaded")

        var initialCount: Int = 0
        var cancellable: AnyCancellable?

        cancellable = viewModel.$movies
            .sink { movies in
                // First non-empty emission: capture initial count
                if initialCount == 0, !movies.isEmpty {
                    initialCount = movies.count
                    firstPageLoaded.fulfill()
                    return
                }
                // After loadMore: count should increase
                if movies.count > initialCount {
                    secondPageLoaded.fulfill()
                }
            }

        viewModel.movies.removeAll()
        viewModel.fetchData(for: .popular, true)

        wait(for: [firstPageLoaded], timeout: 3)

        viewModel.currentState = .popular
        viewModel.loadMore()

        wait(for: [secondPageLoaded], timeout: 3)
        cancellable?.cancel()

        XCTAssertGreaterThan(viewModel.movies.count, initialCount)
    }
}
