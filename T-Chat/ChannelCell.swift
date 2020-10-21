//
//  ConversationCell.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {
    @IBOutlet weak var channelNameLabel: UILabel!
    
    @IBOutlet weak var channelLastMessageLabel: UILabel!
    
    @IBOutlet weak var channelLastActivity: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = Theme.current.backgroundColor
        channelLastActivity.textColor = Theme.current.textColor
        channelLastMessageLabel.textColor = Theme.current.textColor
        channelNameLabel.textColor = Theme.current.textColor
        
        channelLastActivity.font = .systemFont(ofSize: channelLastActivity.font.pointSize)
    }
    
}

extension ChannelCell: ConfigurableView {
    
    typealias ConfigurationModel = Channel
    
    func configure(with model: ConfigurationModel) {
        
        channelNameLabel.text = model.name
        channelLastActivity.text = model.lastMessage
        if let date = model.lastActivity {
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            
            if !calendar.isDateInToday(date) {
                dateFormatter.dateFormat = "dd MMM"
            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            channelLastMessageLabel.text = dateFormatter.string(from: date)
        }
        
//        channelNameLabel.text = model.name
//        if model.message.isEmpty {
//            lastMessagedateLabel.isHidden = true
//            lastMessageLabel.text = "No messages yet"
//            lastMessageLabel.font = UIFont(name: "Bradley hand", size: lastMessageLabel.font.pointSize)
//        } else {
//            if model.hasUnreadedMessages {
//                lastMessageLabel.font = UIFont.systemFont(ofSize: lastMessageLabel.font.pointSize, weight: .bold)
//            }
//            lastMessageLabel.text = model.message
//
//            let dateFormatter = DateFormatter()
//            let calendar = Calendar.current
//
//            if !calendar.isDateInToday(model.date) {
//                dateFormatter.dateFormat = "dd MMM"
//
//            } else {
//                dateFormatter.dateFormat = "HH:mm"
//            }
//            lastMessagedateLabel.text = dateFormatter.string(from: model.date)
//            lastMessagedateLabel.isHidden = false
//        }
//        if model.isOnline {
//            self.backgroundColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 93 / 255, alpha: 1)
//            self.lastMessageLabel.textColor = .black
//            self.lastMessagedateLabel.textColor = .black
//            self.channelNameLabel.textColor = .black
//        }
    }
}
