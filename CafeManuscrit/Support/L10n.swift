//
//  L10n.swift
//  CafeManuscrit
//

import Foundation

enum L10n {
    static func text(_ key: String, default defaultValue: String) -> String {
        NSLocalizedString(
            key,
            tableName: nil,
            bundle: .main,
            value: defaultValue,
            comment: ""
        )
    }
}
