//
//  HomeViewController.swift
//  swap
//
//  Created by Zoeb Husain Sheikh on 02/10/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var categoryImages: [String] = ["Electronics", "Fashion", "Furniture", "HomeAppliances", "Toys&Games", "Others"]
    private var categoryImagesTitle: [String] = ["Electronics", "Fashion", "Furniture", "Home Appliances", "Toys & Games", "Others"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let addBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
        navigationItem.rightBarButtonItem = addBarButton

    }
    
   @objc func addTapped() {
        performSegue(withIdentifier: "AddItemViewControllerIdentifier", sender: self)
    }

}
 
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCellIdentifier", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let image = UIImage(named: categoryImages[indexPath.row]) {
            cell.categoryImageView.image = image
        }
         
        cell.categoryTitleLabel.text = categoryImagesTitle[indexPath.row]
        
        return cell
        
        
    }
    
    
    
}
