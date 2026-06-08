//
//  ModalConfig.swift
//  Donmani
//
//  Created by 문종식 on 2/8/26.
//

import SwiftUI
import Domain

struct ModalConfig {
    let backgroundColor: Color
    let isEnableDismiss: Bool
    
    init(
        backgroundColor: Color,
        isEnableDismiss: Bool = true,
    ) {
        self.backgroundColor = backgroundColor
        self.isEnableDismiss = isEnableDismiss
    }
}
