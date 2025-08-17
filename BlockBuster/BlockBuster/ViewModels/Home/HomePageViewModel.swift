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
    //MARK: Variables
    @Published var currentState: HomePageCurrentState = .loading
    @Published var showError: Bool = false
    @Published var searchText: String = ""
    @Published var currentPage: Int?
    @Published var movies: [MovieModel] = []

    private var dataFactory: HomePageDataFactory
    private var manager: APIManager
    
    //MARK: Init
    init(dataFactory: HomePageDataFactory, manager: APIManager) {
        self.dataFactory = dataFactory
        self.manager = manager
    }
    
    
    //MARK: Fetching
    @MainActor
    func fetchData(for state: HomePageCurrentState) {
        Task { [weak self] in
            guard let self else { return }
            switch state {
            case .popular:
                let response = try? await fetchPopularData(page: currentPage)
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
    
    @MainActor
    func searchMovie() {
        Task {  [weak self] in
            guard let self, currentState == .search else { return }
            if searchText.isEmpty {
                self.resetMovies()
            } else {
                let response = try? await fetchSearchedData(query: searchText)
                let movies = dataFactory.getSearchResults(from: response).movies ?? []
                self.currentPage = response?.page ?? 0
                self.movies.append(contentsOf: movies)
                currentState = .search
            }
            
        }
        currentState = .search
    }
    
    func loadMore() {
        guard currentState != .loading else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.currentPage = (currentPage ?? 0) + 1
            fetchData(for: currentState)
        }
    }
    
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
    
    private func fetchPopularData(page: Int? = nil) async throws -> PopularMoviesResponseModel? {
        do {
            let response = try await manager.fetchPopularMovies(page: page)
            return response
        } catch {
            showError = true
        }
        return nil
    }
    
    private func fetchSearchedData(query: String, page: Int? = nil) async throws -> SearchMoviesResponseModel? {
        do {
            let response = try await manager.fetchSearchMovies(query: query, page: page)
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
