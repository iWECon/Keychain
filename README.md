# Keychain

A simple keychain tools.

## How to use?


#### GenericPassword
```swift
// use default service for BundleIdentifier
let keychain = Keychain.generic

// or custome
let keychain = Keychain(serivce: "custome-service-name")
```

#### Set/Add
```swift

let key = "KeychainTestKey"
let value = "isKeychainTest"

// set or update, string
keychain.set(value, forKey: key)

// other, object
keychain.set(UIViewController(), forKey: key)

// or data
keychain.set(Data(), forKey: key)
```

#### Get
```swift
// get String?
keychain.string(forKey: key) // result: isKeychainTest

// get Any?
keychain.object(forKey: key)

// get Data?
keychain.data(forKey: key)
```

#### Remove/Delete
```swift
keychain.remove(key: key)
```


## KeychainHelper

Can use KeychainHelper to make `uniqueIdentifier`, it saves in keychain.

And the `service`(key) is the project's bundleIdentifer + "." + "uniqueIdentifier":
eg: 
Bundle Identifier: "cc.iwecon.keychain"
UniqueIdentiferService: "cc.iwecon.keychainuniqueIdentifier" 


```swift
// will be return a String of unique identifier
// default key: uniqueIdentifier
// default service: Bundle.main.bundleIdentifier ?? ""
KeychainHelper.uniqueIdentifier()

// or you can custome key and service for Keychain
KeychainHelper.uniqueIdentifier("the-key-of-unique-identifier", forService: "com.xxxx.app.service")
```


## Install


#### Swift Package Manager
```swift
.package("https://github.com/iWECon/Keychain", from: "3.0.0")
```
