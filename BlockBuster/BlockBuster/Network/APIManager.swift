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
    static let shared = APIManager()
    let session = SessionBuilder()
    let popularUrl =  Bundle.main.object(forInfoDictionaryKey: "API_POPULAR_URL") as? String
    let searchURL = Bundle.main.object(forInfoDictionaryKey: "API_SEARCH_URL") as? String
    let detailURL = Bundle.main.object(forInfoDictionaryKey: "API_MOVIE_URL") as? String
    let creditsURL = Bundle.main.object(forInfoDictionaryKey: "API_MOVIE_CREDITS_URL") as? String
    
    let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    let headers: HTTPHeaders = [
        "accept" : "application/json"
    ]
    
    //MARK: Popular
    func fetchPopularMovies(page: Int? = nil, _ isInTesting: Bool = false) async throws -> PopularMoviesResponseModel? {
        if let url = popularUrl?.replacingOccurrences(of: "/$()/", with: "//"), let key, isInTesting.not() {
            
            let parameters: Parameters = [
                "api_key": key,
                "page": "\(page ?? 1)"
            ]
            
            let data: PopularMoviesResponseModel? = try? await session.fetchData(from: url, method: .get, headers: headers, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            guard isInTesting else { return nil }
            let testResponse: PopularMoviesResponseModel? = try? await fetchFromJSON(fileName: "mockPopular")
            return testResponse
        }
    }
    
    //MARK: Details
    func fetchMovieDetail(id: Int, _ isInTesting: Bool = false) async throws -> MovieResponseModel? {
        if let url = detailURL?.replacingOccurrences(of: "/$()/", with: "//").replacingOccurrences(of: "{movie_id}", with: "\(id)"), let key, isInTesting.not() {
            
            let parameters: Parameters = [
                "api_key": key
            ]
            
            let data: MovieResponseModel? = try? await session.fetchData(from: url, method: .get, headers: headers, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            guard isInTesting else { return nil }
            let testResponse: MovieResponseModel? = try? await fetchFromJSON(fileName: "mockDetails")
            return testResponse
        }
    }
    
    //MARK: Credits
    func fetchMovieCredits(id: Int, _ isInTesting: Bool = false) async throws -> MovieCreditsResponseModel? {
        if let url = creditsURL?.replacingOccurrences(of: "/$()/", with: "//").replacingOccurrences(of: "{movie_id}", with: "\(id)"), let key, isInTesting.not() {
            
            let parameters: Parameters = [
                "api_key": key
            ]
            
            let data: MovieCreditsResponseModel? = try? await session.fetchData(from: url, method: .get, headers: headers, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            guard isInTesting else { return nil }
            let testResponse: MovieCreditsResponseModel? = try? await fetchFromJSON(fileName: "mockCredits")
            return testResponse
        }
    }
    
    //MARK: Search
    func fetchSearchMovies(query: String, page: Int? = nil, _ isInTesting: Bool = false) async throws -> SearchMoviesResponseModel? {
        if let url = searchURL?.replacingOccurrences(of: "/$()/", with: "//"), let key, isInTesting.not() {
            
            let parameters: Parameters = [
                "api_key": key,
                "query": query,
                "page": page ?? 1
            ]
            
            let data: SearchMoviesResponseModel? = try? await session.fetchData(from: url, method: .get, headers: headers, parameters: parameters)
            if let data {
                return data
            } else {
                return nil
            }
        } else {
            guard isInTesting, query.isEmpty.not() else { return nil }
            let testResponse: SearchMoviesResponseModel? = try? await fetchFromJSON(fileName: "mockSearch")
            return testResponse
        }
    }
    
    func fetchFromJSON<T: Decodable>(fileName: String) async throws -> T {
        // Testing: Load from local JSON
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            throw NSError(domain: "APIManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "Local JSON file not found"])
        }
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let decoded = try JSONDecoder().decode(T.self, from: data)
        return decoded
    }
}
