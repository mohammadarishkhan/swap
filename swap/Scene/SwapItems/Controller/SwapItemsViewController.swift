//
//  SwapItemsViewController.swift
//  swap
//
//  Created by Bigsur on 13/01/22.
//

import UIKit

class SwapItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var selectedEmail: String?
    private var items: [ItemModel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
}
    
    private extension SwapItemsViewController {
        
        func loadItems() {
            items = ItemModel.readItems(for: selectedEmail)
            tableView.reloadData()
        }
    }
    
    extension SwapItemsViewController: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwapItemsTableViewCellIdentifier", for: indexPath) as? SwapItemsTableViewCell else {
                return UITableViewCell()
            }
            
            if let item = items?[indexPath.item], let imageName = item.imageNameList.first {
                let image = ImageStore.retrieve(imageNamed: imageName)
                cell.itemImageView.image = image
                cell.itemTitleLabel.text = item.title
                cell.itemPriceLabel.text = "\(item.price) INR"
            }
            
            return cell
        }
        
        
    }

