//
//  AddItemViewController.swift
//  swap
//
//  Created by Zoeb Husain Sheikh on 04/10/21.
//

import UIKit

class AddItemViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Validation
    private func performValidation() -> Bool {
        
        if titleTextField.text == "" {
            showAlert("Enter a title to continiue")
            return false
        } else if priceTextField.text == "" {
            showAlert("Enter a price to continiue")
            return false
        } else if categoryButton.title(for: UIControl.State.normal) == "Category" {
            showAlert("Select Category to continiue")
            return false
        }
        
        return true
    }
    
    private func showAlert(_ message: String) {
        let vc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction private func publishButtonAction() {
        if performValidation() {
            debugPrint("SUCCESSFULLY PUBLISHED")
            
        }
    }
    
    @IBAction private func categoryButtonAction() {
        self.categoryButton.setTitleColor(.black, for: .normal)
        let vc = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        let action = UIAlertAction(title: "Electronics", style: .default) {_ in
            self.categoryButton.setTitle("Electronics", for: UIControl.State.normal)
        }
        let action1 = UIAlertAction(title: "Fashion", style: .default) {_ in
            self.categoryButton.setTitle("Fashion", for: UIControl.State.normal)
        }
        let action2 = UIAlertAction(title: "Furniture", style: .default) {_ in
            self.categoryButton.setTitle("Furniture", for: UIControl.State.normal)
        }
        let action3 = UIAlertAction(title: "Home Appliances", style: .default) {_ in
            self.categoryButton.setTitle("Home Appliances", for: UIControl.State.normal)
        }
        let action4 = UIAlertAction(title: "Toys & Games", style: .default) {_ in
            self.categoryButton.setTitle("Toys & Games", for: UIControl.State.normal)
        }
        let action5 = UIAlertAction(title: "Others", style: .default) {_ in
            self.categoryButton.setTitle("Others", for: UIControl.State.normal)
        }
        vc.addAction(action)
        vc.addAction(action1)
        vc.addAction(action2)
        vc.addAction(action3)
        vc.addAction(action4)
        vc.addAction(action5)
        
        self.present(vc, animated: true, completion: nil)
    }
   

}

extension AddItemViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if descriptionTextView.text == "Description" {
            descriptionTextView.text = ""
            descriptionTextView.textColor = .black
        }
        return true
    }
}
