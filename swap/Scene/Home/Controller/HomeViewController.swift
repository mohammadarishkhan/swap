//
//  HomeViewController.swift
//  swap
//
//  Created by Mohammad Arish Khan on 02/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var itemsVCContainerView: UIView!
    
    private var categoryImages: [String] = ["electronics", "fashion", "furniture", "appliances", "games", "books", "other"]
    private var categoryImagesTitle: [String] = ["Electronics", "Fashion", "Furniture", "Home Appliances", "Toys & Games", "Books", "Others"]
    private var selectedCategoryIndex: Int?
    private var itemsVC: ItemsViewController?
    private var selectedItem: ItemModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButton
        
        let image = UIImage(named: "profile_placeholder")
        let profileBarButton = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(userProfileTapped))
        navigationItem.leftBarButtonItem = profileBarButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var category: String?
        if let selectedCategoryIndex = selectedCategoryIndex {
            category = categoryImagesTitle[selectedCategoryIndex]
        }
        itemsVC?.refresh(category: category)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemsViewController {
            self.itemsVC = vc
            self.itemsVC?.delegate = self
        } else if let vc = segue.destination as? ItemDetailsViewController {
            vc.item = selectedItem
        }
    }
    
   @objc func addTapped() {
        performSegue(withIdentifier: "AddItemViewControllerIdentifier", sender: self)
    }
    
    @objc func userProfileTapped() {
        performSegue(withIdentifier: "UserViewControllerIdentifier", sender: self)
    }

}
 
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImages.count                                                     
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCellIdentifier", for: indexPath) as? HomeCollectionViewCell else {                                  //provide cell
            return UICollectionViewCell()
        }
        
        if let image = UIImage(named: categoryImages[indexPath.item]) {
            cell.categoryImageView.image = image
        }
        
        cell.categoryTitleLabel.text = categoryImagesTitle[indexPath.item]
        
        if indexPath.item == selectedCategoryIndex {
            select(cell: cell)
        } else {                                                                  //for select item on click
            reset(cell: cell)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {           //click action
        let cell = collectionView.cellForItem(at: indexPath)
        
        if indexPath.item == selectedCategoryIndex {
            reset(cell: cell)                                                     //this code for reset selected iteam on click
            selectedCategoryIndex = nil
            itemsVC?.refresh()
        } else {
            selectedCategoryIndex = indexPath.item
            
            for cell in collectionView.visibleCells {
                reset(cell: cell)
            }
            
            select(cell: cell)
                let category = categoryImagesTitle[indexPath.item]
            itemsVC?.refresh(category: category)
        }
    }
}

private extension HomeViewController {
    func reset(cell: UICollectionViewCell?) {
        cell?.contentView.borderWidth = 1                                         //default stage of iteam cell
        cell?.contentView.borderColor = .darkGray
    }
    
    func select(cell: UICollectionViewCell?) {
        cell?.contentView.borderWidth = 3                                         //when iteam is selected.....
        cell?.contentView.borderColor = .white
    }
}

extension HomeViewController: ItemsViewControllerProtocol {
    func didSelectedItem(item: ItemModel) {
        selectedItem = item
        performSegue(withIdentifier: "ItemDetailsViewControllerIdentifier", sender: self)
    }
}
