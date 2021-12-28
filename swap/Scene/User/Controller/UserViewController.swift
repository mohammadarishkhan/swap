//
//  UserViewController.swift
//  swap
//
//  Created by Bigsur on 28/12/21.
//

import UIKit

class UserViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logoutBarButton
    }
    
    @objc func logoutTapped() {
        logoutAlert()
        
    }
    
    func logoutAlert() {
        let vc = UIAlertController(title: "Logout", message: "Are you sure?", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
            AuthenticationModel.logout()
            if let signupViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignupViewControllerIdentifier") as? SignupViewController {
                self.navigationController?.viewControllers = [signupViewController]
                signupViewController.showLoginVC()
            }
        }
        vc.addAction(OKAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        vc.addAction(cancelAction)
        self.present(vc, animated: true, completion:nil)
    }
    
}
