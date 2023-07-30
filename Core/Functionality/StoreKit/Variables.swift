//
//  Variables.swift
//  Boston
//
//  Created by Rayan Waked on 3/5/23.
//

let defaultGroup = "group.6R2E9P9EPV.com.waked.boston"

class StoreManager {
    static let shared = StoreManager()
    
    var store = Store()
    
    private init() {}
}
