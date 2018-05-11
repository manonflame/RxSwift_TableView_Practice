//
//  FavoritesViewController.swift
//  RxLineableSample
//
//  Created by Kyungjun Min on 2018. 5. 10..
//  Copyright © 2018년 Kyungjun Min. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let cellIdentifier = "FavoriteCell"
    private var viewModel: UsersViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.setupViewModel()
        self.setupTableViewBinding()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func setupTableView(){
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.tableFooterView = UIView()
    }
    
    private func setupViewModel(){
        self.viewModel = UsersViewModel.Instance
    }
    
    private func setupTableViewBinding(){
        viewModel.dataSource.bind(to: self.tableView.rx.items)
        {
            (tableView, row, element) in
            if element.fav {
                print("Fav Bind fav")
                let indexPath = IndexPath(row: row, section: 0)
                self.tableView.rowHeight = 95
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! FavoriteCell
                cell.nameLabel.text = element.name
                cell.notiLabel.text = { () -> String in
                    if element.noti {
                        return "On"
                    }
                    else{
                        return "Off"
                    }
                }()
                cell.indexLabel.text = "[\(element.index)]"
                
                return cell
            }
            else{
                print("Fav Bind unfav")
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! FavoriteCell
                self.tableView.rowHeight = 0
                
                return cell
            }
        }
        self.tableView.rx.itemDeleted
            .subscribe(onNext:{
                element in
                self.viewModel.removeForFavorites(row: element[1])
            }).disposed(by: disposeBag)
    }
}

class FavoriteCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
}
