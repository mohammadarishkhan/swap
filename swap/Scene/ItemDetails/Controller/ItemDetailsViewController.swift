//
//  ItemDetailsViewController.swift
//  swap
//
//  Created by Bigsur on 26/12/21.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var pageIndicator: UIPageControl!
    
    var item: ItemModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    
}
private extension ItemDetailsViewController {
    func setup() {
        titleLabel.text = "Title: " + (item?.title ?? "")
        priceLabel.text = "Price: " + "\(item?.price ?? 0) INR"
        descriptionLabel.text = " About:" + (item?.description ?? "")
        let imageName = item?.imageNameList.first ?? ""
        changeImageByName(imageName: imageName)
        
        pageIndicator.numberOfPages = item?.imageNameList.count ?? 1
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        swipeLeftGesture.direction = .left
        
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.getSwipeAction(_:)))
        swipeRightGesture.direction = .right
        self.imageView.addGestureRecognizer(swipeLeftGesture)
        self.imageView.addGestureRecognizer(swipeRightGesture)
        
        // Check user emai
        let loggedInUserEmail = AuthenticationModel.loggedInUserEmail
        swapButton.isHidden = item?.email == loggedInUserEmail
    }
    
    @IBAction func swapButtonAction() {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ItemsTableViewControllerIdentifier") as? ItemsTableViewController else {
            return
        }
        viewController.selectedEmail = AuthenticationModel.loggedInUserEmail
        
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.swapItem = item
        
        self.present(viewController, animated: true)
    }
    
    @objc func getSwipeAction( _ recognizer : UISwipeGestureRecognizer) {
        var imageName: String?
        if recognizer.direction == .right && pageIndicator.currentPage != 0 {
        // previous image
            pageIndicator.currentPage -= 1
            imageName = item?.imageNameList[pageIndicator.currentPage]
            
        } else if recognizer.direction == .left && pageIndicator.currentPage != (pageIndicator.numberOfPages - 1) {
            // next image
            pageIndicator.currentPage += 1
            imageName = item?.imageNameList[pageIndicator.currentPage]
        }
        
        if let imageName = imageName {
            changeImageByName(imageName: imageName)
        }
    }
    
    func changeImageByName(imageName: String) {
        let image = ImageStore.retrieve(imageNamed: imageName)
        imageView.image = image
    }
}
