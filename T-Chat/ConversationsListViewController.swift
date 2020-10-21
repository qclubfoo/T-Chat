//
//  ConversationsListViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit
import Firebase

class ConversationsListViewController: UITableViewController {
    
    var channelsList = [Channel]() {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.reference.addSnapshotListener { [weak self] snapshot, _ in
                if let documents = snapshot?.documents {
                    var channels = [Channel]()
                    for document in documents {
                        let documentData = document.data()
                        guard let name = document.data()["name"] as? String else { continue }
                        let id = document.documentID
                        let lastMessage = documentData["lastMessage"] as? String
                        let lastActivityTimeStamp = documentData["lastActivity"] as? Timestamp
                        let lastActivity = lastActivityTimeStamp?.dateValue()
                        channels.append(Channel(identifier: id,
                                                name: name,
                                                lastMessage: lastMessage,
                                                lastActivity: lastActivity))
                    }
                    self?.channelsList = channels
                }
            }
        }
        
        applyCurrentTheme()
        
        title = "Tinkoff Chat"
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(showProfile)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newChannelButtonTapped))
        ]
        
        if #available(iOS 13.0, *) {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(showThemeVC))
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "downloadedGear"), style: .plain, target: self, action: #selector(showThemeVC))
        }
    }
    
    @objc func newChannelButtonTapped() {
        let ac = UIAlertController(title: "Add new channel", message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.placeholder = "Type channel name here"
            textField.becomeFirstResponder()
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default) { [weak self] _ in
            guard let name = ac.textFields?.first?.text else { return }
            if name.isEmpty {
                return
            }
            self?.addNewChannel(withName: name)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    private func addNewChannel(withName name: String) {
        reference.addDocument(data: ["name": name])
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Channels"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return channelsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ChannelCell else { return UITableViewCell() }
        cell.configure(with: channelsList[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversationVC = ConversationViewController.storyboardInstance() else { return }
        let pickedChannel = channelsList[indexPath.row]
        conversationVC.reference = db.collection("channels/\(pickedChannel.identifier)/messages")
        conversationVC.title = pickedChannel.name
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
}

extension ConversationsListViewController: ThemesPickerDelegate {
    func applyCurrentTheme() {
        UITableViewCell.appearance().backgroundColor = Theme.current.backgroundColor
        UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = Theme.current.textColor
        view.backgroundColor = Theme.current.backgroundColor
        tableView.reloadData()
    }
}

extension ConversationsListViewController {
    @objc func showThemeVC() {
        guard let themesVC = ThemesViewController.storyboardInstance() else { return }
        //        themesVC.delegate = self
        // use line above the comment for using delegate instead of closure. Make sure you comment line under.
        themesVC.closure = getClosure()
        navigationController?.pushViewController(themesVC, animated: true)
    }
    
    private func getClosure() -> () -> Void {
        return { [weak self] in
            UITableViewCell.appearance().backgroundColor = Theme.current.backgroundColor
            UILabel.appearance(whenContainedInInstancesOf: [UITableViewCell.self]).textColor = Theme.current.textColor
            self?.view.backgroundColor = Theme.current.backgroundColor
            self?.tableView.reloadData()
        }
    }
}

extension ConversationsListViewController {
    @objc func showProfile() {
        guard let profileVC = ProfileViewController.storyboardInstance() else { return }
        present(profileVC, animated: true)
    }
}
