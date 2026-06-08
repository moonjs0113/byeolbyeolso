//
//  ToastView.swift
//  Donmani
//
//  Created by 문종식 on 9/12/25.
//

import SwiftUI
import DesignSystem
import Domain

struct ToastView: View {
    @EnvironmentObject private var toastManager: ToastManager
    
    var body: some View {
        Group {
            if let position = toastManager.position {
                VStack {
                    if position == .top {
                        toastElement()
                        Spacer()
                    } else {
                        Spacer()
                        toastElement()
                    }
                }
                .offset(y: toastManager.offset)
                .transition(.opacity)
            }
        }
        .allowsHitTesting(false)
    }
    
    @ViewBuilder
    private func toastElement() -> some View {
        ToastElementView(
            text: toastManager.title,
            icon: toastManager.icon
        )
    }
    
    private struct ToastElementView: View {
        let text: String
        let icon: DImageAsset?
        
        var body: some View {
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    if let icon {
                        DImage(icon)
                            .resizable()
                            .frame(width: .s3, height: .s3)
                    }
                    DText(text, style: .b2, weight: .bold, color: .white)
                }
                .padding(.s5)
                .background {
                    Capsule(style: .continuous)
                        .fill(ColorPalette.Semantic.textGuide.opacity(0.9))
                }
                Spacer()
            }
            .padding(40)
        }
    }
}

#Preview {
    ToastView()
}
