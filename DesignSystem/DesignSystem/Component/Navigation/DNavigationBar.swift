//
//  DNavigationBar.swift
//  DesignSystem
//
//  Created by 문종식 on 8/28/25.
//

import SwiftUI

public struct DNavigationBar<Leading: View, Title: View, Trailing: View>: View {
    private let leading: () -> Leading
    private let title: () -> Title
    private let trailing: () -> Trailing
    
    public init(
        @ViewBuilder leading: @escaping () -> Leading = { Spacer() },
        @ViewBuilder title: @escaping () -> Title = { Spacer() },
        @ViewBuilder trailing: @escaping () -> Trailing = { Spacer() }
    ) {
        self.leading = leading
        self.title = title
        self.trailing = trailing
    }
    
    public var body: some View {
        ZStack {
            HStack {
                leading()
                Spacer()
                trailing()
            }
            HStack {
                Spacer()
                title()
                Spacer()
            }
        }
        .frame(height: .s3)
        .padding(.vertical, .s5)
        .padding(.horizontal, .defaultLayoutPadding)
    }
}

#Preview {
    DNavigationBar(
        leading: {
            
        }, title: {
            
        }, trailing: {
            
        }
    )
}
