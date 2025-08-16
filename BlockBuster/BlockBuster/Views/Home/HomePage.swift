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
            }
        }
    }
    
    private var toolbar: some View {
        CustomToolbar(searchText: §viewModel.searchText, onSubmit: {}, changedState: { val in self.viewModel.changedState(isSearchActive: val) })
    }
    
    

}
