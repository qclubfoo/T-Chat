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

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelContainerView: UIView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameAndSurnameLabel: UILabel!
    @IBOutlet weak var youselfDescriptionLabel: UILabel!

    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
//        Задание 3.2
//        В данный момент нет ни view, ни outlets. Соответственно во всех outlets значение будет nil, но т.к. они раскрываются через force unwrap, то есть без проверки на nil, при обращении к outlet saveButton значение которой в данный момент nil, программа крашится.
//        print("ViewFrame is \(saveButton.frame)")

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Задание 3.3
        print("In \(#function)\nSave button frame is \(saveButton.frame)\n")
        
        saveButton.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        
        profileImageView.isHidden = true
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

        nameLabel.text = getNameLabelLetters()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        Задание 3.4
//        Frame в данном методе отличен от frame в методе viewDidLoad() т.к. в методе viewDidLoad() все размеры берутся из storyboard, а после метода viewDidLoad() выстраиваются constraints в методах viewWillLayoutSubviews() и viewDidLayoutSubviews(), то есть изменяются размеры view, а только потом, с уже полностью актуальными размерами, view появляется на экране. Когда отрабатывает метод viewDidAppear(_:animated), нам поянто, что view уже уже на экране с актуальными размерами.
        print("In \(#function)\nSave button frame is \(saveButton.frame)\n")

    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        nameLabelContainerView.layer.cornerRadius = nameLabelContainerView.bounds.height / 2
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        saveButton.layer.cornerRadius = saveButton.bounds.height / 4
    }
    
    // Метод для обработки нажатия на кнопку edit. @objc нужен т.к. вызываемый метод в addTarget вызывается через #selector
    @objc func editButtonTapped() {
        // Инициализация actionSheet
        let ac = UIAlertController(title: "Edit profile", message: nil, preferredStyle: .actionSheet)
        
        // action для выбора фотографии из галереи
        ac.addAction(UIAlertAction(title: "Choose profile photo from galery", style: .default) { [weak self] _ in
            self?.getImage(fromSourceType: .photoLibrary)
        })
        
        // action для выбора фотографии с помощью камеры
        ac.addAction(UIAlertAction(title: "Take profile photo by camera", style: .default) { [weak self] _ in
            self?.getImage(fromSourceType: .camera)
        })
        
        // action для изменения имени и фамилии с помощью другого alert с textField
        ac.addAction(UIAlertAction(title: "Edit name and/or surname", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "New name and/or surname", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: { textField in
                textField.placeholder = "name (space) surname"
                
            })
            ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                guard let str = ac.textFields?.first?.text else { return }
                self?.nameAndSurnameLabel.text = str
                self?.nameLabel.text = self?.getNameLabelLetters()
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        })
        
        // action для изменения данных о себе с помощью другого alert с textField
        ac.addAction(UIAlertAction(title: "Edit self description", style: .default) { [weak self] _ in
            let ac = UIAlertController(title: "Youself description", message: nil, preferredStyle: .alert)
            ac.addTextField(configurationHandler: { textField in
                textField.placeholder = "Describe youself here"
            })
            ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self] _ in
                guard let str = ac.textFields?.first?.text else { return }
                self?.youselfDescriptionLabel.text = str
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self?.present(ac, animated: true)
        })
        
        // action для выхода без действий из actionSheet
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
//    Метод для получения инициалов из имени и фамилии
    private func getNameLabelLetters() -> String {
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
//    Метод для инициализации viewController с помощью имени сториборда. Имена контроллера и сториборда одинаковые для того, чтобы не использовать storyboardID для инициализации.
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ProfileViewController
    }
}

//Расширение для ProfileViewController чтобы получить доступ к галерее и камере устройства. В info.plist добавлены описания для чего нужен доступ к камере и галерее.
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        checkCameraAccess()
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
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            print("Denied, request permission from settings")
            presentCameraSettings()
        default:
            print("Access granted or can't be changed")
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
