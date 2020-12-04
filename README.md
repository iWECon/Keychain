# Keychain

A simple keychain tools.

## How to use?

```
let key = "thekeyofexample"
let value = "KeychainSwiftPackage"

// set
guard Keychain.save(value: value, for: key) else {
    print("save failed.")
    return
}
print("did save.")


// get 
guard let getValue = Keychain.value(for: key) as? String else {
    print("get failed.")
    return
}
print("get value: \(getValue)")

// update
let newValue = "Keychain for SwiftPM"
guard Keychain.update(value: newValue, for: key) else {
    print("update failed.")
    return
}
print("did update.")

// delete/remove
guard Keychain.remove(for: key) else {
    print("remove failed.")
    return
}
print("did remove.")
```


## KeychainHelper

Can use KeychainHelper to make `uniqueIdentifier`, it saves in keychain.

And the `service`(key) is the project's bundleIdentifer + "_uniqueIdentifier":
eg: 
Bundle Identifier: "cc.iwecon.keychain"
UniqueIdentiferService: "cc.iwecon.keychain_uniqueIdentifier" 


```
// will be return a String of unique identifier
KeychainHelper.uniqueIdentifer
```
