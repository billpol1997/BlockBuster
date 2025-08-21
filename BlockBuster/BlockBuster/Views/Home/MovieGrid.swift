//
//  MovieGrid.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import SwiftUI

struct MovieGrid: View {
    let movies: [MovieModel]
    let onSelect: (MovieModel) -> Void
    let onLoadMore: () -> Void
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                ForEach(movies.indices, id: \.self) { index in
                    let movie = self.movies[index]
                    MovieView(movie: movie)
                        .accessibilityElement(children: .contain)
                        .accessibilityIdentifier("MovieCell_\(String(describing: movie.title))")
                        .onTapGesture { onSelect(movie) }
                        .onAppear {
                            if index == movies.count - 3 {
                                onLoadMore()
                            }
                        }
                }
            }
            .padding(12)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("MovieList")
    }
}
