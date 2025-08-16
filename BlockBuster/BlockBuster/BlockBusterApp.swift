//
//  BlockBusterApp.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import SwiftUI

@main
struct BlockBusterApp: App {
    
    init() {
        let toolBarColor = UIColor(red: 22/255, green: 170/255, blue: 170/255, alpha: 1)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = toolBarColor
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    var body: some Scene {
        WindowGroup {
            NavigationView {
                DIContainer.shared.getContainerSwinject().resolve(SplashScreen.self)!
            }
        }
    }
}
