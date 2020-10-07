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
    
    var delegate: ThemesPickerDelegate?
    var closure: (() -> ())?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        
        view.backgroundColor = Theme.current.themeViewControllerBackgorundColor
        
        let buttons: [UIButton] = [classicThemeButton, dayThemeButton, nightThemeButton]
        
        setupButtons(buttons)
        selectButton(buttons[Theme.current.rawValue])
        
        classicThemeButton.addTarget(self, action: #selector(classicThemeTapped), for: .touchUpInside)
        classicGestureOutlet.addTarget(self, action: #selector(classicThemeTapped))
        dayThemeButton.addTarget(self, action: #selector(dayThemeTapped), for: .touchUpInside)
        dayGestureOutlet.addTarget(self, action: #selector(dayThemeTapped))
        nightThemeButton.addTarget(self, action: #selector(nightThemeTapped), for: .touchUpInside)
        nightGestureOutlet.addTarget(self, action: #selector(nightThemeTapped))
        
    }
    
    @objc func classicThemeTapped() {
        if !classicThemeButton.isSelected {
            selectButton(classicThemeButton)
            deselectButtons([dayThemeButton, nightThemeButton])
            if let theme = Theme(rawValue: 0) {
                theme.setCurrent()
                view.backgroundColor = Theme.current.themeViewControllerBackgorundColor
                delegate?.applyCurrentTheme()
            }
        }
        print("classic tapped")
        if let closure = closure {
            closure()
        }
    }
    
    @objc func dayThemeTapped() {
        if !dayThemeButton.isSelected {
            selectButton(dayThemeButton)
            deselectButtons([classicThemeButton, nightThemeButton])
        }
        if let theme = Theme(rawValue: 1) {
            theme.setCurrent()
            view.backgroundColor = Theme.current.themeViewControllerBackgorundColor
            delegate?.applyCurrentTheme()
        }
        print("day tapped")
    }
    
    @objc func nightThemeTapped() {
        if !nightThemeButton.isSelected {
            selectButton(nightThemeButton)
            deselectButtons([classicThemeButton, dayThemeButton])
        }
        if let theme = Theme(rawValue: 2) {
            theme.setCurrent()
            view.backgroundColor = Theme.current.themeViewControllerBackgorundColor
            delegate?.applyCurrentTheme()
        }
        
        print("night tapped")
    }
    
    private func selectButton(_ button: UIButton) {
        button.isSelected = true
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 3
    }
    
    private func deselectButtons(_ buttons: [UIButton]) {
        for button in buttons {
            button.isSelected = false
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1
        }
    }
    
    private func setupButtons(_ buttons: [UIButton]) {
        for button in buttons {
            button.layer.borderColor = UIColor.gray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
        }
    }
    
    static func storyboardInstance() -> ThemesViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ThemesViewController
    }

}
