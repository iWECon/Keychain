import Foundation
import Security
import AdSupport

/// A simple wrapper of keychain
public class Keychain {
    
    public private(set) var service: String
    
    required public init(service: String) {
        self.service = service
    }
    
    /// the service is: Bundle.main.bundleIdentifer ?? ""
    public static let generic = Keychain(service: Bundle.main.bundleIdentifier ?? "")
    
}

extension Keychain {
    
    func query(forKey key: String) -> [CFString: Any] {
        Provider.query(secClass: .generic, service: service, account: key)
    }
}

public extension Keychain {
    
    /// update if exists, add if not exists.
    @discardableResult func set(_ value: NSCoding, forKey key: String) -> Bool {
        set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: key)
    }
    
    @discardableResult func set(_ value: String, forKey key: String) -> Bool {
        guard let data = value.data(using: .utf8) else {
            return false
        }
        return set(data, forKey: key)
    }
    
    @discardableResult func set(_ value: Data, forKey key: String) -> Bool {
        var query = self.query(forKey: key)
        if SecItemCopyMatching(query as CFDictionary, nil) == noErr { // update if exists
            let changes = [kSecValueData: value]
            return SecItemUpdate(query as CFDictionary, changes as CFDictionary) == noErr
        }
        // add if not exists
        query[kSecValueData] = value
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }
    
    @discardableResult func data(forKey key: String) -> Data? {
        var query = self.query(forKey: key)
        query[kSecReturnData] = kCFBooleanTrue
        query[kSecMatchLimit] = kSecMatchLimitOne
        
        var keyData: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &keyData) == noErr {
            guard let kd = keyData as? Data else { return nil }
            return kd
        }
        return nil
    }
    
    @discardableResult func object(forKey key: String) -> Any? {
        guard let dt = data(forKey: key) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: dt)
    }
    
    @discardableResult func string(forKey key: String) -> String? {
        guard let dt = data(forKey: key) else { return nil }
        return String(data: dt, encoding: .utf8)
    }
    
    @discardableResult func remove(key: String) -> Bool {
        let keyChain = query(forKey: key)
        return SecItemDelete(keyChain as CFDictionary) == noErr
    }
}
