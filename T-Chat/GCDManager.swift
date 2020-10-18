//
//  GCDManager.swift
//  T-Chat
//
//  Created by Дмитрий on 15.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

enum Result {
    case sucess
    case fail
}

struct StringData {
    var str: String = ""
    var result: Result = .sucess
    var errorDescription: String = ""
}

struct ImageData {
    var image: UIImage?
    var result: Result = .sucess
    var errorDescription: String = ""
}

struct ProfileInfo {
    var fullName: String = ""
    var aboutYouself: String = ""
    var profileImage: UIImage?
}


class GCDManager {
    
    func saveProfileInfo(fullName: String?, aboutYouself: String?, profileImage: UIImage?, completionHandler completion: @escaping (String)->()) {
        var errors = ""
        let savingGroup = DispatchGroup()
        
        if let fullName = fullName {
            savingGroup.enter()
            save(text: fullName, toFileWithName: "fullName") { result in
                if result == .fail {
                    errors += "Can't save full name\n"
                }
                savingGroup.leave()
            }
        }
        if let aboutYouself = aboutYouself {
            savingGroup.enter()
            save(text: aboutYouself, toFileWithName: "aboutYouself") { result in
                if result == .fail {
                    errors += "Can't save information about you\n"
                }
                savingGroup.leave()
            }
        }
        if let profileImage = profileImage {
            savingGroup.enter()
            save(image: profileImage, toFileWithName: "profileImage") { result in
                if result == .fail {
                    errors += "Can't save profile image\n"
                }
                savingGroup.leave()
            }
        }
        savingGroup.notify(queue: .main) {
            completion(errors)
        }
    }

    func save(text str: String, toFileWithName fileName: String, completionHandler completeion: @escaping (Result) -> ()) {
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        DispatchQueue.global(qos: .default).async {
            if let data = str.data(using: .utf16) {
                do {
                    try data.write(to: filePath)
                    completeion(.sucess)
                } catch {
                    print("Can't save file to \(filePath)")
                    completeion(.fail)
                }
            } else {
                completeion(.fail)
            }
        }
    }
    
    func save(image img: UIImage, toFileWithName fileName: String, with completeion: @escaping (Result) -> ()) {
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        DispatchQueue.global(qos: .default).async {
            if let data = img.pngData() {
                do {
                    try data.write(to: filePath)
                    completeion(.sucess)
                    print("saved")
                } catch {
                    print("Can't save file to \(filePath)")
                    completeion(.fail)
                }
            } else {
                print("Can't convert image to data")
                completeion(.fail)
            }
        }
    }
    
    func getProfileInfo(completionHandler completion: @escaping (ProfileInfo) -> ()) {
        var recievedFullName: String = ""
        var recievedAboutYouself: String = ""
        var recievedProfileImage: UIImage?
        
        let profileGroup = DispatchGroup()
        
        profileGroup.enter()
        getString(fromFileWithName: "fullName") { result in
            if result.result == .sucess {
                recievedFullName = result.str
            }
            profileGroup.leave()
        }
        profileGroup.enter()
        getString(fromFileWithName: "aboutYouself") { result in
            if result.result == .sucess {
                recievedAboutYouself = result.str
            }
            profileGroup.leave()
        }
        profileGroup.enter()
        getImage(fromFileWithName: "profileImage") { result in
            if result.result == .sucess {
                recievedProfileImage = result.image
            }
            profileGroup.leave()
        }

        profileGroup.notify(queue: DispatchQueue.main) {
            let profile = ProfileInfo(fullName: recievedFullName, aboutYouself: recievedAboutYouself, profileImage: recievedProfileImage)
            completion(profile)
        }
    }
    
    func getString(fromFileWithName fileName: String, completionHandler completion: @escaping (StringData) -> ()) {
        var resultData = StringData()
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        DispatchQueue.global(qos: .default).async {
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
    }
    
    func getImage(fromFileWithName fileName: String, completionHandler completion: @escaping (ImageData) -> ()) {
        var resultData = ImageData()
        let filePath = getDocumentDirectory().appendingPathComponent(fileName)
        DispatchQueue.global(qos: .default).async {
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
    }
    
    private func getDocumentDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
}
