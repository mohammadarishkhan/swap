//
//  ItemsTableViewController.swift
//  swap
//
//  Created by Bigsur on 31/12/21.
//

import UIKit

protocol ItemsTableViewControllerProtocol: class {
    func didSwapSuccessful()
    
}

class ItemsTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gestureView: UIView!
    weak var delegate: ItemsTableViewControllerProtocol?
    
    
    private var items: [ItemModel]?
    var selectedEmail: String?
    var swapItem: ItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesture()
        loadItems()
    }
    
}

private extension ItemsTableViewController {
    func addGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        swipeGesture.direction = .down
        self.gestureView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func getSwipeAction( _ recognizer: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    func loadItems() {
        items = ItemModel.readItems(for: selectedEmail)
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
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = items?[indexPath.row]
        showSwipeAlert(selectedItem, indexPath: indexPath)
    }
    
    func showSwipeAlert(_ selectedItem: ItemModel?, indexPath: IndexPath) {
        let myItem = selectedItem?.title ?? ""
        let otherItem = swapItem?.title ?? ""
        let vc = UIAlertController(title: "Swap", message: myItem + " with " + otherItem  , preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            
            self.delegate?.didSwapSuccessful()
            self.dismiss(animated: false)
        }
        
        vc.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
        vc.addAction(cancelAction)
        
        self.present(vc, animated: true, completion:nil)
    }
}

