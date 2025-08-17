//
//  ErrorView.swift
//  BlockBuster
//
//  Created by Bill on 17/8/25.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Oops! Something went wrong.")
                .foregroundColor(Color(red: 22/255, green: 170/255, blue: 170/255))
            Spacer()
        }
        .padding(8)
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 22/255, green: 170/255, blue: 170/255), lineWidth: 1)
        }
        .frame(width: UIScreen.main.bounds.width - 32)
    }
}
