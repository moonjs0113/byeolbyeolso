//
//  FortuneResponse+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/15/26.
//

import DNetwork
import Domain

extension FortuneResponse {
    func toDomain() -> Fortune {
        Fortune(
            day: Day(yyyymmdd: self.targetDate) ?? .today,
            title: self.title,
            subtitle: self.subtitle,
            content: self.content,
            item: self.item
        )
    }
}
