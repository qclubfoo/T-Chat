//
//  ConfigurationModel.swift
//  T-Chat
//
//  Created by Дмитрий on 25.09.2020.
//  Copyright © 2020 DP. All rights reserved.
//

import UIKit

 protocol ConfigurableView {
     associatedtype ConfigurationModel
     
     func configure(with model: ConfigurationModel)
 }
