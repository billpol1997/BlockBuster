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
            HomePageViewModel(dataFactory: r.resolve(HomePageDataFactory.self)!)
        }
        
        container.register(HomePageDataFactory.self) { _ in
            HomePageDataFactory()
        }
        
        container.register(MoviePage.self) { r, id in
            MoviePage(movieId: id, viewModel: r.resolve(MoviePageViewModel.self, argument: id)!)
        }
        
        container.register(MoviePageViewModel.self) { r, id in
            MoviePageViewModel(movieId: id, dataFactory: r.resolve(MoviePageDataFactory.self)!)
        }
        
        container.register(MoviePageDataFactory.self) { _ in
            MoviePageDataFactory()
        }
        
        return container
    }
    
    func getContainerSwinject() -> Container {
        return diContainer
    }
}
