//
//  SearchBar.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var placeholder: String = "Search"
    
    var body: some View {
        HStack(spacing: 8) {
            searchIcon
            textField
            clearButton
        }
        .padding(10)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.white)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 2, y: 2)
        )
    }
    
    private var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(Color(red: 22/255, green: 170/255, blue: 170/255))
    }
    
    private var textField: some View {
        TextField(placeholder, text: $text)
        .tint(Color(red: 22/255, green: 170/255, blue: 170/255))
        .foregroundColor(Color(red: 22/255, green: 170/255, blue: 170/255))
        .textInputAutocapitalization(.none)
        .disableAutocorrection(true)
        .submitLabel(.search)
    }
    
    @ViewBuilder
    private var clearButton: some View {
        if text.isEmpty.not() {
            Button {
                text = ""
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(red: 22/255, green: 170/255, blue: 170/255))
            }
            .accessibilityLabel("Clear text")
        }
    }
}
