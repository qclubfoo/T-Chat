//
//  OperationManager.swift
//  T-Chat
//
//  Created by Дмитрий on 20.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class OperationManager {
    
    func saveProfileInfo(fullName: String?, aboutYouself: String?, profileImage: UIImage?, completionHandler completion: @escaping (String)->()) {
        let queue = OperationQueue()
        var errors: String = ""
        
        if let name = fullName {
            queue.addOperation { [weak self] in
                self?.save(text: name, toFileWithName: "fullName") { result in
                    if result == .fail {
                        errors += "Couldn't save full name\n"
                    }
                }
            }
        }
        if let about = aboutYouself {
            queue.addOperation { [weak self] in
                self?.save(text: about, toFileWithName: "aboutYouself") { result in
                    if result == .fail {
                        errors += "Couldn't save full name\n"
                    }
                }
            }
        }
        if let image = profileImage {
            queue.addOperation { [weak self] in
                self?.save(image: image, toFileWithName: "profileImage") { result in
                    if result == .fail {
                        errors += "Couldn't save profile image\n"
                    }
                }
            }
        }
    
        queue.waitUntilAllOperationsAreFinished()
        completion(errors)
    }
    
    func save(text str: String, toFileWithName fileName: String, completion: (Result)->()) {
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        if let data = str.data(using: .utf16) {
            do {
                try data.write(to: filePath)
                completion(.success)
            } catch {
                print("Can't save file to \(filePath)")
                completion(.fail)
            }
        } else {
            completion(.fail)
        }
    }
    
    func save(image: UIImage, toFileWithName fileName: String, completion: (Result)->()) {
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        if let data = image.pngData() {
            do {
                try data.write(to: filePath)
                completion(.success)
            } catch {
                completion(.fail)
            }
        } else {
            completion(.fail)
        }
    }
    
    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
}
