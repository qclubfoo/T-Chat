//
//  ConversationsListViewController.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class ConversationsListViewController: UITableViewController {
    
    var frc: NSFetchedResultsController<Channel_db> = {
        let mainContext = AppDelegate.coreDataStack.mainContext
        let channelsFetchRequest = Channel_db.createFetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        channelsFetchRequest.sortDescriptors = [sortDescriptor]
        channelsFetchRequest.fetchBatchSize = 25
        let frc = NSFetchedResultsController(fetchRequest: channelsFetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }()
    lazy var db = Firestore.firestore()
    lazy var reference = db.collection("channels")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frc.delegate = self
        loadSavedData()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.reference.addSnapshotListener { snapshot, _ in
                if let changes = snapshot?.documentChanges {
                    AppDelegate.coreDataStack.performSave { context in
                        for change in changes {
                            let documentData = change.document.data()
                            let name = documentData["name"] as? String ?? ""
                            let id = change.document.documentID
                            let lastMessage = documentData["lastMessage"] as? String
                            let lastActivityTimeStamp = documentData["lastActivity"] as? Timestamp
                            let lastActivity = lastActivityTimeStamp?.dateValue()
                            _ = Channel_db(identifier: id,
                                           name: name,
                                           lastMessage: lastMessage,
                                           lastActivity: lastActivity,
                                           context: context)
                        }
                    }
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
    
    private func loadSavedData() {
        do {
            try frc.performFetch()
            tableView.reloadData()
        } catch {
            print("Can't fetch data")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Channels"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return frc.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = frc.sections?[section]
        return sectionInfo?.numberOfObjects ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ConversationCell", for: indexPath) as? ChannelCell else { return UITableViewCell() }
        let cellData = frc.object(at: indexPath)
        cell.configure(with: cellData)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let conversationVC = ConversationViewController.storyboardInstance() else { return }
        let pickedChannel = frc.object(at: indexPath)
        conversationVC.reference = db.collection("channels/\(pickedChannel.identifier)/messages")
        conversationVC.channelIdentifier = pickedChannel.identifier
        conversationVC.title = pickedChannel.name
        navigationController?.pushViewController(conversationVC, animated: true)
    }
    
}

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                guard let cell = tableView.cellForRow(at: indexPath) as? ChannelCell else { break }
                let channel = frc.object(at: indexPath)
                cell.configure(with: channel)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
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
