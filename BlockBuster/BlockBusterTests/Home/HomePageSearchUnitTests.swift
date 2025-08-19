//
//  HomePageSearchUnitTests.swift
//  BlockBusterTests
//
//  Created by Bill on 19/8/25.
//

import XCTest
import Combine
@testable import BlockBuster

final class HomePageSearchUnitTests: XCTestCase {
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
    
    @MainActor func testLoadSearchedMovies() {
        let exp = expectation(description: "Search movies loaded")
        viewModel.$movies
                    .dropFirst() // skip initial value
                    .sink { movies in
                        if movies.isEmpty.not() { exp.fulfill() }
                    }
                    .store(in: &cancellables)
        viewModel.movies.removeAll()
        viewModel.searchText = "Superman"
        viewModel.fetchData(for: .search, true)
        wait(for: [exp], timeout: 5)
        XCTAssert(viewModel.movies.isEmpty.not())
    }
    
    /// Tests if movies are loading with no search text
    @MainActor func testLoadSearchedMoviesNoText() {
        let exp = expectation(description: "Search movies not loaded")
        viewModel.$movies
                    .dropFirst() // skip initial value
                    .sink { movies in
                        if movies.isEmpty { exp.fulfill() }
                    }
                    .store(in: &cancellables)
        viewModel.movies.removeAll()
        viewModel.searchText = ""
        viewModel.fetchData(for: .search, true)
        wait(for: [exp], timeout: 5)
        XCTAssert(viewModel.movies.isEmpty)
    }
    
    /// Tests if movies are loading with pagination
   
    @MainActor func testPopularMoviesPagination() {
        let firstPageLoaded = expectation(description: "First page loaded")
        let secondPageLoaded = expectation(description: "Second page loaded")

        var initialCount: Int = 0
        var cancellable: AnyCancellable?
        viewModel.searchText = "Superman"
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
        viewModel.fetchData(for: .search, true)

        wait(for: [firstPageLoaded], timeout: 3)

        viewModel.currentState = .search
        viewModel.loadMore()

        wait(for: [secondPageLoaded], timeout: 3)
        cancellable?.cancel()

        XCTAssertGreaterThan(viewModel.movies.count, initialCount)
    }
}
