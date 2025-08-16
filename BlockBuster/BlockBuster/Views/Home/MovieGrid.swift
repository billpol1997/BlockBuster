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
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: columns, alignment: .center, spacing: 12) {
                ForEach(movies) { movie in
                    MovieView(movie: movie)
                        .onTapGesture { onSelect(movie) }
                }
            }
            .padding(12)
        }
    }
}
