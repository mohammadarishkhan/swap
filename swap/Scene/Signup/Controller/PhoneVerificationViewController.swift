//
//  PhoneVerificationViewController.swift
//  swap
//
//  Created by Arish Khan on 07/04/22.
//

import UIKit
import FirebaseCore
import FirebaseAuth

protocol PhoneVerificationProtocol: AnyObject {
    func didOTPVerified()
}

class PhoneVerificationViewController: UIViewController {
    
    @IBOutlet weak var codeTextField: UITextField!
    
    weak var delegate: PhoneVerificationProtocol?
    var phoneNumber: String?
    var verificationID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSMSAuth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)     //for hidding navigation bar in signup screen
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        guard let verificationID = verificationID else { return }
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: codeTextField.text ?? "")
        
        Auth.auth().signIn(with: credential) { result, error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "Unknown Error")
                self.showAlert("The SMS verification code is invalid. Please resend the verification code SMS and be sure to use the verification code provided by the user.")
                return
            }
            
            debugPrint("AUTHENTICATION SUCCESS: " + (result?.user.phoneNumber ?? "NIL"))
            self.delegate?.didOTPVerified()
        }
    }
}

private extension PhoneVerificationViewController {
    func performSMSAuth() {
        guard let phoneNumber = phoneNumber else { return }
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        PhoneAuthProvider.provider().verifyPhoneNumber("+91" + phoneNumber, uiDelegate: nil) { verificationID, error in
            guard error == nil else {
                debugPrint(error?.localizedDescription ?? "Unknown Error")
                self.showAlert(error?.localizedDescription ?? "Invalid Phone number")
                return
            }
            
            self.verificationID = verificationID
            debugPrint(verificationID ?? "NIL")
        }
    }
}
