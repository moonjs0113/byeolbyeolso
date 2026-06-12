//
//  RewardItemData.swift
//  Donmani
//
//  Created by 문종식 on 10/12/25.
//

import Foundation
import Domain

struct RewardItemData: Equatable {
    let backgroundItem: Data?
    let effectItem: Data?
    let decorationItemId: Int?
    let decorationItemName: String?
    let bottleItemId: Int?
    let bottleShape: BottleShape?
}
