//
//  ThemesViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 05.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    @IBOutlet weak var classicThemeButton: UIButton!
    @IBOutlet weak var dayThemeButton: UIButton!
    @IBOutlet weak var nightThemeButton: UIButton!
    @IBOutlet var classicGestureOutlet: UITapGestureRecognizer!
    @IBOutlet var dayGestureOutlet: UITapGestureRecognizer!
    @IBOutlet var nightGestureOutlet: UITapGestureRecognizer!
    
    weak var delegate: ThemesPickerDelegate?
    var closure: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        view.backgroundColor = Theme.current.themeViewControllerBackgorundColor
        
        let buttons: [UIButton] = [classicThemeButton, dayThemeButton, nightThemeButton]
        let gestures: [UIGestureRecognizer] = [classicGestureOutlet, dayGestureOutlet, nightGestureOutlet]
        setupButtons(buttons)
        setupGestures(gestures)
        selectButton(buttons[Theme.current.rawValue], in: buttons)
    }
    
    @objc func gestureRecogniserTapped(_ sender: UIGestureRecognizer) {
        if sender == classicGestureOutlet {
            themeButtonTapped(classicThemeButton)
        } else if sender == dayGestureOutlet {
            themeButtonTapped(dayThemeButton)
        } else {
            themeButtonTapped(nightThemeButton)
        }
    }
    
    @objc func themeButtonTapped(_ sender: UIButton) {
        if sender.isSelected { return }
        let buttons: [UIButton] = [classicThemeButton, dayThemeButton, nightThemeButton]
        selectButton(sender, in: buttons)
        if let theme = Theme(rawValue: getRawValue(for: sender)) {
            theme.setCurrent()
            view.backgroundColor = Theme.current.themeViewControllerBackgorundColor
            if let delegate = delegate {
                print("Applying theme with delegate")
                delegate.applyCurrentTheme()
            }
            if let closure = closure {
                print("Applying theme with closure")
                closure()
            }
        }
    }
    
    private func selectButton(_ button: UIButton, in buttons: [UIButton]) {
        for btn in buttons {
            if btn == button {
                btn.isSelected = true
                btn.layer.borderColor = UIColor.systemBlue.cgColor
                btn.layer.borderWidth = 3
            } else {
                btn.isSelected = false
                btn.layer.borderColor = UIColor.gray.cgColor
                btn.layer.borderWidth = 1
            }
        }
    }
    
    private func getRawValue(for button: UIButton) -> Int {
        if button == classicThemeButton {
            return 0
        } else if button == dayThemeButton {
            return 1
        } else {
            return 2
        }
    }
    
    private func setupButtons(_ buttons: [UIButton]) {
        for button in buttons {
            button.addTarget(self, action: #selector(themeButtonTapped(_:)), for: .touchUpInside)
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }
    }
    
    private func setupGestures(_ gestures: [UIGestureRecognizer]) {
        for gesture in gestures {
            gesture.addTarget(self, action: #selector(gestureRecogniserTapped(_:)))
        }
    }
    
    static func storyboardInstance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ThemesViewController
    }

}
