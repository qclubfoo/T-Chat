//
//  ConversationsListViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    let hardcodedOnlineList = getHardcodedOnlineConversationList()
    let hardcodedOfflineList = getHardcodedOfflineConversationList()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tinkoff Chat"

        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Online"
        } else {
            return "History"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return hardcodedOnlineList.count
        } else {
            return hardcodedOfflineList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ConversationCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.configure(with: hardcodedOnlineList[indexPath.row])
        } else {
            cell.configure(with: hardcodedOfflineList[indexPath.row])
        }
        return cell
    }
    
    
}

