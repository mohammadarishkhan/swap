//
//  ItemsViewController.swift
//  swap
//
//  Created by Bigsur on 21/12/21.
//

import UIKit

class ItemsViewController: UIViewController {
    lazy var cellSize = (self.view.frame.width - 30) / 2
    @IBOutlet weak private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionView.collectionViewLayout = layout
    }

}

private extension ItemsViewController {
    
}

extension ItemsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCellIdentifier", for: indexPath) as? ItemCollectionViewCell else {                                  //provide cell
            return UICollectionViewCell()
        }
        
        if let image = UIImage(named: "macbook") {
            cell.itemImageView.image = image
        }
        
        cell.itemTitleLabel.text = "MacBook Pro"
        cell.itemPriceLabel.text = "1,75,000 INR"
       
        return cell
     
    }
}
