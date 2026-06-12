//
//  RecordContentType+GA.swift
//  Donmani
//
//  Created by 문종식 on 6/8/26.
//

import Domain

extension RecordContentType {
    var gaParameter: GA.Parameter {
        switch self {
        case .good: .good
        case .bad:  .bad
        }
    }
}
