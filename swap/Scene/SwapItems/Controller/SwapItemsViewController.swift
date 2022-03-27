//
//  SwapItemsViewController.swift
//  swap
//
//  Created by Mohammad Arish Khan on 13/01/22.
//

import UIKit



class SwapItemsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var tuples = [(ItemModel, ItemModel)]()
    var isIncominRequest: Bool = false
    var isSwappedApproved: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension SwapItemsViewController {
    
    func loadItems() {
        tuples.removeAll()
        let items = ItemModel.readItems()
        guard let swapItems = SwapItemsModel.readItems(for: AuthenticationModel.loggedInUserEmail, isIncominRequest: isIncominRequest) else {
            return
        }
        for mySwapItem in swapItems {
            if mySwapItem.isapproved != true {
                let myItem = items?.filter() {
                    $0.itemId == mySwapItem.myItemId
                }.first
                let otherItem = items?.filter() {
                    $0.itemId == mySwapItem.swapItemId
                }.first
                guard let myItem = myItem, let otherItem = otherItem else {
                    return
                }
                let tuple = isIncominRequest ? (otherItem, myItem) : (myItem, otherItem)
                tuples.append(tuple)
            }
        }
        
        tableView.reloadData()
    }
    
    func loadApprovedItems() {
        tuples.removeAll()
        let items = ItemModel.readItems()
        guard let swapItems = SwapItemsModel.readItems(for: AuthenticationModel.loggedInUserEmail, isIncominRequest: isIncominRequest, isApprovedItems: true) else {
            return
        }
        for mySwapItem in swapItems {
            if mySwapItem.isapproved == true {
                let myItem = items?.filter() {
                    $0.itemId == mySwapItem.myItemId
                }.first
                let otherItem = items?.filter() {
                    $0.itemId == mySwapItem.swapItemId
                }.first
                guard let myItem = myItem, let otherItem = otherItem else {
                    return
                }
                let tuple = myItem.email == AuthenticationModel.loggedInUserEmail ? (myItem, otherItem) : (otherItem, myItem)
                tuples.append(tuple)
            }
        }
        
        tableView.reloadData()
    }
}

extension SwapItemsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tuples.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SwapItemsTableViewCellIdentifier", for: indexPath) as? SwapItemsTableViewCell else {
            return UITableViewCell()
        }
        
        let tuple = tuples[indexPath.row]
        let myItem = tuple.0
        let otherItem = tuple.1
        if let imageName = myItem.imageNameList.first {
            let image = ImageStore.retrieve(imageNamed: imageName)
            cell.myItemImageView.image = image
            cell.myItemTitleLabel.text = myItem.title
            cell.myItemPriceLabel.text = "\(myItem.price) INR"
        }
        if let imageName = otherItem.imageNameList.first{
            let image = ImageStore.retrieve(imageNamed: imageName)
            cell.swapItemImageView.image = image
            cell.swapItemTitleLabel.text = otherItem.title
            cell.swapItemPriceLabel.text = "\(otherItem.price)INR"
            
            cell.swappedUserEmailLabel.text = otherItem.email
            let user = UserModel.readUsers(for: otherItem.email)?.first
            cell.swappedUserNamelabel.text = user?.name
            cell.swappedUserPhonelabel.text = "\(user?.phone ?? 0)"
            
            cell.swappedUserInfoView.isHidden = true
            cell.swapItemImageView.isHidden = false
        }
        cell.swapButton.borderWidth = isIncominRequest && !isSwappedApproved ? 1 : 0
        cell.swapButton.isEnabled = isIncominRequest && !isSwappedApproved
        
        cell.index = indexPath.row
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       guard isSwappedApproved, let cell = tableView.cellForRow(at: indexPath) as? SwapItemsTableViewCell else {
            return
        }
        
        cell.swappedUserInfoView.isHidden = !cell.swappedUserInfoView.isHidden
        cell.swapItemImageView.isHidden = !cell.swapItemImageView.isHidden
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
   
}

extension SwapItemsViewController: SwapItemsTableViewCellProtocol {
    func didItemSelected(index: Int) {
        let tuple = tuples[index]
        let myItem = tuple.0
        let otherItem = tuple.1
        
        let allSwapItem = SwapItemsModel.readItems(for: AuthenticationModel.loggedInUserEmail, isIncominRequest: true)
        
        let approveSwapItem = allSwapItem?.filter {
            $0.swapItemId == myItem.itemId && $0.myItemId == otherItem.itemId
        }.first
        guard var approveSwapItem = approveSwapItem else {
            return
        }
        approveSwapItem.isapproved = true
        approveSwapItem.updateSwapItem()
        showAlert(title: "Congrats!", "Now you can see your successful Swap item in 'Approved' Tab")
        loadItems()
        tableView.reloadData()
    }
    
    
}
