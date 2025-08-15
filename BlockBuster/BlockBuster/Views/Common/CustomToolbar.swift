//
//  CustomToolbar.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import Foundation
import SwiftUI

struct CustomToolbar: View {
    @State var isSearchActive: Bool = false
    @Binding var searchText: String
    var onSubmit: (() -> Void)
    
    var body: some View {
        HStack {
          handleState()
        }
        .padding(.horizontal, 12)
        .frame(height: 56)
        .background(Color(.systemBackground))
    }
    
    @ViewBuilder
    private func handleState() -> some View {
        switch isSearchActive {
        case true:
            searchBar
        case false :
            content
        }
    }
    
    private var content: some View {
        HStack {
            Spacer()
            logo
            Spacer()
            searchButton
        }
    }
    
    private var logo: some View {
        Image("toolbarLogo")
            .resizable()
            .scaledToFit()
            .frame(height: 24)
        
    }
    
    @ViewBuilder
    private var searchButton: some View {
        Button {
            withAnimation(.linear(duration: 2)) {
                isSearchActive = true
            }
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18, weight: .semibold))
                .padding(10)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.12), radius: 6, x: 3, y: 3)
                        .shadow(color: .white.opacity(0.9), radius: 6, x: -3, y: -3)
                )
        }
    }
    
    @ViewBuilder
    private var searchBar: some View {
        if isSearchActive {
            SearchBar(text: $searchText, onSubmit: onSubmit)
        }
    }
}
