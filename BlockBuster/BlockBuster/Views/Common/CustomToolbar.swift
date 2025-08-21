//
//  CustomToolbar.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import Foundation
import SwiftUI

struct CustomToolbar: View {
    //MARK: - Properties
    @Namespace private var bubbleNS
    @State var isSearchActive: Bool = false
    @Binding var searchText: String
    var changedState: ((Bool) -> Void)
    
    //MARK: - Body
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
    
    //MARK: - State handling
    @ViewBuilder
    private func handleState() -> some View {
        switch isSearchActive {
        case true:
            searchBar
        case false :
            content
        }
    }
    
    //MARK: - Sub views
    private var content: some View {
        HStack {
            logo
            Spacer()
            searchButton
                .transition(.bubble)
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
            withAnimation(.bubbleSpring) {
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
                .matchedGeometryEffect(id: "mainBubble", in: bubbleNS)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier("SearchButton")
    }
    
    @ViewBuilder
    private var dismissSearchButton: some View {
        Button {
            withAnimation(.bubbleSpring) {
                isSearchActive = false
                changedState(isSearchActive)
            }
        } label: {
            Image(systemName: "arrow.left.circle.fill")
                .foregroundColor(.white)
                .accessibilityElement(children: .contain)
                .accessibilityLabel("DismissSearchButton")
                .matchedGeometryEffect(id: "mainBubble", in: bubbleNS)
        }
    }
    
    @ViewBuilder
    private var searchBar: some View {
        if isSearchActive {
            HStack {
                dismissSearchButton
                    .transition(.bubble.combined(with: .move(edge: .trailing)))
                    .animation(.linear(duration: 0.3), value: isSearchActive)
                SearchBar(text: $searchText)
                    .transition(.bubble)
                    .accessibilityElement(children: .contain)
                    .accessibilityIdentifier("SearchView")
                Spacer()
            }
            .transition(.opacity.combined(with: .move(edge: .trailing)))
            .animation(.easeInOut(duration: 0.9), value: isSearchActive)
        }
    }
}

//MARK: - Custom transition
extension AnyTransition {
    static var bubble: AnyTransition {
        .asymmetric(
            insertion: .scale(scale: 0.7).combined(with: .opacity),
            removal: .scale(scale: 0.7).combined(with: .opacity)
        )
    }
}

extension Animation {
    static var bubbleSpring: Animation {
        .spring(response: 0.35, dampingFraction: 0.75, blendDuration: 0.4)
    }
}
