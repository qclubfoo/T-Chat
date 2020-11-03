//
//  Multithreading managers structs.swift
//  T-Chat
//
//  Created by Дмитрий on 20.10.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

enum Result {
    case success
    case fail
}

struct StringData {
    var str: String = ""
    var result: Result = .success
    var errorDescription: String = ""
}

struct ImageData {
    var image: UIImage?
    var result: Result = .success
    var errorDescription: String = ""
}

struct ProfileInfo {
    var fullName: String = ""
    var aboutYouself: String = ""
    var profileImage: UIImage?
}
