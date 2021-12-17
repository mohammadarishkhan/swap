//
//  AddItemModel.swift
//  swap
//
//  Created by Bigsur on 15/10/21.
//

import Foundation

struct AddItemModel: Codable {
    let title: String
    let price: Int
    let category: String
    let description: String
    let email: String                                                            // To store user's reference
}

extension AddItemModel {
    static func readItems(for email: String? = nil) -> [AddItemModel]? {
        //array of item model [item model]
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: "itemsKey") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                //JSONDecoder is code for decoding provided by swift

                // Decode User
                let items = try decoder.decode([AddItemModel].self, from: data)
                guard let email = email else {
                    // To return all items
                    return items
                }
                
                // To return filtered items as per email
                let filteredItems = items.filter {
                    $0.email == email
                }
                return filteredItems

            } catch {
                debugPrint("Unable to Decode AddItemModel (\(error))")
            }
        }
        
        return nil
    }
    
    func writeItem() {
        var items = AddItemModel.readItems() ?? [AddItemModel]()
        items.append(self)

        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Items
            let data = try encoder.encode(items)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "itemsKey")

        } catch {
            debugPrint("Unable to Encode Array of AddItemModel (\(error))")
        }
    }
}

