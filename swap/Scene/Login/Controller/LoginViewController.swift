//
//  LoginViewController.swift
//  swap
//
//  Created by Zoeb Husain Sheikh on 24/09/21.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var yourEmailTextField: UITextField!
    @IBOutlet weak var yourpasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: -validation
    func isloginValid() -> Bool {
        if yourEmailTextField.text == "" || isValidEmailOrPhone(yourEmailTextField.text ?? "") == false  {
            return false
        } else if yourpasswordTextField.text!.count < 6 {
            return false
        }
        return true
    }
    
    func showLoginAlert() {
        let vc = UIAlertController(title: "Error", message: "email and password is incorrect!" , preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func isValidEmailOrPhone(_ info: String) -> Bool {
        guard info.count == 10, let _ = Int(info) else {
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: info)
        }
        
        return true
    }
    
    func userInfo() -> UserModel? {
        
        if let users = UserModel.readUsers() {
            for user in users {
                debugPrint(user)
                if user.authentication.password == yourpasswordTextField.text {
                    if user.authentication.email.lowercased() == yourEmailTextField.text?.lowercased() {
                        return user
                    } else if let phone = Int(yourEmailTextField.text ?? ""), user.phone == phone {
                        return user
                    }
                }
            }
        }
        
        return nil
    }
    
    // MARK: - action
    @IBAction func loginButtonAction() {
        if isloginValid(), let user = userInfo() {
            // save user key into user defaults, to check whether it's already login or not
            user.authentication.didAuthSuccessful()
            if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerIdentifier") {
                self.navigationController?.viewControllers = [homeViewController]
            }

        } else {
            showLoginAlert()
        }
        
    }
    
    
}

