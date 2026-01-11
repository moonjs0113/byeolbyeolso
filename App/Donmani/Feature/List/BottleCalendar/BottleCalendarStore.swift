//
//  BottleCalendarStore.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import ComposableArchitecture

@Reducer
struct BottleCalendarStore {
    
    // MARK: - State
    @ObservableState
    struct State {
        var isPresentingTopBanner: Bool = false
        var isPresentTextGuide: Bool = false
        var isPresentLoadingIndicator: Bool = false
        var isPresentYearSelectorBottomSheet: Bool = false
        
        var starCount: [Int:[Int: Int]] = [:]
        var lastDaysOfMonths: [Int: Int] {
            Day.lastDaysOfMonths(
                year: self.selectedYear
            )
        }
        
        let years = [2025, 2026]
        var selectedYearIndex: Int
        var selectedYear: Int
        var months: ClosedRange<Int> {
            self.selectedYear == 2025 ? (3...12) : (1...12)
        }
        
        var toastType: ToastType = .none
        
        init(context: [Int: RecordCountSummary]) {
            let today: Day = .today
            let year = today.year
            self.selectedYear = year
            self.selectedYearIndex = years.firstIndex(of: year) ?? 0
            
            for year in years {
                for month in ((year == 2025 ? 3 : 1)...12) {
                    self.starCount[year, default: [:]][month] = context[year]?.monthlyRecords[month]?.recordCount ?? 0
                    if self.starCount[year, default: [:]][month, default: -1] == 0 {
                        let day = Day(year: year, month: month)
                        if day > today {
                            self.starCount[year, default: [:]][month] = -1
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Action
    enum Action: BindableAction {
        case onAppear
        case closeTopBanner
        case showEmptyBottleToast
        case completeShowToast
        
        case showLoading
        case hideLoading
        
        case touchTitle
        case closeYearSelectorBottomSheet
        case selectYear
        
        case fetchMonthlyRecord(Int)
        case delegate(Delegate)
        enum Delegate {
            case pushMonthlyBottleView(Day, [Record], [Reward])
        }
        
        case binding(BindingAction<State>)
    }
    
    // MARK: - Dependency
    @Dependency(\.settings) var settings
    @Dependency(\.recordRepository) var recordRepository
    @Dependency(\.fileRepository) var fileRepository
    
    // MARK: - Reducer
    var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isPresentingTopBanner = settings.shouldShowBottleCalendarTopBanner
                
            case .closeTopBanner:
                state.isPresentingTopBanner = false
                settings.shouldShowBottleCalendarTopBanner = false
                
            case .showEmptyBottleToast:
                state.toastType = .emptyRecordMonth
                
            case .completeShowToast:
                state.toastType = .none
                
            case .showLoading:
                state.isPresentLoadingIndicator = true
            case .hideLoading:
                state.isPresentLoadingIndicator = false
                
            case .touchTitle:
                let year = state.selectedYear
                state.selectedYearIndex = state.years.firstIndex(of: year) ?? 0
                state.isPresentYearSelectorBottomSheet = true
                
            case .closeYearSelectorBottomSheet:
                state.isPresentYearSelectorBottomSheet = false
                
            case .selectYear:
                let year = state.years[state.selectedYearIndex]
                state.selectedYear = year
                return .run { send in
                    await send(.closeYearSelectorBottomSheet)
                }
                
            case .fetchMonthlyRecord(let month):
                let year = state.selectedYear
                return .run { send in
                    let monthlyRecordState = try await recordRepository.getMonthlyRecordList(year: year, month: month)
                    let records = monthlyRecordState.records ?? []
                    for reward in monthlyRecordState.decorationItem.values {
                        do {
                            try await fileRepository.saveRewardData(from: reward)
                        } catch {
                            print("failed to save reward data: \(reward)")
                        }
                    }
                    recordRepository.saveRecords(records)
                    await send(.hideLoading)
                    await send(.delegate(.pushMonthlyBottleView(Day(year: year, month: month), records, monthlyRecordState.saveItems)))
                }
            default:
                break
            }
            return .none
        }
    }
}
