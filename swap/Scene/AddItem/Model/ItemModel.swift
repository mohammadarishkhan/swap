//
//  ItemModel.swift
//  swap
//
//  Created by Bigsur on 15/10/21.
//

import Foundation

struct ItemModel: Codable {
    let itemId: String
    let title: String
    let price: Int
    let category: String
    let description: String
    let imageNameList: [String]
    let email: String                                                            // To store user's reference
}

extension ItemModel {
    static func readItems(for email: String? = nil) -> [ItemModel]? {
        //array of item model [item model]
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: "itemsKey") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                //JSONDecoder is code for decoding provided by swift

                // Decode User
                let items = try decoder.decode([ItemModel].self, from: data)
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
                debugPrint("Unable to Decode ItemModel (\(error))")
            }
        }
        
        return nil
    }
    
    func writeItem() {
        var items = ItemModel.readItems() ?? [ItemModel]()
        items.append(self)

        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Items
            let data = try encoder.encode(items)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "itemsKey")

        } catch {
            debugPrint("Unable to Encode Array of ItemModel (\(error))")
        }
    }
    
    //Note: This function is only call when we need to update ItemModel with new property
    /*static func updateAllItems() {
        var itemList = [ItemModel]()
        if let items = ItemModel.readItems() {
            for item in items {
                var itemObj = item
                itemObj.itemId = UUID().uuidString
                itemList.append(itemObj)
            }
            
            do {
                // Create JSON Encoder
                let encoder = JSONEncoder()
                
                // Encode Items
                let data = try encoder.encode(itemList)
                
                // Write/Set Data
                UserDefaults.standard.set(data, forKey: "itemsKey")
                
            } catch {
                debugPrint("Unable to Encode Array of ItemModel (\(error))")
            }
        }
    } */
}

