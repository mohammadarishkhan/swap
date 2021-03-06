//
//  SignupViewController.swift
//  swap
//
//  Created by Mohammad Arish Khan on 24/09/21.
//

import UIKit

class SignupViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)     //for hidding navigation bar in signup screen
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? PhoneVerificationViewController {
            vc.delegate = self
            vc.phoneNumber = phoneTextField.text
        }
    }
    
    func showLoginVC() {
        performSegue(withIdentifier: "LoginViewControllerIdentifier", sender: self)
    }
    
    //MARK: - Validation
    func performValidation() -> Bool {
        
        if nameTextField.text!.count < 4 {
            showAlert("Name should be 4 or more characters")
            return false
        } else if phoneTextField.text!.count != 10 {
            showAlert("Enter 10 digit phone number")
            return false
        } else if isValidEmail(emailTextField.text ?? "") == false {
            showAlert("Write Valid Email")
            return false
        } else if passwordTextField.text!.count < 6 {
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
            performSegue(withIdentifier: "PhoneVerificationViewControllerIdentifier", sender: self)
        }
    }
}

extension SignupViewController: PhoneVerificationProtocol {
    func didOTPVerified() {
        if let name: String = nameTextField.text, let phone: String = phoneTextField.text, let phoneNumber =  Int(phone), let email = emailTextField.text, let password = passwordTextField.text {
            
            let authenticationModel = AuthenticationModel(email: email, password: password)
            
            let userModel = UserModel(name: name, phone: phoneNumber, authentication: authenticationModel)
            
            userModel.writeUser()
            authenticationModel.didAuthSuccessful()
            
            if let homeViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewControllerIdentifier")
            {
                self.navigationController?.viewControllers = [homeViewController]
            }
            
        }
    }
}
