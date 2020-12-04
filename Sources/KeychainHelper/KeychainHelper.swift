//
//  KeychainHelper.swift
//  
//
//  Created by iWw on 2020/12/4.
//

import Foundation
import Keychain

public struct KeychainHelper {
    private init() { }
    
    private static var projectBundleIdentifier: String {
        (((Bundle.main.infoDictionary ?? [:])["CFBundleIdentifier"] as? String) ?? "") + "_uniqueIdentifier"
    }
    
    private static func generationUUID() -> String {
        NSUUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
}

public extension KeychainHelper {
    
    static var uniqueIdentifier: String = {
        #if DEBUG_KEYCHAIN_HELPER
        print("[KeychainHelper]: load uniqueIdentifier by key: \(projectBundleIdentifier)")
        #endif
        
        guard let uuid = Keychain.loadString(for: projectBundleIdentifier), uuid.count > 0 else {
            let newUUID = generationUUID()
            Keychain.save(value: newUUID, for: projectBundleIdentifier)
            return newUUID
        }
        return uuid
    }()
    
}
