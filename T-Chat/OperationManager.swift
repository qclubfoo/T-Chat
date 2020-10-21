//
//  OperationManager.swift
//  T-Chat
//
//  Created by Дмитрий on 20.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

class OperationManager {
    
    func saveProfileInfo(fullName: String?, aboutYouself: String?, profileImage: UIImage?, completionHandler completion: @escaping (String) -> Void) {
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
    
    func getProfileInfo(completionHandler completion: @escaping (ProfileInfo) -> Void) {
        var recievedFullName: String = ""
        var recievedAboutYouself: String = ""
        var recievedProfileImage: UIImage?
        
        let profileInfoQueue = OperationQueue()
        
        profileInfoQueue.addOperation { [weak self] in
            self?.getString(fromFileWithName: "fullName") { result in
                if result.result == .success {
                    recievedFullName = result.str
                }
            }
        }
        profileInfoQueue.addOperation { [weak self] in
            self?.getString(fromFileWithName: "aboutYouself") { result in
                if result.result == .success {
                    recievedAboutYouself = result.str
                }
            }
        }
        profileInfoQueue.addOperation { [weak self] in
            self?.getImage(fromFileWithName: "profileImage") { result in
                if result.result == .success {
                    recievedProfileImage = result.image
                }
            }
        }
        
        profileInfoQueue.waitUntilAllOperationsAreFinished()
        profileInfoQueue.addOperation {
            let profile = ProfileInfo(fullName: recievedFullName, aboutYouself: recievedAboutYouself, profileImage: recievedProfileImage)
            OperationQueue.main.addOperation {
                completion(profile)
            }
        }
        
    }
    
    private func save(text str: String, toFileWithName fileName: String, completion: (Result) -> Void) {
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
    
    private func save(image: UIImage, toFileWithName fileName: String, completion: (Result) -> Void) {
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
    
    private func getString(fromFileWithName fileName: String, completionHandler completion: @escaping (StringData) -> Void) {
        var resultData = StringData()
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: filePath)
            if let savedString = String(data: data, encoding: .utf16) {
                resultData.str = savedString
                completion(resultData)
            }
        } catch {
            print(error.localizedDescription)
            resultData.result = .fail
            resultData.errorDescription = "Can't load data from file with name \(fileName)"
            completion(resultData)
        }
    }
    
    private func getImage(fromFileWithName fileName: String, completionHandler completion: @escaping (ImageData) -> Void) {
        var resultData = ImageData()
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        do {
            let data = try Data(contentsOf: filePath)
            if let savedImage = UIImage(data: data) {
                resultData.image = savedImage
                completion(resultData)
            }
        } catch {
            print(error.localizedDescription)
            resultData.result = .fail
            resultData.errorDescription = "Can't load data from file with name \(fileName)"
            completion(resultData)
        }
    }

    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
}
