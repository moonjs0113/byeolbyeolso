//
//  String+Extension.swift
//  Donmani
//
//  Created by 문종식 on 2/15/25.
//

import Foundation
import Domain

extension String {
    var convertUppercaseFirstChar: String {
        var string = self
        string.removeFirst()
        return (self.first?.uppercased() ?? "") + string
    }
    
    var isNotEmpty: Bool {
        !isEmpty
    }
    
    /// 한글 문자 종성 유무 반환
    var hasFinalConsonant: Bool {
        guard let lastChar = self.last else { return false }
        guard let scalar = lastChar.unicodeScalars.first else { return false }
        let code = scalar.value
        if code >= 0xAC00 && code <= 0xD7A3 {
            // 종성
            let jongseong = (code - 0xAC00) % 28
            return jongseong != 0
        }
        return false
    }
}
