//
//  MessageCell.swift
//  T-Chat
//
//  Created by Дмитрий on 29.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class IncomingMessageCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
}

extension IncomingMessageCell: ConfigurableView {

    typealias ConfigurationModel = Message
    
    func configure(with model: ConfigurationModel) {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = Theme.current.textColor
        messageLabel.text = "\(model.senderName):\n\(model.content)"
        
        containerView.backgroundColor = Theme.current.incomingMessageColor
        containerView.layer.cornerRadius = 12
        containerView.layer.borderColor = Theme.current.messageBorderColor
        containerView.layer.borderWidth = 1
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 3),
            containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -3),
            containerView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.75),
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10)
        ])
    }
}
