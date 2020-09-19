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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor(red: 0.965, green: 0.965, blue: 0.965, alpha: 1)
        
        profileImageView.isHidden = true
        
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)

    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nameLabelContainerView.layer.cornerRadius = nameLabelContainerView.bounds.height / 2
        profileImageView.layer.cornerRadius = profileImageView.bounds.height / 2
        saveButton.layer.cornerRadius = saveButton.bounds.height / 4
    }
    
    @objc func editButtonTapped() {
        let ac = UIAlertController(title: "Set profile photo", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Choose from galery", style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "Take photo", style: .default, handler: nil))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    
    static func storyboardInstance() -> ProfileViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ProfileViewController
    }
}
