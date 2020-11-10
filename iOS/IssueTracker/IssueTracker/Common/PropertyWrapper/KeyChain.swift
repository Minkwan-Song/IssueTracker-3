//
//  KeyChain.swift
//  IssueTracker
//
//  Created by 송민관 on 2020/11/09.
//

import Foundation

@propertyWrapper
struct KeyChain {
    let key: String
    let defaultValue: String

    init(key: String, defaultValue: String = "") {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: String {
        get {
            return KeychainAccess.shared.get(forAccountKey: key) ?? defaultValue
        }
        set {
            do {
                try KeychainAccess.shared.set(newValue, forAccountKey: key)
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}
