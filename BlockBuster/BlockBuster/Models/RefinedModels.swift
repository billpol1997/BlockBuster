//
//  RefinedModels.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import Foundation

struct MovieModel: Identifiable {
    let id: Int?
    let image: String?
    let title: String?
    let date: String?
    let summary: String?
    let gerne: String?
    let cast: [Cast]?
    
    //MARK: Default init
    init() {
        self.id = 0
        self.image = ""
        self.title = ""
        self.date = ""
        self.summary = ""
        self.gerne = ""
        self.cast = []
    }
    
    //MARK: Popular init
    init(from popular: MoviePopularItem) {
        self.id = popular.id
        self.image = "https://image.tmdb.org/t/p/w500/" + (popular.poster_path ?? "")
        self.title = popular.title
        self.date = popular.release_date
        self.summary = ""
        self.gerne = GenreMap.name(for: popular.genre_ids?.first ?? 0)
        self.cast = []
    }
    
    //MARK: Search init
    init(from search: MovieSearchItem) {
        self.id = search.id
        self.image = "https://image.tmdb.org/t/p/w500/" + (search.poster_path ?? "")
        self.title = search.title
        self.date = search.release_date
        self.summary = ""
        self.gerne = GenreMap.name(for: search.genre_ids?.first ?? 0)
        self.cast = []
    }
    
    //MARK: Details and Credits init
    init(from movie: MovieResponseModel, and credits: MovieCreditsResponseModel) {
        self.id = movie.id
        self.image = "https://image.tmdb.org/t/p/w500/" + (movie.poster_path ?? "")
        self.title = movie.title
        self.date = movie.release_date
        self.summary = movie.overview
        self.gerne = movie.genres?.first?.name
        self.cast = credits.cast?.map { Cast(from: $0) }
    }
    
}

struct Cast {
    let characters: String?
    let actor: String?
    
    //MARK: Default init
    init() {
        self.characters = ""
        self.actor = ""
    }
    
    //MARK: Credits init
    init(from credits: MovieCast) {
        self.characters = credits.character
        self.actor = credits.name
    }
}


struct MovieListModel {
    let page: Int?
    let movies: [MovieModel]?
    let totalPages: Int?
    let totalResults: Int?
    
    //MARK: Default init
    init() {
        self.page = 0
        self.movies = []
        self.totalPages = 0
        self.totalResults = 0
    }
    
    //MARK: Popular init
    init(from popular: PopularMoviesResponseModel) {
        self.page = popular.page
        self.movies = popular.results?.map { item in
            MovieModel(from: item)
        }
        self.totalPages = popular.total_pages
        self.totalResults = popular.total_results
    }
    
    //MARK: Search init
    init(from search: SearchMoviesResponseModel) {
        self.page = search.page
        self.movies = search.results?.map { item in
            MovieModel(from: item)
        }
        self.totalPages = search.total_pages
        self.totalResults = search.total_results
    }
}

enum GenreMap {
    static let byId: [Int: String] = [
        28: "Action",
        12: "Adventure",
        16: "Animation",
        35: "Comedy",
        80: "Crime",
        99: "Documentary",
        18: "Drama",
        10751: "Family",
        14: "Fantasy",
        36: "History",
        27: "Horror",
        10402: "Music",
        9648: "Mystery",
        10749: "Romance",
        878: "Science Fiction",
        10770: "TV Movie",
        53: "Thriller",
        10752: "War",
        37: "Western"
    ]

    static func name(for id: Int) -> String? {
        byId[id] ?? "Unknown"
    }
}
