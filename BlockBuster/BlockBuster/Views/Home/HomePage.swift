//
//  HomePage.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import SwiftUI

struct HomePage: View {
    @StateObject var viewModel: HomePageViewModel
    
    init(viewModel: HomePageViewModel) {
        self._viewModel = StateObject(wrappedValue: DIContainer.shared.getContainerSwinject().resolve(HomePageViewModel.self)!)
    }
    
    var body: some View {
        handleState()
            .padding(.horizontal, 16)
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
    
    @ViewBuilder
    private var content: some View {
        VStack {
            if viewModel.currentState == .search, viewModel.movies.isEmpty {
                emptySearchView
            } else {
                movieListView
            }
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
                //TODO: navigation
            } onLoadMore: {
                viewModel.loadMore()
            }
        }
    }
    
    private var toolbar: some View {
        CustomToolbar(searchText: viewModel.searchText §> { text in  viewModel.searchText = text }, changedState: { val in self.viewModel.changedState(isSearchActive: val) })
    }
}
