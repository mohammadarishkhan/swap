//
//  UserModel.swift
//  swap
//
//  Created by Zoeb Husain Sheikh on 28/09/21.
//

import Foundation

struct UserModel: Codable {
    let name: String
    let authentication: AuthenticationModel
}

extension UserModel {
    static func readUsers() -> [UserModel]? {                                                  //array of user model [user model]
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: "usersKey") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()                                             //JSONDecoder is code for decoding provided by swift

                // Decode User
                let users = try decoder.decode([UserModel].self, from: data)
                return users

            } catch {
                debugPrint("Unable to Decode UserModel (\(error))")
            }
        }
        
        return nil
    }
    
    func writeUser() {
        var users = UserModel.readUsers() ?? [UserModel]()
        users.append(self)

        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode User
            let data = try encoder.encode(users)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "usersKey")

        } catch {
            debugPrint("Unable to Encode Array of UserModel (\(error))")
        }
    }
}
