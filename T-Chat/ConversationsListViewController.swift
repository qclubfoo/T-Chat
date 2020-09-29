//
//  ConversationsListViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class ConversationsListViewController: UITableViewController {
    
    let hardcodedConversationList: [[ConversationCellModel]] = [getHardcodedOnlineConversationList(), getHardcodedOfflineConversationList()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Tinkoff Chat"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(showProfile))

        
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
        return hardcodedConversationList[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ConversationCell else { return UITableViewCell() }
        cell.configure(with: hardcodedConversationList[indexPath.section][indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversationVC = ConversationViewController.storyboardInstance() else { return }
        var conversation = [MessageCellModel]()
        let ccm = hardcodedConversationList[indexPath.section][indexPath.row]
        if ccm.message != "" {
            conversation = getHardcodedConversationData()
            conversation.append(MessageCellModel(text: ccm.message, isIncomingMessage: true))
        }
        conversationVC.conversation = conversation
        conversationVC.title = ccm.name
        navigationController?.pushViewController(conversationVC, animated: true)
    }
}

extension ConversationsListViewController {
    @objc func showProfile() {
        guard let profileVC = ProfileViewController.storyboardInstance() else { return }
        profileVC.title = "Your profil"
        present(profileVC, animated: true)
    }
}

