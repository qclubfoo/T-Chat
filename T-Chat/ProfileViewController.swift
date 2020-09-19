//
//  ProfileViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 18.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelContainerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    @IBOutlet weak var describingYouselfLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        
        profileImageView.isHidden = true
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        nameLabel.text = getNameLabelLetters()
        
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameLabelContainerView.layer.cornerRadius = nameLabelContainerView.bounds.height / 2
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        saveButton.layer.cornerRadius = saveButton.bounds.height / 4
    }
    
    @objc func editButtonTapped() {
        let ac = UIAlertController(title: "Edit profile", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Choose profile photo from galery", style: .default) { [weak self] _ in
            self?.getImage(fromSourceType: .photoLibrary)
        })
        ac.addAction(UIAlertAction(title: "Take profile photo by camera", style: .default) { [weak self] _ in
            self?.getImage(fromSourceType: .camera)
        })
        ac.addAction(UIAlertAction(title: "Edit name and surname", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "New name and/or surname", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: { textField in
                textField.placeholder = "name (space) surname"
                
            })
            ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                let maxTextLength = 31
                guard let str = ac.textFields?.first?.text else { return }
                self?.nameAndSurnameLabel.text = self?.cutString(str, withMaxLength: maxTextLength)
                self?.nameLabel.text = self?.getNameLabelLetters()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Edit self describing", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Describing youself", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: { textField in
                textField.placeholder = "Describe youself here"
            })
            ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                let maxTextLength = 120
                guard let str = ac.textFields?.first?.text else { return }
                self?.describingYouselfLabel.text = self?.cutString(str, withMaxLength: maxTextLength)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func cutString(_ str: String, withMaxLength len: Int) -> String {
        if str.count > len {
            return String(str[..<str.index(str.startIndex, offsetBy: len)])
        }
        return str
    }
    
    func getNameLabelLetters() -> String {
        guard let strs = nameAndSurnameLabel.text?.components(separatedBy: " ") else { return "" }
        var finalStr: String = ""
        for word in strs {
            if let char = word.first {
                finalStr.append(char)
            }
            if finalStr.count == 2 {
                break
            }
        }
        return finalStr.uppercased()
    }
    
    
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ProfileViewController
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        self.dismiss(animated: true) { [weak self] in
            
            guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
            self?.profileImageView.image = image
            self?.profileImageView.isHidden = false
            self?.nameLabel.isHidden = true
        }
    }
    
}
