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
    var onSubmit: (() -> Void)
    
    var body: some View {
        HStack(spacing: 8) {
            searchIcon
            textField
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 2, y: 2)
                .shadow(color: Color.white.opacity(0.8), radius: 6, x: -2, y: -2)
        )
    }
    
    private var searchIcon: some View {
        Image(systemName: "magnifyingglass")
            .foregroundColor(.secondary)
    }
    
    private var textField: some View {
        TextField(placeholder, text: $text, onCommit: {
            onSubmit()
        })
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
                    .foregroundColor(.secondary)
            }
            .accessibilityLabel("Clear text")
        }
    }
}
