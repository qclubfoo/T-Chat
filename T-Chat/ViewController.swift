//
//  ViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 13.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var NextVCButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NextVCButton.addTarget(self, action: #selector(showSecondVC), for: .touchUpInside)
        
        print("View было загружено из памяти\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("View сейчас появится на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("View появилась на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("View сейчас будет отстраивать свои subviews на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("View отстроила свои subviews на экране\nбыла вызвана функция \(#function)\n")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("View сейчас исчезнет с экрана\nбыла вызвана функция \(#function)\n")
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("View исчезла с экрана\nбыла вызвана функция \(#function)\n")
    }
    
    // функция для перехода в другой контроллер. Нужна для отработки методово viewWillDisappear и viewDidDisappear
    @objc func showSecondVC() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "SecondVC") else { return }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }

}

