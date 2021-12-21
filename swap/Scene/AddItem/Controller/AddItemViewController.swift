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
    @IBOutlet weak var photosCountLabel: UILabel!
    @IBOutlet weak var categoryButton: UIButton!
    @IBOutlet weak var imageFolderView: UIView!
    
    var photosStored: [UIImage] = [UIImage]()
    var imagePicker: ImagePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = ImagePicker(presentationController: self, delegate: self)
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
        } else if photosStored.count == 0 {
            showAlert("Add photo to continue")
            return false
        }
        
        return true
    }
    
    private func showAlert(title: String? = "Error", _ message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
        vc.addAction(action)
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK: - Actions
    
    @IBAction private func publishButtonAction() {
        if performValidation() {
            if let title: String = titleTextField.text, let price = priceTextField.text, let priceValue = Int(price), let description = descriptionTextView.text, let category = categoryButton.title(for: .normal) {
                
                let itemModel = ItemModel(title: title, price: priceValue, category: category, description: description, email: AuthenticationModel.loggedInUserEmail ?? "")
                                
                itemModel.writeItem()
                self.navigationController?.popViewController(animated: false)
                showAlert(title: nil, "Successfully Published!")
            }
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
    
    @IBAction func addPhotosTapped(_ sender: UITapGestureRecognizer) {     
        
        guard photosStored.count != 3 else {
            showAlert("Maximum 3 images are allowed")
            return
        }
        
        self.imagePicker.present(from: imageFolderView)
    }
}

extension AddItemViewController: UITextViewDelegate {                        //this code is for discription
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if descriptionTextView.text == "Description" {
            descriptionTextView.text = ""
            descriptionTextView.textColor = .black
        }
        return true
    }
}

extension AddItemViewController: ImagePickerDelegate {                       //this is for image adding block
    func didSelect(image: UIImage?) {
        if let image = image {
            photosStored.append(image)
            photosCountLabel.text = "Photos: \(photosStored.count)/3. Add a photo to continiue."
            
            
        }
    }
}
