//
//  ItemsViewController.swift
//  swap
//
//  Created by Bigsur on 21/12/21.
//

import UIKit

protocol ItemsViewControllerProtocol: class {
    func didSelectedItem(item: ItemModel)
}


class ItemsViewController: UIViewController {
    
    @IBOutlet weak private var collectionView: UICollectionView!
    
    private var items: [ItemModel]?
    lazy var cellSize = (self.view.frame.width - 30) / 2
    var selectedCategory: String?
    weak var delegate: ItemsViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        collectionView.collectionViewLayout = layout
    }
    
    
    func refresh(category: String? = nil) {
        selectedCategory = category
        loadItems()
    }
    
}

private extension ItemsViewController {
    func loadItems() {
        items = ItemModel.readItems()
        if let category = selectedCategory, let items = items {
            self.items = items.filter {
                $0.category == category
            }
        }
        collectionView.reloadData()
    }
}

extension ItemsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCellIdentifier", for: indexPath) as? ItemCollectionViewCell else {                                  //provide cell
            return UICollectionViewCell()
        }
        
        if let item = items?[indexPath.item], let imageName = item.imageNameList.first {
            let image = ImageStore.retrieve(imageNamed: imageName)
            cell.itemImageView.image = image
            cell.itemTitleLabel.text = item.title
            cell.itemPriceLabel.text = "\(item.price) INR"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {           //click action
        guard let selectedItem = items?[indexPath.item] else { return }
        delegate?.didSelectedItem(item: selectedItem)
    }
    
}



 
