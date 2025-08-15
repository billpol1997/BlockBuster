//
//  HomePageViewModel.swift
//  BlockBuster
//
//  Created by Bill on 15/8/25.
//

import Foundation

final class HomePageViewModel: ObservableObject {
    //MARK: Variables
    private var dataFactory: HomePageDataFactory
    private var manager: APIManager
    
    //MARK: Init
    init(dataFactory: HomePageDataFactory, manager: APIManager) {
        self.dataFactory = dataFactory
        self.manager = manager
    }
}
