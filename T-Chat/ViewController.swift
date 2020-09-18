//
//  ViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 13.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var profileVCButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileVCButton.addTarget(self, action: #selector(showSecondVC), for: .touchUpInside)
        
        logMessage(message: "View было загружено из памяти\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logMessage(message: "View сейчас появится на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logMessage(message: "View появилась на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        logMessage(message: "View сейчас будет отстраивать свои subviews на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        logMessage(message: "View отстроила свои subviews на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        logMessage(message: "View сейчас исчезнет с экрана\nбыла вызвана функция \(#function)\n")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        logMessage(message: "View исчезла с экрана\nбыла вызвана функция \(#function)\n")
    }
    
    // функция для перехода в другой контроллер. Нужна для отработки методово viewWillDisappear и viewDidDisappear
    @objc func showSecondVC() {

        guard let profileVC = ProfileViewController.storyboardInstance() else { return }
        profileVC.modalPresentationStyle = .fullScreen
        present(profileVC, animated: true)
    }

}

