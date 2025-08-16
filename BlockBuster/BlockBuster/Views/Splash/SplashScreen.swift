//
//  SplashScreen.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import SwiftUI

struct SplashScreen: View {
    @State private var navigateToHomePage: Bool = false
    
    var body: some View {
        content
    }
    
    var content: some View {
        ZStack {
            NavigationLink(destination: DIContainer.shared.getContainerSwinject().resolve(HomePage.self)!,
                           isActive: self.$navigateToHomePage,
                           label: { EmptyView() } ).hidden()
            logo
        }
     
    }
    
    private var logo: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .frame(height: 540, alignment: .center)
            Spacer()
            
        }
        .background(Color(red: 22/255, green: 170/255, blue: 170/255))
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                self.navigateToHomePage = true
            }
        }
    }
}
