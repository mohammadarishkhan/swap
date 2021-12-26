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
        let image = ImageStore.retrieve(imageNamed: imageName)
        imageView.image = image
        
    }
    
}
