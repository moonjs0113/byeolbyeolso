//
//  FortuneStore.swift
//  App
//
//  Created by 문종식 on 6/21/26.
//

import ComposableArchitecture
import Domain

@Reducer
struct FortuneStore {
    struct Context {
        let weekday: [Day]
        
        init(
            weekday: [Day]
        ) {
            self.weekday = weekday
        }
    }
    
    @ObservableState
    struct State {
        let weekday: [Day]
        init(context: Context) {
            self.weekday = context.weekday
        }
    }
    
    enum Action {
        case onAppear
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            }
        }
    }
}
