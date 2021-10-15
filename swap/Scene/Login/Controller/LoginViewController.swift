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
        if yourEmailTextField.text == "" || isValidEmail(yourEmailTextField.text ?? "") == false  {
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
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isUserExist() -> Bool {
        
        if let users = UserModel.readUsers() {
            for user in users {
                debugPrint(user)
                if user.authentication.email.lowercased() == yourEmailTextField.text?.lowercased() && user.authentication.password == yourpasswordTextField.text {
                    return true
                }
            }
            
        }
        
        return false
    }
    
    // MARK: - action
    @IBAction func LoginButtonAction() {
        if isloginValid() && isUserExist() {
            if let email = yourEmailTextField.text {
                let authenticationModel = AuthenticationModel(email: email, password: "")
                authenticationModel.didAuthSuccessful()
            }
            if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerIdentifier") {
                self.navigationController?.viewControllers = [homeViewController]
            }

        } else {
            showLoginAlert()
        }
        
    }
    
    
}

