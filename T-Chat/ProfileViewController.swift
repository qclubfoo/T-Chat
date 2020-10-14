//
//  ProfileViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 18.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileViewController: UIViewController {
    
    lazy var activityIndicator = UIActivityIndicatorView()
    var currentFullName: String = ""
    var currentAboutYouself: String = ""

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var gcdSaveButton: UIButton!
    @IBOutlet weak var operationalSaveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelContainerView: UIView!
    @IBOutlet weak var avatarEditButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameAndSurnameTextField: UITextField!
    @IBOutlet weak var aboutYouselfTextView: UITextView!

    @IBAction func editProfileButtonTapped(_ sender: UIButton) {
        if sender.titleLabel?.text == "Edit" {
            currentFullName = nameAndSurnameTextField.text ?? ""
            currentAboutYouself = aboutYouselfTextView.text
            sender.setTitle("Cancel", for: .normal)
            editProfileOn()
        } else {
            sender.setTitle("Edit", for: .normal)
            editProfileOff()
            nameAndSurnameTextField.text = currentFullName
            aboutYouselfTextView.text = currentAboutYouself
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getProfileInfo()
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        nameAndSurnameTextField.delegate = self
        aboutYouselfTextView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        profileImageView.isHidden = true
        avatarEditButton.addTarget(self, action: #selector(avatarEditButtonTapped), for: .touchUpInside)
        nameLabel.text = getNameLabelLetters()
        aboutYouselfTextView.layer.cornerRadius = 5
        nameAndSurnameTextField.layer.cornerRadius = 5
        gcdSaveButton.addTarget(self, action: #selector(gcdButtonTapped), for: .touchUpInside)
        operationalSaveButton.addTarget(self, action: #selector(operationalButtonTapped), for: .touchUpInside)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        nameLabelContainerView.layer.cornerRadius = nameLabelContainerView.bounds.height / 2
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        gcdSaveButton.layer.cornerRadius = gcdSaveButton.bounds.height / 4
        operationalSaveButton.layer.cornerRadius = gcdSaveButton.bounds.height / 4
    }
    
    @objc func avatarEditButtonTapped() {
        let ac = UIAlertController(title: "Edit profile photo", message: nil, preferredStyle: .actionSheet)
        
        // action для выбора фотографии из галереи
        ac.addAction(UIAlertAction(title: "Choose profile photo from galery", style: .default) { [weak self] _ in
            self?.getImage(fromSourceType: .photoLibrary)
        })
        
        // action для выбора фотографии с помощью камеры
        ac.addAction(UIAlertAction(title: "Take profile photo by camera", style: .default) { [weak self] _ in
            self?.getImage(fromSourceType: .camera)
        })
        
        // action для выхода без действий из actionSheet
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
//    Метод для получения инициалов из имени и фамилии
    private func getNameLabelLetters() -> String {
        guard let strs = nameAndSurnameTextField.text?.components(separatedBy: " ") else { return "" }
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
    
//    Метод для инициализации viewController с помощью имени сториборда. Имена контроллера и сториборда одинаковые для того, чтобы не использовать storyboardID для инициализации.
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ProfileViewController
    }
    
    @objc func gcdButtonTapped() {
        editProfileOff()
        guard let fullName = nameAndSurnameTextField.text else { return }
        if fullName != currentFullName {
            saveStringData(nameAndSurnameTextField.text ?? "", withFileName: "fullName")
        }
        if aboutYouselfTextView.text != currentAboutYouself {
            saveStringData(aboutYouselfTextView.text, withFileName: "aboutYouSelf")
        }
        if let profilePhoto = profileImageView.image {
            saveImageData(profilePhoto)
        }
    }
    
    @objc func operationalButtonTapped() {
        editProfileOff()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
      self.view.frame.origin.y = 0 - keyboardSize.height
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      self.view.frame.origin.y = 0
    }
    
    func getProfileInfo() {
        let documentsDirectory = getDocumentsDirectory()
        let fullNamePath = documentsDirectory.appendingPathComponent("fullName").appendingPathExtension("txt")
        let aboutYouselfPath = documentsDirectory.appendingPathComponent("aboutYouSelf").appendingPathExtension("txt")
        let profilePhotoPath = documentsDirectory.appendingPathComponent("profilePhoto").appendingPathExtension("png")
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            do {
                let fullNameData = try Data(contentsOf: fullNamePath)
                if let fullName = String(data: fullNameData, encoding: .utf16) {
                    DispatchQueue.main.async { [weak self] in
                        self?.nameAndSurnameTextField.text = fullName
                        self?.nameLabel.text = self?.getNameLabelLetters()
                    }
                }
                let aboutYouselfData = try Data(contentsOf: aboutYouselfPath)
                if let aboutYouself = String(data: aboutYouselfData, encoding: .utf16) {
                    DispatchQueue.main.async { [weak self] in
                        self?.aboutYouselfTextView.text = aboutYouself
                    }
                }
                let profileImageData = try Data(contentsOf: profilePhotoPath)
                if let profilePhoto = UIImage(data: profileImageData) {
                    DispatchQueue.main.async { [weak self] in
                        self?.profileImageView.image = profilePhoto
                        self?.profileImageView.isHidden = false
                        self?.nameLabel.isHidden = true  
                    }
                }
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
            } catch {
                print("can't read data")
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    func saveStringData(_ text: String, withFileName name: String) {
        activityIndicator.startAnimating()
        let ac = getDefaultAlertController(withTitle: "Data was saved", andMessage: nil)
        let queue = DispatchQueue.global(qos: .default)
        let path = getDocumentsDirectory().appendingPathComponent(name).appendingPathExtension("txt")
        if let data = text.data(using: .utf16) {
            queue.async {
                do {
                    try data.write(to: path)
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                        self?.present(ac, animated: true)
                    }
                                    } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                        ac.title = "Error"
                        ac.message = "Couldn't save data"
                        ac.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { [weak self] _ in
                            self?.saveStringData(text, withFileName: name)
                        }))
                    }
                }
            }
        }
    }
    
    func saveImageData(_ image: UIImage) {
        activityIndicator.startAnimating()
        let ac = getDefaultAlertController(withTitle: "Data was saved", andMessage: nil)
        let queue = DispatchQueue.global(qos: .default)
        let path = getDocumentsDirectory().appendingPathComponent("profilePhoto").appendingPathExtension("png")
        if let data = image.pngData() {
            queue.async {
                do {
                    try data.write(to: path)
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                        self?.present(ac, animated: true)
                    }
                } catch {
                    DispatchQueue.main.async { [weak self] in
                        self?.activityIndicator.stopAnimating()
                        ac.title = "Error"
                        ac.message = "Couldn't save data"
                        ac.addAction(UIAlertAction(title: "Repeat", style: .default, handler: { [weak self] _ in
                            self?.saveImageData(image)
                        }))
                    }
                }
            }
        }
    }
    
    func getDefaultAlertController(withTitle title: String, andMessage message: String?) -> UIAlertController {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        return ac
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func editProfileOn() {
        nameAndSurnameTextField.isUserInteractionEnabled = true
        nameAndSurnameTextField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        aboutYouselfTextView.isEditable = true
        aboutYouselfTextView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        buttons(enable: [gcdSaveButton, operationalSaveButton, avatarEditButton])
    }
    
    private func editProfileOff() {
        nameAndSurnameTextField.isUserInteractionEnabled = false
        nameAndSurnameTextField.backgroundColor = .white
        aboutYouselfTextView.isEditable = false
        aboutYouselfTextView.backgroundColor = .white
        buttons(disable: [gcdSaveButton, operationalSaveButton, avatarEditButton])
        editButton.setTitle("Edit", for: .normal)
        resignFirstResponder()
    }
    
    private func buttons(enable buttons: [UIButton]) {
        for button in buttons {
            button.isEnabled = true
        }
    }
    
    private func buttons(disable buttons: [UIButton]) {
        for button in buttons {
            button.isEnabled = false
        }
    }
}

extension ProfileViewController: UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        aboutYouselfTextView.becomeFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}

//Расширение для ProfileViewController чтобы получить доступ к галерее и камере устройства. В info.plist добавлены описания для чего нужен доступ к камере и галерее.
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        checkCameraAccess()
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
    
    func checkCameraAccess() {
        if AVCaptureDevice.authorizationStatus(for: .video) == .denied {
            presentCameraSettings()
        }
    }
    
    func presentCameraSettings() {
        let ac = UIAlertController(title: "Error",
                                      message: "Camera access is denied",
                                      preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        ac.addAction(UIAlertAction(title: "Settings", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:])
            }
        })

        present(ac, animated: true)
    }

    
}
