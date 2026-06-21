//
//  Optional+Extension.swift
//  Core
//
//  Created by 문종식 on 8/6/25.
//

public extension Optional {
    var isNil: Bool {
        switch self {
        case .none: true
        case .some: false
        }
    }

    var isSome: Bool {
        !isNil
    }

    func map<T>(_ action: (Wrapped) -> T?) -> T? {
        if let value = self {
            return action(value)
        }
        return nil
    }
}
