//
//  View+Extension.swift
//  DesignSystem
//
//  Created by 문종식 on 2/8/26.
//

import SwiftUI

public extension View {
    /// @inlinable nonisolated public func background<Background>(_ background: Background, alignment: Alignment = .center) -> some View where Background : View
    func clearBackground() -> some View {
        self.background(ClearBackground())
    }
}
