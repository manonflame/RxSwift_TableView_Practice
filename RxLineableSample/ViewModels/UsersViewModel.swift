//
//  UsersViewModel.swift
//  RxLineableSample
//
//  Created by Kyungjun Min on 2018. 5. 9..
//  Copyright © 2018년 Kyungjun Min. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UsersViewModel{
    
    var index = -1
    
    var order = 1
    
    static let Instance : UsersViewModel = {
        return UsersViewModel()
    }()
    
    private var privateDataSource = BehaviorRelay<[User]>.init(value: [])
//    private let privateDataSource2 = BehaviorSubject<[User]>(value: []) //case2
//    private let privateDataSource3 : Variable<[User]> = Variable([]) //case3
    private let disposeBag = DisposeBag()
    
    public var dataSource: Observable<[User]>
//    public var dataSource2: Observable<[User]> //case2
//    public var dataSource3: Observable<[User]> //case3
    
    private init(){
        print("UserViewModel init()")
        self.dataSource = self.privateDataSource.asObservable()
        
        
        var i = 0
        var initUsers = [User]()
        for i in i ..< 30 {
            var initUser = User(name: "\(i)", index: i)
            initUsers.append(initUser)
        }
        self.privateDataSource.accept(initUsers)
//        self.dataSource2 = self.privateDataSource2.asObservable() //case2
//        self.dataSource3 = self.privateDataSource3.asObservable() //case3
    }
    
    func addUser(name: String){
        
        index += 1
        
        print("addUser")
        var newUser = User.init(name: name, index: index)
        
        //case1 : Use BehaviorRelay
        var users = self.privateDataSource.value
        users.append(newUser)
        self.privateDataSource.accept(users)
        
        
        //case2 : User BehaviorSubject
        //not implemented yet
        
        
        //case3 : User Variable
        //self.privateDataSource3.value.append(newUser)
    }
    
    func deleteUser(row: Int){
        var users = self.privateDataSource.value
        users.remove(at: row)
        self.privateDataSource.accept(users)
    }

    
    func addToFavorites(row: Int){
        var users = self.privateDataSource.value
        users[row].fav = true
        self.privateDataSource.accept(users)
    }
    
    func removeForFavorites(row: Int){
        var users = self.privateDataSource.value
        users[row].fav = false
        self.privateDataSource.accept(users)
    }
    
    func bindWith(segmentedTap: Driver<Int>){
        var users = self.privateDataSource.value
        
        segmentedTap.drive(
            onNext: {
                element in
                print("segmented Contoll : \(element)")
                if element == 1{
                    users.sort{
                        $0.index < $1.index
                    }
                    self.privateDataSource.accept(users)
                }
                else{
                    users.sort{
                        $0.name < $1.name
                    }
                    self.privateDataSource.accept(users)
                }
        }).disposed(by: disposeBag)
    }
    
    func switchNoti(set: Bool, row: Int){
        var users = self.privateDataSource.value
        print("row : \(row) , set : \(set)")
        users[row].noti = set
        self.privateDataSource.accept(users)
    }
    
    
}


