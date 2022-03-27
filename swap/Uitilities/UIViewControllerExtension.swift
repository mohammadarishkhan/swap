//
//  UIViewControllerExtension.swift
//  swap
//
//  Created by Arish Khan on 23/03/22.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(title: String? = "Error", _ message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
    }
}
