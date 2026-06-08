//
//  ModalModifier.swift
//  Donmani
//
//  Created by 문종식 on 2/8/26.
//

import SwiftUI
import DesignSystem
import Domain

struct ModalModifier<ModalContent: View>: ViewModifier {
    @Binding private var isPresented: Bool
    @State private var isModalPresented: Bool = false
    @State private var isFullScreenViewVisible = false
    private let config: ModalConfig
    private let content: () -> ModalContent
    private let onDismiss: (() -> Void)?
    
    private let animation: Animation = .spring(
        response: 0.2,
        dampingFraction: 1
    )
    
    init(
        isPresented: Binding<Bool>,
        config: ModalConfig,
        @ViewBuilder content: @escaping () -> ModalContent,
        onDismiss: (() -> Void)?
    ) {
        self._isPresented = isPresented
        self.config = config
        self.content = content
        self.onDismiss = onDismiss
    }
    
    public func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isModalPresented) {
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
                transaction.disablesAnimations = isModalPresented
            }
            .animation(animation, value: isFullScreenViewVisible)
            .onChange(of: isPresented) { _, isPresented in
                if isPresented {
                    isModalPresented = true
                } else {
                    dismiss()
                }
            }
    }
    
    @ViewBuilder
    private func dimView() -> some View {
        Color.black
            .opacity(0.6)
            .ignoresSafeArea()
            .onTapGesture {
                guard config.isEnableDismiss else { return }
                isPresented = false
            }
    }
    
    @ViewBuilder
    private func modalBody() -> some View {
        content()
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
                isModalPresented = false
                onDismiss?()
            }
        }
    }
}

extension View {
    func modal<Content: View>(
        isPresented: Binding<Bool>,
        config: ModalConfig,
        @ViewBuilder content: @escaping () -> Content,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        modifier(
            ModalModifier(
                isPresented: isPresented,
                config: config,
                content: content,
                onDismiss: onDismiss
            )
        )
    }
}
