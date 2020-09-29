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

        backgroundColor = .white
        lastMessageLabel.font = .systemFont(ofSize: lastMessageLabel.font.pointSize)
    }
    
}

struct ConversationCellModel {
    let name: String
    let message: String
    let date: Date
    let isOnline: Bool
    let hasUnreadedMessages: Bool
}

extension ConversationCell: ConfigurableView {
    
    typealias ConfigurationModel = ConversationCellModel
    
    func configure(with model: ConversationCellModel) {
        
        nameLabel.text = model.name
        if model.message == "" {
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

            if calendar.isDateInYesterday(model.date) {
                dateFormatter.dateFormat = "dd MMM"

            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            dateLabel.text = dateFormatter.string(from: model.date)
        }
        if model.isOnline {
            self.backgroundColor = UIColor.yellow.withAlphaComponent(0.2)
        }
    }
}


