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
    var changedState: ((Bool) -> Void)
    
    var body: some View {
        HStack(alignment: .bottom) {
          handleState()
                .frame(height: 56)
                .padding(.horizontal, 8)
        }
        .ignoresSafeArea(.all)
        .frame(width: UIScreen.main.bounds.width)
        .background(Color(red: 22/255, green: 170/255, blue: 170/255))
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
            logo
            Spacer()
            searchButton
        }
        .frame(width: UIScreen.main.bounds.width - 32)
    }
    
    private var logo: some View {
        Image("toolbarLogo")
            .resizable()
            .scaledToFit()
            .frame(height: 65)
            .blur(radius: 0.2)
    }
    
    @ViewBuilder
    private var searchButton: some View {
        Button {
            withAnimation(.linear(duration: 0.2)) {
                isSearchActive = true
                changedState(isSearchActive)
            }
        } label: {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .tint(Color(red: 22/255, green: 170/255, blue: 170/255))
                .padding(8)
                .background(
                    Circle()
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.12), radius: 6, x: 3, y: 3)
                )
        }
    }
    
    @ViewBuilder
    private var dismissSearchButton: some View {
        Button {
            withAnimation(.linear(duration: 0.33)) {
                isSearchActive = false
                changedState(isSearchActive)
            }
        } label: {
            Image(systemName: "arrow.left.circle.fill")
                .foregroundColor(.white)
        }
        .accessibilityLabel("Dismiss search")
    }
    
    @ViewBuilder
    private var searchBar: some View {
        if isSearchActive {
            HStack {
                dismissSearchButton
                SearchBar(text: $searchText)
                Spacer()
            }
            .transition(.opacity.combined(with: .move(edge: .trailing)))
            .animation(.easeInOut(duration: 0.9), value: isSearchActive)
        }
    }
}
