//
//  User.swift
//  RxLineableSample
//
//  Created by Kyungjun Min on 2018. 5. 9..
//  Copyright © 2018년 Kyungjun Min. All rights reserved.
//

import Foundation


class User {
    var name: String
    var index: Int
    var noti: Bool = true
    var fav: Bool = false
    
    init(name: String, index: Int){
        self.name = name
        self.index = index
    }
    
    func switchNoti(){
        self.noti = !self.noti
    }
    
    func switchFav(){
        self.fav = !self.fav
    }
}
