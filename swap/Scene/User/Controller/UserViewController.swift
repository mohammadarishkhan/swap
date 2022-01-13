//
//  UserViewController.swift
//  swap
//
//  Created by Bigsur on 28/12/21.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var myItemsContainerView: UIView!
    @IBOutlet weak var swapItemsContainerView: UIView!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var segmentcontrol: UISegmentedControl!
    
    lazy var user: UserModel = getUser()!
    var photoStored: UIImage?
    var imagePicker: ImagePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItem = logoutBarButton
        
        nameLabel.text = user.name
        phoneLabel.text = "\(user.phone)"
        emailLabel.text = user.authentication.email
        if let imageName = user.imageName {
            let image =  ImageStore.retrieve(imageNamed: imageName)
            userImageButton.setImage(image, for: .normal)
        }
        imagePicker = ImagePicker(presentationController: self, delegate: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ItemsTableViewController {
            vc.delegate = self
            vc.titleLabelYValue = -17
            vc.priceLabelYValue = 17
            vc.selectedEmail = AuthenticationModel.loggedInUserEmail

        }
        super.prepare(for: segue, sender: sender)
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
    
    func getUser() -> UserModel? {
        let loggedInUserEmail = AuthenticationModel.loggedInUserEmail ?? ""
        if let users = UserModel.readUsers() {
            let filteredUsers = users.filter {
                $0.authentication.email.lowercased() == loggedInUserEmail.lowercased()
            }
            return filteredUsers.first
        }
        
        return nil
    }
    
    @IBAction func addPhotosTapped(_ sender: UITapGestureRecognizer) {
        
        self.imagePicker.present(from: userImageButton)
    }
    
    @IBAction func segmentedControlButtonClickAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            myItemsContainerView.isHidden = false
            swapItemsContainerView.isHidden = true
        }
        else if sender.selectedSegmentIndex == 1 {
            myItemsContainerView.isHidden = true
            swapItemsContainerView.isHidden = false
            
        }
        else if sender.selectedSegmentIndex == 2 {
            myItemsContainerView.isHidden = true
            swapItemsContainerView.isHidden = false
            
        }
    }
    
}

extension UserViewController: ImagePickerDelegate {                       //this is for image adding block
    func didSelect(image: UIImage?) {
        if let image = image {
            photoStored = image
            userImageButton.setImage(image, for: .normal)
            let name = UUID().uuidString
            debugPrint("UUID: " + name)
            do {
                try ImageStore.store(image: image, name: name)
                user.imageName = name
                user.updateUser()
            } catch {
                debugPrint("Unable to store image (\(error))")
            }
        }
    }
}

extension UserViewController: ItemsTableViewControllerProtocol {
    func getCellHeight() -> CGFloat {
        return 100
    }
    
    func didSelectItem(_ selectedItem: ItemModel?, indexPath: IndexPath) {}
}

