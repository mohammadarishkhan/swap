//
//  HomeViewController.swift
//  swap
//
//  Created by Zoeb Husain Sheikh on 02/10/21.
//

import UIKit

class HomeViewController: UIViewController {

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
