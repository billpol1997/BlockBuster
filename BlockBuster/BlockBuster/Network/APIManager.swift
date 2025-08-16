//
//  APIManager.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import Foundation
import Alamofire

final class APIManager {
    //MARK: Variables
    let session = SessionBuilder()
    let popularUrl =  Bundle.main.object(forInfoDictionaryKey: "API_POPULAR_URL") as? String
    let searchURL = Bundle.main.object(forInfoDictionaryKey: "API_SEARCH_URL") as? String
    let detailURL = Bundle.main.object(forInfoDictionaryKey: "API_MOVIE_URL") as? String
    let creditsURL = Bundle.main.object(forInfoDictionaryKey: "API_MOVIE_CREDITS_URL") as? String
    
    let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    // let url = rawURL?.replacingOccurrences(of: "/$()/", with: "//")
    
    //MARK: Popular
    func fetchPopularMovies(page: Int? = nil) async throws -> PopularMoviesResponseModel? {
        if let url = popularUrl?.replacingOccurrences(of: "/$()/", with: "//"), let key {
            let headers: HTTPHeaders = [
                "accept" : "application/json"
            ]
            
            let parameters: Parameters = [
                "api_key": key,
                "page": "\(page ?? 1)"
            ]
            
            let data: PopularMoviesResponseModel? = try? await session.fetchData(from: url, method: .get, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    //MARK: Details
    func fetchMovieDetail(id: Int) async throws -> MovieResponseModel? {
        if let url = detailURL?.replacingOccurrences(of: "/$()/", with: "//").replacingOccurrences(of: "{movie_id}", with: "\(id)"), let key {
            let headers: HTTPHeaders = [
                "accept" : "application/json"
            ]
            
            let parameters: Parameters = [
                "api_key": key
            ]
            
            let data: MovieResponseModel? = try? await session.fetchData(from: url, method: .get, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    //MARK: Credits
    func fetchMovieCredits(id: Int) async throws -> MovieCreditsResponseModel? {
        if let url = creditsURL?.replacingOccurrences(of: "/$()/", with: "//").replacingOccurrences(of: "{movie_id}", with: "\(id)"), let key {
            let headers: HTTPHeaders = [
                "accept" : "application/json"
            ]
            
            let parameters: Parameters = [
                "api_key": key
            ]
            
            let data: MovieCreditsResponseModel? = try? await session.fetchData(from: url, method: .get, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    //MARK: Search
    func fetchSearchMovies(query: String, page: Int? = nil) async throws -> SearchMoviesResponseModel? {
        if let url = searchURL?.replacingOccurrences(of: "/$()/", with: "//"), let key {
            let headers: HTTPHeaders = [
                "accept" : "application/json"
            ]
            
            let parameters: Parameters = [
                "api_key": key,
                "query": query,
                "page": page ?? 1
            ]
            
            let data: SearchMoviesResponseModel? = try? await session.fetchData(from: url, method: .get, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
}
