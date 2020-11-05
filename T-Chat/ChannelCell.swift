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
    
    @IBOutlet weak var channelLastActivityLabel: UILabel!
    
    @IBOutlet weak var channelLastMessageLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()

        backgroundColor = Theme.current.backgroundColor
        channelLastMessageLabel.textColor = Theme.current.textColor
        channelLastActivityLabel.textColor = Theme.current.textColor
        channelNameLabel.textColor = Theme.current.textColor
        
        channelLastMessageLabel.font = .systemFont(ofSize: channelLastMessageLabel.font.pointSize)
    }
    
}

extension ChannelCell: ConfigurableView {
    
    typealias ConfigurationModel = Channel_db
    
    func configure(with model: ConfigurationModel) {
        
        channelNameLabel.text = model.name
        channelLastMessageLabel.text = model.lastMessage
        if let date = model.lastActivity {
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            
            if !calendar.isDateInToday(date) {
                dateFormatter.dateFormat = "dd MMM"
            } else {
                dateFormatter.dateFormat = "HH:mm"
            }
            channelLastActivityLabel.text = dateFormatter.string(from: date)
        } else {
            channelLastActivityLabel.text = ""
        }
    }
}
