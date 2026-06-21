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
        let fortunes: [Fortune]
        
        init(fortunes: [Fortune]) {
            self.fortunes = fortunes
        }
    }
    
    @ObservableState
    struct State {
        let month: Int
        let fortunes: [Fortune]
        var selectedDay: Day
        var flippedDays: Set<Day> = []
        
        var weekday: [Day] {
            self.fortunes.map { $0.day }
        }
        
        init(context: Context) {
            self.month = Day.today.month
            self.fortunes = context.fortunes
            self.selectedDay = context.fortunes.last?.day ?? .today
        }
    }
    
    enum Action: BindableAction {
        case onAppear

        case touchDay(Day)
        case touchFortuneCard(Day)
        case touchBackButton
        
        case binding(BindingAction<State>)
        
        case delegate(Delegate)
        enum Delegate {
            case pop(Bool)
        }
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .touchDay(let day):
                state.selectedDay = day
                return .none
            case .touchFortuneCard(let day):
                if state.flippedDays.contains(day) {
                    state.flippedDays.remove(day)
                } else {
                    state.flippedDays.insert(day)
                }
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
