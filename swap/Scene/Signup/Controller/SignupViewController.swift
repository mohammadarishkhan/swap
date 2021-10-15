//
//  SignupViewController.swift
//  swap
//
//  Created by Zoeb Husain Sheikh on 24/09/21.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    //MARK: - Validation
    func performValidation() -> Bool {
        
        if nameTextField.text!.count < 4 {
            showAlert("Name should be 4 or more characters")
            return false
        } else if isValidEmail(emailTextField.text ?? "") == false {
            showAlert("Email must be valid")
            return false
        } else if passwordTextField.text!.count < 6{
            showAlert("password must be greater than 6 character")
            return false
        } else if passwordTextField.text != confirmPasswordTextField.text {
            showAlert("password not matched")
            return false
        }
        return true
        
    }
    
    func showAlert(_ message: String) {
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
                if user.authentication.email.lowercased() == emailTextField.text?.lowercased()  {
                    showAlert("Email already exist")
                    return true
                }
            }
            
        }
        
        return false
    }
    
    //MARK: - Actions
    
    @IBAction func signupButtonAction() {
        if performValidation() && isUserExist() == false {
            debugPrint("This form is valid!")
            if let name: String = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text {
                
                let authenticationModel = AuthenticationModel(email: email, password: password)
                
                let userModel = UserModel(name: name, authentication: authenticationModel)
                
                userModel.writeUser()
                authenticationModel.didAuthSuccessful()
                
                if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerIdentifier") {
                    self.navigationController?.viewControllers = [homeViewController]
                }
                
            }
        }
    }
}
