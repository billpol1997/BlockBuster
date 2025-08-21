//
//  HomePage.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import SwiftUI

struct HomePage: View {
    //MARK: - Properties
    @StateObject var viewModel: HomePageViewModel
    @State private var navigateToMoviePage: Bool = false
    @State private var selectedMovie: Int = 0
    
    //MARK: - Init
    init(viewModel: HomePageViewModel) {
        self._viewModel = StateObject(wrappedValue: DIContainer.shared.getContainerSwinject().resolve(HomePageViewModel.self)!)
    }
    
    //MARK: - Body
    var body: some View {
        handleState()
            .padding(.horizontal, 16)
            .accessibilityElement(children: .contain)
            .accessibilityIdentifier("HomePageView")
            .navigationBarBackButtonHidden()
            .toolbar {
                toolbar
            }
            .onAppear {
                self.viewModel.fetchData(for: .popular)
            }
            .onReceive(viewModel.$searchText) { _ in
                guard viewModel.currentState == .search else { return }
                viewModel.searchMovie()
            }
    }
    
    //MARK: - State handling
    @ViewBuilder
    private func handleState() -> some View {
        if viewModel.showError {
            ErrorView()
        } else {
            switch viewModel.currentState {
            case .loading:
                ProgressView()
                    .tint(Color(red: 22/255, green: 170/255, blue: 170/255))
            default:
                content
            }
        }
    }
    
    //MARK: - Sub views
    @ViewBuilder
    private var content: some View {
        VStack {
            if viewModel.currentState == .search, viewModel.movies.isEmpty {
                emptySearchView
            } else {
                movieListView
            }
            
            NavigationLink(destination: DIContainer.shared.getContainerSwinject().resolve(MoviePage.self, argument: selectedMovie)!,
                           isActive: self.$navigateToMoviePage,
                           label: { EmptyView() } ).hidden()
        }
    }
    
    private var emptySearchView: some View {
        VStack {
            Text("Search your favorite movies!")
                .foregroundColor(Color(red: 22/255, green: 170/255, blue: 170/255))
        }
    }
    
    private var movieListView: some View {
        VStack {
            MovieGrid(movies: viewModel.movies) { movie in
                self.selectedMovie = movie.id ?? 0
                self.navigateToMoviePage = true
            } onLoadMore: {
                viewModel.loadMore()
            }
        }
    }
    
    private var toolbar: some View {
        CustomToolbar(searchText: viewModel.searchText §> { text in  viewModel.searchText = text }, changedState: { val in self.viewModel.changedState(isSearchActive: val) })
    }
}
