//
//  AuthenticationModel.swift
//  swap
//
//  Created by Mohammad Arish Khan on 28/09/21.
//

import Foundation

struct AuthenticationModel: Codable {
    let email: String
    let password: String
}

extension AuthenticationModel {
    // retun loggedin user email
    static var loggedInUserEmail: String? {
        UserDefaults.standard.string(forKey: "loginUserKey")
    }
    
    static func logout() {
        UserDefaults.standard.removeObject(forKey: "loginUserKey")
    }
    
    static var isAlreadyLogin: Bool {
        return loggedInUserEmail != nil
    }
    func didAuthSuccessful() {
        UserDefaults.standard.set(email, forKey: "loginUserKey")
    }
}
