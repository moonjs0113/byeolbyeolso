//
//  DependencyValues+StateFactory.swift
//  Donmani
//
//  Created by 문종식 on 6/13/26.
//

import ComposableArchitecture

struct StateFactoryDependencyKey: DependencyKey {
    static var liveValue: StateFactory = DefaultStateFactory()
}

extension DependencyValues {
    var mainStateFactory: StateFactory {
        get { self[StateFactoryDependencyKey.self] }
        set { self[StateFactoryDependencyKey.self] = newValue }
    }
}
