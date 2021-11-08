//
//  Cache.swift
//  AfyaChallenge
//
//  Created by Neylor Bagagi on 04/10/21.
//  Copyright © 2021 Cyanu. All rights reserved.
//

import Foundation
import UIKit

/// That is only a Session Cache to provide a better experience
class Cache {
    
    static let share = Cache()
    var images = NSCache<AnyObject, UIImage>()
    
}
