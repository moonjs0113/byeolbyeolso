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
        let referenceToday: Day
        let referenceYesterday: Day
        let hasTodayRecord: Bool
        let hasYesterdayRecord: Bool
        
        init(
            fortunes: [Fortune],
            referenceToday: Day = .today,
            referenceYesterday: Day = .yesterday,
            hasTodayRecord: Bool = false,
            hasYesterdayRecord: Bool = false
        ) {
            self.fortunes = fortunes
            self.referenceToday = referenceToday
            self.referenceYesterday = referenceYesterday
            self.hasTodayRecord = hasTodayRecord
            self.hasYesterdayRecord = hasYesterdayRecord
        }
    }
    
    @ObservableState
    struct State {
        let month: Int
        let fortunes: [Fortune]
        let referenceToday: Day
        let referenceYesterday: Day
        let hasTodayRecord: Bool
        let hasYesterdayRecord: Bool
        var selectedDay: Day
        var flippedDays: Set<Day> = []
        
        var weekday: [Day] {
            self.fortunes.map { $0.day }
        }
        
        init(context: Context) {
            self.month = context.referenceToday.month
            self.fortunes = context.fortunes
            self.referenceToday = context.referenceToday
            self.referenceYesterday = context.referenceYesterday
            self.hasTodayRecord = context.hasTodayRecord
            self.hasYesterdayRecord = context.hasYesterdayRecord
            self.selectedDay = context.fortunes.last?.day ?? context.referenceToday
        }

        func recordEntryDayTitle(for day: Day) -> RecordEntryDayTitle? {
            if day == referenceToday, !hasTodayRecord {
                return .today
            }
            if day == referenceYesterday, !hasYesterdayRecord {
                return .yesterday
            }
            return nil
        }
    }
    
    enum Action: BindableAction {
        case onAppear

        case touchDay(Day)
        case touchFortuneCard(Day)
        case touchRecordButton(Day)
        case touchBackButton
        
        case binding(BindingAction<State>)
        
        case delegate(Delegate)
        enum Delegate {
            case pop(Bool)
            case pushRecordEntryPointView(RecordEntryDayTitle)
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
            case .touchRecordButton(let day):
                guard let dayTitle = state.recordEntryDayTitle(for: day) else {
                    return .none
                }
                return .run { send in
                    await send(.delegate(.pushRecordEntryPointView(dayTitle)))
                }
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
