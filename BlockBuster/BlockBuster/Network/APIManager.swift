//
//  APIManager.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import Foundation

final class APIManager {
    let session = SessionBuilder()
    let popularUrl =  Bundle.main.object(forInfoDictionaryKey: "API_POPULAR_URL") as? String
    let searchURL = Bundle.main.object(forInfoDictionaryKey: "API_SEARCH_URL") as? String
    let detailURL = Bundle.main.object(forInfoDictionaryKey: "API_MOVIE_URL") as? String
    let key = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    // let url = rawURL?.replacingOccurrences(of: "/$()/", with: "//")
}
