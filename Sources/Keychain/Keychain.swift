import Foundation
import Security
import AdSupport

public struct Keychain {
    private init() { }
    
    
    /// Search info in keychain by service
    /// - Parameter service: service of info
    /// - Returns: [CFString: Any]
    private static func search(by service: String) -> [CFString: Any] {
        [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: service,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlock
        ]
    }
}

public extension Keychain {
    
    @discardableResult static func save(value: Any, for service: String) -> Bool {
        var keychain = search(by: service)
        if SecItemCopyMatching(keychain as CFDictionary, nil) == noErr {
            SecItemDelete(keychain as CFDictionary)
        }
        keychain[kSecValueData] = NSKeyedArchiver.archivedData(withRootObject: value)
        return SecItemAdd(keychain as CFDictionary, nil) == noErr
    }
    
    @discardableResult static func value(for service: String) -> Any? {
        var keychain = search(by: service)
        keychain[kSecReturnData] = kCFBooleanTrue
        keychain[kSecMatchLimit] = kSecMatchLimitOne
        
        var ret: Any?
        var keyData: CFTypeRef?
        if SecItemCopyMatching(keychain as CFDictionary, &keyData) == noErr {
            guard let kd = keyData as? Data else { return nil }
            ret = NSKeyedUnarchiver.unarchiveObject(with: kd)
        }
        return ret
    }
    
    @discardableResult static func loadString(for service: String) -> String? {
        value(for: service) as? String
    }
    
    @discardableResult static func remove(for service: String) -> Bool {
        let keyChain = search(by: service)
        return SecItemDelete(keyChain as CFDictionary) == noErr
    }
    
    @discardableResult static func update(value: Any, for service: String) -> Bool {
        let keyChain = search(by: service)
        let changes = [kSecValueData: NSKeyedArchiver.archivedData(withRootObject: value)]
        return SecItemUpdate(keyChain as CFDictionary, changes as CFDictionary) == noErr
    }
}

// MARK:- Deprecated
public extension Keychain {
    
    @available(*, deprecated, renamed: "save(value:for:)", message: "use `save(value:for:) instead.`")
    @discardableResult static func save(service: String, value: Any) -> Bool {
        save(value: value, for: service)
    }
    
    @available(*, deprecated, renamed: "value(for:)", message: "use `value(for:)` instead.")
    @discardableResult static func load(for service: String) -> Any? {
        value(for: service)
    }
    
    @available(*, deprecated, renamed: "loadString(for:)", message: "use `loadString(for:)` instead.")
    @discardableResult static func loadString(serivce: String) -> String? {
        loadString(for: serivce)
    }
    
    @available(*, deprecated, renamed: "loadString(for:)", message: "use `loadString(for:)` instead.")
    @discardableResult static func delete(service: String) -> Bool {
        remove(for: service)
    }
    
    @available(*, deprecated, renamed: "update(value:for:)", message: "use `update(value:for:)` instead.")
    @discardableResult static func update(service: String, value: Any) -> Bool {
        update(value: value, for: service)
    }
}
