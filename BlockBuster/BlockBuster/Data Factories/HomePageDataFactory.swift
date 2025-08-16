//
//  HomePageDataFactory.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import Foundation

final class HomePageDataFactory {
    
    func getPopularResults(from response: PopularMoviesResponseModel?) -> MovieListModel {
        guard let response else { return  MovieListModel() }
        let list = MovieListModel(from: response)
        return list
    }
    
    func getSearchResults(from response: SearchMoviesResponseModel?) -> MovieListModel {
        guard let response else { return  MovieListModel() }
        let list = MovieListModel(from: response)
        return list
    }
    
}
