//
//  Bindable.swift
//  ConcreteChallenge
//
//  Created by Neylor Bagagi on 01/11/21.
//

import Foundation

class Bindable<T>{
    
    var value:T? {
        didSet {
            self.observer?(value!)
        }
    }
    var observer:((T) -> ())?
    
}
