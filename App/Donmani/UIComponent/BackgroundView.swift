//
//  BackgroundView.swift
//  Donmani
//
//  Created by 문종식 on 2/1/25.
//

import SwiftUI
import DesignSystem
import Domain

struct BackgroundView: View {
    let colors: [Color]
    
    init(colors: [Color] = [
        ColorPalette.Primary.deepBlue30,
        ColorPalette.Primary.deepBlue50
    ]) {
        self.colors = colors
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: colors,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .padding(-1)
        }
    }
}

#Preview {
    BackgroundView()
}
