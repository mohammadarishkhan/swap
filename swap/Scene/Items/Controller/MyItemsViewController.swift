//
//  MyItemsViewController.swift
//  swap
//
//  Created by Mohammad Arish Khan on 12/01/22.
//

import UIKit

protocol MyItemsViewControllerProtocol: AnyObject {
    func didSwapSuccessful(myItemId: String)
    
}

class MyItemsViewController: UIViewController {
    
    @IBOutlet weak var gestureView: UIView!
    weak var delegate: MyItemsViewControllerProtocol?
    
    var selectedEmail: String?
    var swapItem: ItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGesture()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemsTableViewController {
          vc.selectedEmail = selectedEmail
            vc.delegate = self
        }
        super.prepare(for: segue, sender: sender)
    }
    
}

private extension MyItemsViewController {
    func addGesture() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        swipeGesture.direction = .down
        self.gestureView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func getSwipeAction( _ recognizer: UISwipeGestureRecognizer) {
        self.dismiss(animated: true)
    }
}

extension MyItemsViewController: ItemsTableViewControllerProtocol {
    func getCellHeight() -> CGFloat {
        return 53
    }
    
    func didSelectItem(_ selectedItem: ItemModel?, indexPath: IndexPath) {
        let myItem = selectedItem?.title ?? ""
        let otherItem = swapItem?.title ?? ""
        guard selectedItem?.range == swapItem?.range else {
            showAlert("Try to swap with same price range")
            return
        }
        let vc = UIAlertController(title: "Swap", message: myItem + " with " + otherItem  , preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default) { (alert) in
            if let selectedItem = selectedItem {
                self.delegate?.didSwapSuccessful(myItemId: selectedItem.itemId)
                self.dismiss(animated: false)
            }
            
           
        }
        
        vc.addAction(okAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) 
        vc.addAction(cancelAction)
        
        self.present(vc, animated: true, completion:nil)
    }
}

