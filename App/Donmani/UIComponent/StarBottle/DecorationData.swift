//
//  DecorationData.swift
//  Donmani
//
//  Created by 문종식 on 9/14/25.
//

import Foundation
import Domain

struct DecorationData {
    let backgroundRewardData: Data?
    let effectRewardData: Data?
    let decorationRewardName: String?
    let decorationRewardId: Int?
    let showsDefaultFortuneToby: Bool
    let bottleRewardId: Int?
    let bottleShape: BottleShape
    
    init(
        backgroundRewardData: Data?,
        effectRewardData: Data?,
        decorationRewardName: String?,
        decorationRewardId: Int?,
        showsDefaultFortuneToby: Bool = true,
        bottleRewardId: Int?,
        bottleShape: BottleShape
    ) {
        self.backgroundRewardData = backgroundRewardData
        self.effectRewardData = effectRewardData
        self.decorationRewardName = decorationRewardName
        self.decorationRewardId = decorationRewardId
        self.showsDefaultFortuneToby = showsDefaultFortuneToby
        self.bottleRewardId = bottleRewardId
        self.bottleShape = bottleShape
    }
}
