//
//  MovieView.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import SwiftUI

struct MovieView: View {
    let movie: MovieModel

    var body: some View {
        VStack(spacing: 8) {
            posterView
            title
        }
    }

    private var placeholderImage: some View {
        Image(systemName: "film")
            .font(.largeTitle)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var posterView: some View {
        ZStack(alignment: .bottomLeading) {
            Rectangle()
                .fill(Color.secondary.opacity(0.15))

            poster
            dateView
        }
        .aspectRatio(2/3, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
        .contentShape(Rectangle())
    }
    
    @ViewBuilder
    private var poster: some View {
        if let url = URL(string: movie.image ?? "") {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    placeholderImage
                @unknown default:
                    EmptyView()
                }
            }
        } else {
            placeholderImage
        }
    }
    
    @ViewBuilder
    private var dateView: some View {
        if let dateText = movie.date, dateText.isEmpty.not() {
            VStack( alignment: .leading, spacing: 0) {
                Text("Release date ")
                    .font(.system(size: 8))
                    .padding(.bottom, 2)
                Text(dateText)
                    .font(.system(size: 8))
            }
            .padding(4)
            .background(
                .ultraThinMaterial, in: RoundedRectangle(cornerRadius: 6, style: .continuous)
            )
            .foregroundColor(.primary)
            .padding(6)
            .shadow(radius: 1, y: 1)
        }
    }
    
    private var title: some View {
        Text(movie.title ?? "")
            .font(.caption)
            .lineLimit(1)
            .frame(maxWidth: .infinity, alignment: .center)
    }
}
