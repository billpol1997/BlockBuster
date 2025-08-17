//
//  MoviePage.swift
//  BlockBuster
//
//  Created by Bill on 17/8/25.
//

import SwiftUI

struct MoviePage: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: MoviePageViewModel
    @State private var showCast: Bool = false
    
    init(movieId: Int, viewModel: MoviePageViewModel) {
        self._viewModel = StateObject(wrappedValue: DIContainer.shared.getContainerSwinject().resolve(MoviePageViewModel.self, argument: movieId)!)
    }
    
    var body: some View {
        handleState()
            .padding(.horizontal, 16)
            .background(
                posterBG
                    .scaledToFill()
                    .ignoresSafeArea()
            )
            .navigationBarBackButtonHidden()
            .toolbar {
                toolbar
            }
            .onAppear {
                viewModel.fetchData()
            }
    }
    
    @ViewBuilder
    private func handleState() -> some View {
        if viewModel.showError {
            ErrorView()
        } else {
            switch viewModel.isLoading {
            case true:
                ProgressView()
                    .tint(Color(red: 22/255, green: 170/255, blue: 170/255))
            default:
                content
            }
        }
    }
    
    
    private var content: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 16) {
                header
                overview
                cast
            }
        }
    }
    
    private var header: some View {
        HStack {
            poster
                .cornerRadius(12)
                .frame(width: 180, height: 250)
            
            title
            Spacer()
        }
        .padding(.top, 16)
    }
    
    @ViewBuilder
    private var poster: some View {
        VStack(alignment: .leading) {
            if let url = URL(string: viewModel.movie?.image ?? "") {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
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
    }
    
    private var placeholderImage: some View {
        Image(systemName: "film")
            .font(.largeTitle)
            .foregroundColor(.secondary)
    }
    
    private var posterBG: some View {
        poster
            .blur(radius: 33)
            .saturation(0.7)
            .opacity(0.55)
            .overlay(
                LinearGradient(
                    colors: [
                        .black.opacity(0.15),
                        .black.opacity(0.05),
                        .black.opacity(0.15)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    private var title: some View {
        VStack(alignment: .leading) {
            Text(viewModel.movie?.title ?? "")
                .font(.headline)
            Text(viewModel.movie?.gerne ?? "")
                .font(.footnote)
            Text(viewModel.movie?.date?.split(separator: "-").reversed().joined(separator: "-") ?? "")
                .font(.caption)
        }
        .foregroundColor(.black)
    }
    
    private var overview: some View {
        VStack(alignment: .leading) {
            Text("Overview: ")
                .font(.body)
                .foregroundColor(.black)
            Text(viewModel.movie?.summary ?? "")
                .font(.caption)
                .foregroundColor(.black)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
    }
    
    private var castHeader: some View {
        Button(action: {
            withAnimation(.linear(duration: 0.3)) {
                showCast.toggle()
            }
        }) {
            HStack {
                Text("Cast (\(viewModel.movie?.cast?.count ?? 0))")
                    .font(.body)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: showCast ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .foregroundColor(Color(red: 22/255, green: 170/255, blue: 170/255))
            }
        }
    }
    
    @ViewBuilder
    private var cast: some View {
        LazyVStack(alignment: .leading, spacing: 8) {
            if let cast = viewModel.movie?.cast, cast.isEmpty.not() {
                castHeader
                    .padding(.bottom, 4)
                if showCast {
                    ForEach(cast) { person in
                        Text("Actor: \(person.actor ?? "Unknown")  Role: \(person.characters ?? "-")")
                            .font(.caption)
                    }
                    .transition(.move(edge: .top))
                }
            }
        }
        .foregroundColor(.black)
        .padding(8)
        .background( .ultraThinMaterial)
        .cornerRadius(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 22/255, green: 170/255, blue: 170/255), lineWidth: 1)
        }
    }
    
    private var toolbar: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "arrow.left")
                    .foregroundColor(.white)
            }
            Spacer()
            Image("toolbarLogo")
                .resizable()
                .scaledToFit()
                .frame(height: 65)
                .blur(radius: 0.2)
            
        }
        .frame(height: 56)
        .frame(width: UIScreen.main.bounds.width - 32)
        .ignoresSafeArea(.all)
    }
}

