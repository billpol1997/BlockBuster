//
//  HomePageViewModel.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import Foundation

enum HomePageCurrentState {
    case popular
    case search
    case loading
}

final class HomePageViewModel: ObservableObject {
    //MARK: - Variables
    @Published var currentState: HomePageCurrentState = .loading
    @Published var showError: Bool = false
    @Published var searchText: String = ""
    @Published var currentPage: Int?
    @Published var movies: [MovieModel] = []
    
    private var dataFactory: HomePageDataFactory
    private var manager = APIManager.shared
    private var uiTesting = CommandLine.arguments.contains("--ui-testing")
    
    //MARK: - Init
    init(dataFactory: HomePageDataFactory) {
        self.dataFactory = dataFactory
    }
    
    
    //MARK: - Fetching
    @MainActor
    func fetchData(for state: HomePageCurrentState,_ isInTesting: Bool = false) {
        Task { [weak self] in
            guard let self else { return }
            switch state {
            case .popular:
                let response = try? await fetchPopularData(page: currentPage, isInTesting)
                self.currentPage = response?.page ?? 0
                let movies = dataFactory.getPopularResults(from: response).movies ?? []
                self.movies.append(contentsOf: movies)
            case .search:
                if searchText.isEmpty.not() {
                    searchMovie()
                }
            case .loading:
                break
            }
        }
        self.currentState = state
    }
    
    //MARK: - Search
    @MainActor
    func searchMovie(_ isInTesting: Bool = false) {
        Task {  [weak self] in
            guard let self, currentState == .search else { return }
            if searchText.isEmpty {
                self.resetMovies()
            } else {
                let response = try? await fetchSearchedData(query: searchText, isInTesting)
                let movies = dataFactory.getSearchResults(from: response).movies ?? []
                self.currentPage = response?.page ?? 0
                self.movies.append(contentsOf: movies)
                currentState = .search
            }
            
        }
        currentState = .search
    }
    
    //MARK: - Load more
    func loadMore() {
        guard currentState != .loading else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.currentPage = (currentPage ?? 0) + 1
            fetchData(for: currentState)
        }
    }
    
    //MARK: - State handling
    func changedState(isSearchActive: Bool) {
        guard currentState != .loading else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.currentState = .loading
            resetMovies()
            let state = isSearchActive ? HomePageCurrentState.search : HomePageCurrentState.popular
            fetchData(for: state)
        }
    }
    
    //MARK: - Private functions
    private func fetchPopularData(page: Int? = nil,_ isInTesting: Bool = false) async throws -> PopularMoviesResponseModel? {
        do {
            let response = try await manager.fetchPopularMovies(page: page, (isInTesting || uiTesting))
            return response
        } catch {
            showError = true
        }
        return nil
    }
    
    private func fetchSearchedData(query: String, page: Int? = nil, _ isInTesting: Bool = false) async throws -> SearchMoviesResponseModel? {
        do {
            let response = try await manager.fetchSearchMovies(query: query, page: page, (isInTesting || uiTesting))
            return response
        } catch {
            showError = true
        }
        return nil
    }
    
    private func resetMovies() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            movies.removeAll()
            currentPage = 1
        }
    }
}
