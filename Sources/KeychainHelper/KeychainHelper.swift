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
    
    private static func DebugLog(_ value: String) {
        #if DEBUG
        print("[KeychainHelper.uniqueIdentifer]: ")
        #endif
    }
    
    static func uniqueIdentifer(_ key: String = "_uniqueIdentifier", forService service: String = Bundle.main.bundleIdentifier ?? "") -> String {
        DebugLog("will get identifier for key: \(key), service: \(service)")
        var keychain = Keychain.generic
        if service != projectBundleIdentifier {
            keychain = Keychain(service: service)
        }
        guard let uuid = keychain.string(forKey: key), uuid.count > 0 else {
            let newUUID = generationUUID()
            keychain.set(value: newUUID, forKey: key)
            DebugLog("[New] did get uuid(\(newUUID) for key: \(key), service: \(service)")
            return newUUID
        }
        DebugLog("[Keychain] did get uuid(\(uuid)) for key: \(key), service: \(service)")
        return uuid
    }
}
