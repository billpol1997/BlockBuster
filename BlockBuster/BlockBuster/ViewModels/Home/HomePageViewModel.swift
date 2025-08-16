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
    @Published private(set) var hasMore: Bool = true

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
                resetMovies()
                let response = try? await fetchPopularData(page: currentPage)
                self.currentPage = response?.page ?? 0
                self.movies.append(contentsOf: dataFactory.getPopularResults(from: response).movies ?? [])
            case .search:
                if searchText.isEmpty {
                    resetMovies()
                } else {
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
            guard let self else { return }
            if searchText.isEmpty {
                self.resetMovies()
            } else {
                let response = try? await fetchSearchedData(query: searchText)
                self.currentPage = response?.page ?? 0
                self.movies.append(contentsOf: dataFactory.getSearchResults(from: response).movies ?? [])
            }
        }
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
            fetchData(for: isSearchActive ? .search : .popular)
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
