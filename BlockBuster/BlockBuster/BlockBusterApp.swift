//
//  BlockBusterApp.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import SwiftUI

@main
struct BlockBusterApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                SplashScreen() //TODO: add DI
            }
            .background(Color(red: 22/255, green: 170/255, blue: 170/255))
            .ignoresSafeArea()
        }
        
    }
}
