//
//  OnboardingView.swift
//  Donmani
//
//  Created by 문종식 on 3/18/25.
//

import ComposableArchitecture
import SwiftUI
import DesignSystem
import Domain

struct OnboardingView: View {
    @Bindable var store: StoreOf<OnboardingStore>
    let completeHandler: ((RootStore.MainRoute) -> Void)?
    
    init(completeHandler: @escaping (RootStore.MainRoute) -> Void) {
        self.store = Store(
            initialState: OnboardingStore.State()
        ) {
            OnboardingStore()
        }
        self.completeHandler = completeHandler
    }
    
    var body: some View {
        ZStack {
            skipButton
            switch store.step {
            case .cover:
                coverStepView
            case .page, .final:
                pageStepView
            }
        }
        .onAppear {
            GA.View(event: .onboarding).send()
        }
        .background {
            ColorPalette.Primary.deepBlue20
                .ignoresSafeArea()
        }
        .overlay {
            if store.isPresentLoadingIndicator {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.gray)
                        .scaleEffect(2.0)
                }
            }
        }
    }
}

#Preview {
    OnboardingView() { _ in }
}
