//
//  NavigationStore+RecordEntryPoint.swift
//  Donmani
//
//  Created by 문종식 on 3/29/25.
//

import ComposableArchitecture
import UIKit

extension MainNavigationStore {
    func recordEntryPointDelegateAction(
        state: inout MainNavigationStore.State,
        action: RecordEntryPointStore.Action.Delegate
    ) -> Effect<MainNavigationStore.Action> {
        let dayTitle: String = {
            guard let recordID = state.path.ids.last,
                  case let .record(recordState) = state.path[id: recordID] else {
                return "하루"
            }
            return recordState.dayTitle
        }()
        
        switch action {
        case .pushRecordWritingViewWith(let content):
            return .run { send in
                await send(.push(.recordWriting(content.flag, content, dayTitle)))
            }
        case .pushRecordWritingView(let type):
            return .run { send in
                await send(.push(.recordWriting(type, nil, dayTitle)))
            }
        case .popToMainView:
            state.path.removeAll()
            return .none
        }
    }
}
