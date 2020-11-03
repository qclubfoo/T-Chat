//
//  exampleView.swift
//  T-Chat
//
//  Created by Дмитрий on 12.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class exampleView: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textFieldOne: UITextField!
    @IBOutlet weak var textFieldTwo: UITextField!
    @IBOutlet weak var editSaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textFieldOne.text = "This is textfield one"
        textFieldTwo.text = "This is textfield two"
        
        textFieldOne.delegate = self
        textFieldTwo.delegate = self
        
        editSaveButton.setTitle("Edit", for: .normal)
        editSaveButton.addTarget(self, action: #selector(editOrSaveAction(_:)), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc private func editOrSaveAction(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        if title == "Edit" {
            sender.setTitle("Save", for: .normal)
            textFieldOne.isUserInteractionEnabled = true
            textFieldTwo.isUserInteractionEnabled = true
            textFieldOne.becomeFirstResponder()
        } else {
            sender.setTitle("Edit", for: .normal)
            textFieldOne.isUserInteractionEnabled = false
            textFieldTwo.isUserInteractionEnabled = false
            resignFirstResponder()
            saveDataToFile()
        }
    }
    
    func saveDataToFile() {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let tfoURL = URL(fileURLWithPath: "FirstTF", relativeTo: documentDirectory)
        
        let savedText = textFieldOne.text ?? ""
        let ac = UIAlertController(title: "Saving result", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        if let data = savedText.data(using: .utf8) {
            do {
                try data.write(to: tfoURL)
                ac.message = "File saved succesfuly"
                
            } catch {
                ac.message = "Something goes wrong! Can't save data"
            }
        }
        present(ac, animated: true)
        
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textFieldOne:
            textFieldTwo.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
    

    

}
