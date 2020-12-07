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

public extension Keychain {
    
    func query(forKey key: String) -> [CFString: Any] {
        Provider.query(secClass: .generic, service: service, account: key)
    }
    
    func data(forKey key: String) -> Data? {
        let query = self.query(forKey: key)
        var keyData: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &keyData) == noErr {
            guard let kd = keyData as? Data else { return nil }
            return kd
        }
        return nil
    }
}

public extension Keychain {
    
    /// update if exists, add if not exists.
    @discardableResult func set(value: Any, forKey key: String) -> Bool {
        var query = self.query(forKey: key)
        if SecItemCopyMatching(query as CFDictionary, nil) == noErr { // update if exists
            let changes = [kSecValueData: NSKeyedArchiver.archivedData(withRootObject: value)]
            return SecItemUpdate(query as CFDictionary, changes as CFDictionary) == noErr
        }
        // add if not exists
        query[kSecValueData] = NSKeyedArchiver.archivedData(withRootObject: value)
        return SecItemAdd(query as CFDictionary, nil) == noErr
    }
    
    @discardableResult func value(forKey key: String) -> Any? {
        var keychain = self.query(forKey: key)
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
    
    @discardableResult func string(forKey key: String) -> String? {
        value(forKey: key) as? String
    }
    
    @discardableResult func remove(key: String) -> Bool {
        let keyChain = query(forKey: key)
        return SecItemDelete(keyChain as CFDictionary) == noErr
    }
}
