//
//  Collection+Extension.swift
//  Core
//
//  Created by 문종식 on 8/6/26.
//

public extension Collection where Index == Int {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
