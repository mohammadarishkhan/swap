//
//  ItemsTableViewController.swift
//  swap
//
//  Created by Mohammad Arish Khan on 31/12/21.
//

import UIKit

protocol ItemsTableViewControllerProtocol: AnyObject {
    func didSelectItem(_ selectedItem: ItemModel?, indexPath: IndexPath)
    func getCellHeight() -> CGFloat
}

class ItemsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    weak var delegate: ItemsTableViewControllerProtocol?
    
    private var items: [ItemModel]?
    var selectedEmail: String?
    var titleLabelYValue: CGFloat = -10
    var priceLabelYValue: CGFloat = 10
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()
    }
    
}

private extension ItemsTableViewController {
    
    func loadItems() {
        items = ItemModel.readItems(for: selectedEmail)
        if let items = items {
            let swapItems = SwapItemsModel.readItems()
            let approvedSwapItems = swapItems?.filter {
                $0.isapproved == true
            }
            
            var itemList = [ItemModel]()
            for item in items {
                var shouldAdd = true
                if let approvedSwapItems = approvedSwapItems, !approvedSwapItems.isEmpty {
                    for approvedSwapItem in approvedSwapItems {
                        if item.itemId == approvedSwapItem.myItemId ||
                            item.itemId == approvedSwapItem.swapItemId {
                            shouldAdd = false
                        }
                    }
                }
                
                if shouldAdd {
                    itemList.append(item)
                }
            }
            
            self.items = itemList
        }
        tableView.reloadData()
    }
}

extension ItemsTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCellIdentifier", for: indexPath) as? ItemTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = items?[indexPath.item], let imageName = item.imageNameList.first {
            let image = ImageStore.retrieve(imageNamed: imageName)
            cell.itemImageView.image = image
            cell.itemTitleLabel.text = item.title
            cell.itemPriceLabel.text = "\(item.price) INR"
            cell.titleLabelYLayoutConstraint.constant = titleLabelYValue
            cell.priceLabelYLayoutConstraint.constant = priceLabelYValue
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return delegate?.getCellHeight() ?? 53
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedItem = items?[indexPath.row]
        delegate?.didSelectItem(selectedItem, indexPath: indexPath)
    }
    
}

