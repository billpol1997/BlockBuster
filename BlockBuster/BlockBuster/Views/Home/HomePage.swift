//
//  HomePage.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import SwiftUI

struct HomePage: View {
    @State var searchText: String = ""
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
    
    private var content: some View {
        VStack {
            
        }
        .ignoresSafeArea()
        .toolbar {
            toolbar
        }
    }
    
    private var toolbar: some View {
        CustomToolbar(searchText: $searchText, onSubmit: {})
    }
}
