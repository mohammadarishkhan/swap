//
//  AuthenticationModel.swift
//  swap
//
//  Created by Zoeb Husain Sheikh on 28/09/21.
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
    
    static var isAlreadyLogin: Bool {
        return loggedInUserEmail != nil
    }
    func didAuthSuccessful() {
        UserDefaults.standard.set(email, forKey: "loginUserKey")
    }
}
