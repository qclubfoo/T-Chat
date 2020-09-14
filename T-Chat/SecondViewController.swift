//
//  SecondViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 14.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var dismissButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func dismissTapped() {
        dismiss(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
