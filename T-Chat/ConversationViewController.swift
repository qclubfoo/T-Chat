//
//  ConversationViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 29.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit
import Firebase

class ConversationViewController: UITableViewController {
    
    var conversation = [Message]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                if let rowIndex = self?.conversation.count {
                    if rowIndex > 0 {
                        self?.tableView.scrollToRow(at: IndexPath(row: rowIndex - 1, section: 0), at: .bottom, animated: false)
                    }
                }
                
            }
        }
    }
    var userName: String?
    var reference: CollectionReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.reference?.addSnapshotListener { [weak self] snapshot, _ in
                if let documents = snapshot?.documents {
                    var messages = [Message]()
                    for document in documents {
                        let documentData = document.data()
                        guard let content = documentData["content"] as? String,
                            let created = documentData["created"] as? Timestamp,
                            let senderId = documentData["senderId"] as? String,
                            let senderName = documentData["senderName"] as? String
                            else { continue }
                        messages.append(Message(content: content, created: created.dateValue(), senderId: senderId, senderName: senderName))
                    }
                    messages.sort { first, second in
                        if first.created < second.created {
                            return true
                        }
                        return false
                    }
                    self?.conversation = messages
                }
            }
        }
        view.backgroundColor = Theme.current.backgroundColor
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewMessage))
    }
    
    @objc func addNewMessage() {
        let ac = UIAlertController(title: "New message", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Type your message here"
            textField.becomeFirstResponder()
        }
        ac.addAction(UIAlertAction(title: "Send", style: .default) { [weak self] _ in
            guard let text = ac.textFields?.first?.text else { return }
            if text.isEmpty {
                return
            }
            self?.sendMessage(text: text)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func sendMessage(text: String) {
        guard let senderID = UIDevice.current.identifierForVendor?.uuidString else { return }
        let senderName = userName ?? "Dmitrii"
        let timeStamp = Timestamp(date: Date())
        
        reference?.addDocument(data: ["content": text,
                                      "created": timeStamp,
                                      "senderId": senderID,
                                      "senderName": senderName])
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentMessage = conversation[indexPath.row]
        guard let userId = UIDevice.current.identifierForVendor?.uuidString else { return UITableViewCell() }
        if currentMessage.senderId == userId {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OutgoingMessageCell", for: indexPath) as? OutgoingMessageCell else { return UITableViewCell() }
            cell.configure(with: currentMessage)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IncomingMessageCell", for: indexPath) as? IncomingMessageCell else { return UITableViewCell() }
            cell.configure(with: currentMessage)
            return cell
        }
    }
}

extension ConversationViewController {
    static func storyboardInstance() -> ConversationViewController? {
        let storyboard = UIStoryboard(name: String(describing: self), bundle: nil)
        return storyboard.instantiateInitialViewController() as? ConversationViewController
    }
}
