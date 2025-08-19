//
//  MoviePageDataFactory.swift
//  BlockBuster
//
//  Created by Bill on 17/8/25.
//

import Foundation

final class MoviePageDataFactory {
    
    func transformData(details: MovieResponseModel?, credits: MovieCreditsResponseModel?) -> MovieModel? {
        return MovieModel(from: details, and: credits)
    }
}
