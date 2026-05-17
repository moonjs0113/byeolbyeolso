//
//  DToggle.swift
//  Donmani
//
//  Created by 문종식 on 3/26/25.
//

import SwiftUI
import DesignSystem

struct DToggle: View {
    @Binding var isOn: Bool
    
    var body: some View {
        Capsule(style: .continuous)
            .fill(isOn ? ColorPalette.Primary.deepBlue99 : ColorPalette.Primary.deepBlue70)
            .frame(width: 48, height: 28)
            .overlay {
                HStack(spacing: 0) {
                    if isOn {
                        Spacer()
                    }
                    Circle()
                        .fill(ColorPalette.Primary.deepBlue30)
                        .frame(width: 20, height: 20)
                        .padding(4)
                    if !isOn {
                        Spacer()
                    }
                }
            }
    }
}
