//
//  ModalModifier.swift
//  Donmani
//
//  Created by 문종식 on 2/8/26.
//

import SwiftUI
import DesignSystem

struct ModalModifier<ModalContent: View>: ViewModifier {
    @Binding private var isPresented: Bool
    @State private var isFullScreenViewVisible = false
    private let config: ModalConfig
    private let content: () -> ModalContent
    
    private let animation: Animation = .spring(
        response: 0.2,
        dampingFraction: 1
    )
    
    init(
        isPresented: Binding<Bool>,
        config: ModalConfig,
        @ViewBuilder content: @escaping () -> ModalContent
    ) {
        self._isPresented = isPresented
        self.config = config
        self.content = content
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                Group {
                    ZStack {
                        dimView()
                            .opacity(isFullScreenViewVisible ? 1 : 0)
                        modalBody()
                            .padding(.horizontal, 30)
                            .scaleEffect(isFullScreenViewVisible ? 1 : 0.96)
                            .opacity(isFullScreenViewVisible ? 1 : 0)
                    }
                    .animation(
                        animation,
                        value: isFullScreenViewVisible
                    )
                }
                .clearBackground()
                .onAppear {
                    isFullScreenViewVisible = true
                }
            }
            .transaction{ transaction in
                transaction.disablesAnimations = isPresented
            }
            .animation(animation, value: isFullScreenViewVisible)
    }
    
    @ViewBuilder
    private func dimView() -> some View {
        Color.black
            .opacity(0.6)
            .ignoresSafeArea()
            .onTapGesture {
                guard config.isEnableDismiss else { return }
                dismiss()
            }
    }

    @ViewBuilder
    private func modalBody() -> some View {
        content()
        .padding(.horizontal, 20)
        .background(config.backgroundColor)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24,
                style: .circular
            )
        )
    }
    
    
    private func dismiss() {
        withAnimation(animation) {
            isFullScreenViewVisible = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                isPresented = false
            }
        }
    }
}

extension View {
    func modal<Content: View>(
        isPresented: Binding<Bool>,
        config: ModalConfig,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        modifier(
            ModalModifier(
                isPresented: isPresented,
                config: config,
                content: content
            )
        )
    }
}
