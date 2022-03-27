//
//  SwapItemsModel.swift
//  swap
//
//  Created by Arish Khan on 23/03/22.
//

import Foundation

struct SwapItemsModel: Codable{
    let myItemId: String
    let swapItemId: String
    let date: Date
    let myEmail: String
    let swapEmail: String
    var isapproved: Bool? = false
    
}

extension SwapItemsModel {
    static func readItems(for email: String? = nil, isIncominRequest: Bool = false, isApprovedItems: Bool = false) -> [SwapItemsModel]? {
        //array of item model [item model]
        // Read/Get Data
        if let data = UserDefaults.standard.data(forKey: "swapItemsKey") {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()
                //JSONDecoder is code for decoding provided by swift
                
                // Decode SwapItem
                let swapItems = try decoder.decode([SwapItemsModel].self, from: data)
                guard let email = email else {
                    // To return all items
                    return swapItems
                }
                
                // To return filtered items as per email
                if isApprovedItems {
                    let filteredItems = swapItems.filter {
                        return $0.swapEmail == email || $0.myEmail == email
                    }
                    return filteredItems
                } else {
                    let filteredItems = swapItems.filter {
                        if isIncominRequest {
                            return $0.swapEmail == email
                        } else {
                            return $0.myEmail == email
                        }
                    }
                    return filteredItems
                }
                
            } catch {
                debugPrint("Unable to Decode ItemModel (\(error))")
            }
        }
        
        return nil
    }
    
    func writeItem() -> Bool {
        var swapItems = SwapItemsModel.readItems() ?? [SwapItemsModel]()
        let existSwapItems = swapItems.filter {
            return $0.myEmail == self.myEmail && $0.myItemId == self.myItemId && $0.swapItemId == self.swapItemId
        }
        if existSwapItems.isEmpty {
            swapItems.append(self)
            
            do {
                // Create JSON Encoder
                let encoder = JSONEncoder()
                
                // Encode Items
                let data = try encoder.encode(swapItems)
                
                // Write/Set Data
                UserDefaults.standard.set(data, forKey: "swapItemsKey")
                return true
                
            } catch {
                debugPrint("Unable to Encode Array of ItemModel (\(error))")
            }
        }
        
        return false
    }
    
    func updateSwapItem() {
        let swapItems = SwapItemsModel.readItems() ?? [SwapItemsModel]()
        var updatedSwapItems = [SwapItemsModel]()
        for swapItem in swapItems {
            var updateSwapItem = swapItem
            if swapItem.swapItemId == self.swapItemId && swapItem.myItemId == self.myItemId {
                updateSwapItem.isapproved = self.isapproved
            }
            updatedSwapItems.append(updateSwapItem)
        }
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode SwapItem
            let data = try encoder.encode(updatedSwapItems)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: "swapItemsKey")

        } catch {
            debugPrint("Unable to Encode Array of SwapItemModel (\(error))")
        }
    }
}
