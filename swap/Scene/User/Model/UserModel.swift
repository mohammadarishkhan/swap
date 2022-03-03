//
//  UserModel.swift
//  swap
//
//  Created by Mohammad Arish Khan on 28/09/21.
//

import Foundation

struct UserModel: Codable {
    let name: String
    let phone: Int
    var imageName: String?
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
   
    func updateUser() {
        let users = UserModel.readUsers() ?? [UserModel]()
        var updatedUsers = [UserModel]()
        for user in users {
            var updateUser = user
            if user.authentication.email.lowercased() == self.authentication.email.lowercased() {
                updateUser.imageName = self.imageName
            }
            updatedUsers.append(updateUser)
        }
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode User
            let data = try encoder.encode(updatedUsers)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "usersKey")

        } catch {
            debugPrint("Unable to Encode Array of UserModel (\(error))")
        }
    }
}
