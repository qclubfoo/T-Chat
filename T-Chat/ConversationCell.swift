//
//  ConversationCell.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var lastMessageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = Theme.current.backgroundColor
        lastMessageLabel.textColor = Theme.current.textColor
        dateLabel.textColor = Theme.current.textColor
        nameLabel.textColor = Theme.current.textColor
        
        lastMessageLabel.font = .systemFont(ofSize: lastMessageLabel.font.pointSize)
    }
    
}

extension ConversationCell: ConfigurableView {
    
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with model: ConversationCellModel) {
        
        nameLabel.text = model.name
        if model.message.isEmpty {
            dateLabel.isHidden = true
            lastMessageLabel.text = "No messages yet"
            lastMessageLabel.font = UIFont(name: "Bradley hand", size: lastMessageLabel.font.pointSize)
        } else {
            if model.hasUnreadedMessages {
                lastMessageLabel.font = UIFont.systemFont(ofSize: lastMessageLabel.font.pointSize, weight: .bold)
            }
            lastMessageLabel.text = model.message
            
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current

            if !calendar.isDateInToday(model.date) {
                dateFormatter.dateFormat = "dd MMM"

            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            dateLabel.text = dateFormatter.string(from: model.date)
            dateLabel.isHidden = false
        }
        if model.isOnline {
            self.backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 93 / 255, alpha: 1)
            self.lastMessageLabel.textColor = .black
            self.dateLabel.textColor = .black
            self.nameLabel.textColor = .black
        }
    }
}
