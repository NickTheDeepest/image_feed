//
//  OAuth2TokenStorage.swift
//  image_feed
//
//  Created by Никита on 15.12.2023.
//

import Foundation

class OAuth2TokenStorage {
    
    private let userDefaults = UserDefaults.standard
    
    var token: String? {
        get {
            let token = userDefaults.string(forKey: "token")
            return token
        }
        set {
            userDefaults.set(newValue, forKey: "token")
        }
    }
}
