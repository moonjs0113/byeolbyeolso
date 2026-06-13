//
//  DependencyValues+StoreFactory.swift
//  Donmani
//
//  Created by 문종식 on 6/13/26.
//

import ComposableArchitecture

struct StoreFactoryDependencyKey: DependencyKey {
    static var liveValue: StoreFactory = DefaultStoreFactory()
}

extension DependencyValues {
    var mainStoreFactory: StoreFactory {
        get { self[StoreFactoryDependencyKey.self] }
        set { self[StoreFactoryDependencyKey.self] = newValue }
    }
}
