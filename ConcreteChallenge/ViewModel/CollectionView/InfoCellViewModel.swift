//
//  InfoCellViewModel.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 06/11/21.
//

import Foundation

class InfoCellViewModel:NSObject {
    
    let title:String
    let value:String
    
    init(info:[String:String]) {
        self.title = info.keys.first ?? "UNKNOW"
        self.value = info.values.first ?? "UNKNOW"
    }
    
}
