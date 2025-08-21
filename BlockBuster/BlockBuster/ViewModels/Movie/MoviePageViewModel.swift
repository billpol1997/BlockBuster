//
//  MoviePageViewModel.swift
//  BlockBuster
//
//  Created by Bill on 17/8/25.
//

import Foundation


final class MoviePageViewModel: ObservableObject {
    //MARK: - Properties
    @Published var showError: Bool = false
    @Published var movie: MovieModel?
    @Published var isLoading: Bool = false
    let movieId: Int
    private var detailsResponse: MovieResponseModel?
    private var creditsResponse: MovieCreditsResponseModel?
    private var manager = APIManager.shared
    private var dataFactory: MoviePageDataFactory
    private var uiTesting = CommandLine.arguments.contains("--ui-testing")
    
    //MARK: - Init
    init(movieId: Int, dataFactory: MoviePageDataFactory) {
        self.movieId = movieId
        self.dataFactory = dataFactory
    }
    
    //MARK: - Fetching
    @MainActor
    func fetchData(_ isInTesting: Bool = false) {
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            await withThrowingTaskGroup(of: Any.self) { group in
                group.addTask {
                    self.detailsResponse = try? await self.fetchDetails(isInTesting)
                }
                
                group.addTask {
                    self.creditsResponse = try? await self.fetchCredits(isInTesting)
                }
            }
            self.movie = self.dataFactory.transformData(details: self.detailsResponse, credits: self.creditsResponse)
            self.isLoading = false
        }
    }
    
    //MARK: - Private functions
    private func fetchDetails(_ isInTesting: Bool = false) async throws -> MovieResponseModel? {
        
        do {
            let response = try await manager.fetchMovieDetail(id: movieId, (isInTesting || uiTesting))
            return response
        } catch {
            showError = true
        }
        return nil
    }
    
    private func fetchCredits(_ isInTesting: Bool = false) async throws -> MovieCreditsResponseModel? {
        do {
            let response = try await manager.fetchMovieCredits(id: movieId, (isInTesting || uiTesting))
            return response
        } catch {
            showError = true
        }
        return nil
    }
}
