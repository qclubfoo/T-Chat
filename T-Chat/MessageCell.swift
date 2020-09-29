//
//  MessageCell.swift
//  T-Chat
//
//  Created by Дмитрий on 29.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
}

extension MessageCell: ConfigurableView {

    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .black
        messageLabel.text = model.text
        
        containerView.layer.cornerRadius = 12
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 3).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3).isActive = true
        containerView.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor, multiplier: 0.75).isActive = true
        if model.isIncomingMessage {
            containerView.backgroundColor = UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        } else {
            containerView.backgroundColor = UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        }
    }
}
