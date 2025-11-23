//
//  DesignPreview.swift
//  Donmani
//
//  Created by 문종식 on 4/5/25.
//

import SwiftUI
import DesignSystem

private struct DesignPreview: View {
    @State var age = 19
    @State var isDark = false
    var body: some View {
        ZStack {
            Color(isDark ? .black : .white)
            VStack(spacing: 4) {
                Spacer()
                DToggle(isOn: .constant(true))
                DToggle(isOn: .constant(false))
                DNavigationBarButton(.calendar) { }
                DCompleteButton(isActive: true) { }
                DCompleteButton(isActive: false) { }
                DButton(title: "Button", isEnabled: true) { isDark.toggle()
                }
                DButton(title: "Button", isEnabled: false) { }
                DText("Text").style(.h1, .bold, .black)
                DText("Text").style(.b2, .semibold, .deepBlue40)
                Picker(
                    selection: $age, label: Text ("Picker"),
                    content: {
                        ForEach(18..<100) { number in
                            Text ("\(number)")
                                .font(.headline)
                                .foregroundColor (.red)
                        }
                    }
                )
                .pickerStyle(WheelPickerStyle())
                .frame(height: 120)
                Spacer()
            }
            .padding(.defaultLayoutPadding)
        }
    }
}

#Preview {
    DesignPreview()
}
