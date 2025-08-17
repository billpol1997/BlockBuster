//
//  MoviePageViewModel.swift
//  BlockBuster
//
//  Created by Bill on 17/8/25.
//

import Foundation


final class MoviePageViewModel: ObservableObject {
    @Published var showError: Bool = false
    @Published var movie: MovieModel?
    @Published var isLoading: Bool = false
    let movieId: Int
    private var detailsResponse: MovieResponseModel?
    private var creditsResponse: MovieCreditsResponseModel?
    private var manager = APIManager.shared
    private var dataFactory: MoviePageDataFactory
    
    init(movieId: Int, dataFactory: MoviePageDataFactory) {
        self.movieId = movieId
        self.dataFactory = dataFactory
    }
    
    @MainActor
    func fetchData() {
        isLoading = true
        Task { [weak self] in
            guard let self else { return }
            await withThrowingTaskGroup(of: Any.self) { group in
                group.addTask {
                    self.detailsResponse = try? await self.fetchDetails()
                }
                
                group.addTask {
                    self.creditsResponse = try? await self.fetchCredits()
                }
            }
            self.movie = self.dataFactory.transformData(details: self.detailsResponse, credits: self.creditsResponse)
            self.isLoading = false
        }
    }
    
    private func fetchDetails() async throws -> MovieResponseModel? {
        
        do {
            let response = try await manager.fetchMovieDetail(id: movieId)
            return response
        } catch {
            showError = true
        }
        return nil
    }
    
    private func fetchCredits() async throws -> MovieCreditsResponseModel? {
        do {
            let response = try await manager.fetchMovieCredits(id: movieId)
            return response
        } catch {
            showError = true
        }
        return nil
    }
}
