//
//  MainNavigationStore+Fortune.swift
//  Donmani
//
//  Created by 문종식 on 6/21/26.
//

import ComposableArchitecture

extension MainNavigationStore {
    func fortuneDelegateAction(
        state: inout MainNavigationStore.State,
        action: FortuneStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        switch action {
        case .pop(_):
            if let fortuneID = state.path.ids.last,
               case .fortune(_) = state.path[id: fortuneID] {
                state.path.pop(from: fortuneID)
            }
            return .none
        }
    }
}
