//
//  MessageCell.swift
//  T-Chat
//
//  Created by Дмитрий on 29.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
}

extension MessageCell: ConfigurableView {

    typealias ConfigurationModel = MessageCellModel
    
    func configure(with model: MessageCellModel) {
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .white
        messageLabel.text = model.text
        
        messageLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 3).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3).isActive = true
        messageLabel.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor, multiplier: 0.75).isActive = true
        if model.isIncomingMessage {
            messageLabel.backgroundColor = .systemGreen
            messageLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        } else {
            messageLabel.backgroundColor = .systemBlue
            messageLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        }
    }
}
