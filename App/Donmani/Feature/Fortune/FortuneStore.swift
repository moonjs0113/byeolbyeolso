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
        let month: Int
        let weekday: [Day]
        var selectedDay: Day = .today
        
        init(context: Context) {
            self.month = Day.today.month
            self.weekday = context.weekday
        }
    }
    
    enum Action {
        case onAppear
        
        case touchDay(Day)
        case touchBackButton
        
        case delegate(Delegate)
        enum Delegate {
            case pop(Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .touchDay(let day):
                state.selectedDay = day
                return .none
            case .touchBackButton:
                return .run { send in
                    await send(.delegate(.pop(false)))
                }
            default:
                break
            }
            return .none
        }
    }
}
