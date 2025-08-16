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
    }
    
    @ViewBuilder
    private func handleState() -> some View {
        switch viewModel.currentState {
        case .loading:
            ProgressView()
                .tint(Color(red: 22/255, green: 170/255, blue: 170/255))
        default:
            content
        }
    }
    
    private var content: some View {
        VStack {
           movieListView
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
        CustomToolbar(searchText: viewModel.searchText §> { text in  viewModel.searchText = text }, onSubmit: { viewModel.searchMovie() }, changedState: { val in self.viewModel.changedState(isSearchActive: val) })
    }
}
