//
//  DIContainer.swift
//  BlockBuster
//
//  Created by Bill on 16/8/25.
//

import Foundation
import Swinject

public protocol SwinjectInterface{
    func getContainerSwinject() -> Container
}

final class DIContainer {
    static let shared = DIContainer()
    
    var diContainer: Container {
        let container = Container()
        
        container.register(SplashScreen.self) { _ in
            SplashScreen()
        }
        
        container.register(HomePage.self) { r in
            HomePage(viewModel: r.resolve(HomePageViewModel.self)!)
        }
        
        container.register(HomePageViewModel.self) { r in
            HomePageViewModel(dataFactory: r.resolve(HomePageDataFactory.self)!, manager: r.resolve(APIManager.self)!)
        }
        
        container.register(APIManager.self) { _ in
            APIManager()
        }
        
        container.register(HomePageDataFactory.self) { _ in
            HomePageDataFactory()
        }
        
        return container
    }
    
    func getContainerSwinject() -> Container {
        return diContainer
    }
}
