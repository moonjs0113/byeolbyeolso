//
//  BottleCalendarView+BottomSheet.swift
//  Donmani
//
//  Created by 문종식 on 12/12/25.
//

import SwiftUI
import DesignSystem
import Lottie
import Domain

extension BottleCalendarView {
    func YearSelectBottomSheet() -> some View {
        BottomSheetView(
            addCancelButton: true,
            closeAction: {
                store.send(.closeYearSelectorBottomSheet)
            }
        ) { dismissSheet in
            VStack(alignment: .center, spacing: .s3) {
                YearPicker(
                    years: store.years,
                    selectedYearIndex: $store.selectedYearIndex
                )
                DButton(title: "완료") {
                    dismissSheet {
                        store.send(.selectYear)
                    }
                }
                .padding(.bottom, -.defaultLayoutPadding)
            }
            .padding(.top, -.s3)
        }
    }
}
