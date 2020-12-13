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
        print("[KeychainHelper.uniqueIdentifer]: \(value)")
        #endif
    }
    
    static func uniqueIdentifier(_ key: String = "uniqueIdentifier", forService service: String = Bundle.main.bundleIdentifier ?? "") -> String {
        let uniqueIdentifierKey = service + "." + key
        DebugLog("will get identifier for key: \(uniqueIdentifierKey), service: \(service)")
        var keychain = Keychain.generic
        if service != projectBundleIdentifier {
            keychain = Keychain(service: service)
        }
        
        guard let uuid = keychain.string(forKey: uniqueIdentifierKey), uuid.count > 0 else {
            let newUUID = generationUUID()
            keychain.set(newUUID, forKey: uniqueIdentifierKey)
            DebugLog("[New] did get uuid(\(newUUID) for key: \(uniqueIdentifierKey), service: \(service)")
            return newUUID
        }
        DebugLog("[Keychain] did get uuid(\(uuid)) for key: \(uniqueIdentifierKey), service: \(service)")
        return uuid
    }
}
