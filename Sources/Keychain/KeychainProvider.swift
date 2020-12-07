//
//  KeychainProvider.swift
//  
//
//  Created by iWw on 2020/12/4.
//

import Security

struct Provider {
    private init() { }
    
    enum SecClass {
        case generic
        case internet
        
        var value: CFString {
            switch self {
            case .generic:
                return kSecClassGenericPassword
            case .internet:
                return kSecClassInternetPassword
            }
        }
    }
    
    static func query(secClass: SecClass, service: String, account: String, sync: Bool = true) -> [CFString: Any] {
        var dict: [CFString: Any] = [
            kSecClass: secClass.value,
            kSecAttrService: service,
            kSecAttrAccount: account
        ]
        if sync {
            dict[kSecAttrSynchronizable] = kSecAttrSynchronizableAny
        }
        return dict
    }
    
}
