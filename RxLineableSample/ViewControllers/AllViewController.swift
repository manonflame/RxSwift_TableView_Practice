//
//  ViewController.swift
//  RxLineableSample
//
//  Created by Kyungjun Min on 2018. 5. 9..
//  Copyright © 2018년 Kyungjun Min. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AllViewController: UITableViewController {
    
    private let cellIdentifier = "AllCell"
    private var viewModel: UsersViewModel!
    private var disposeBag = DisposeBag()
    
    @IBAction func toAddVC(_ sender: Any) {
        var addViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddVC")
        self.navigationController?.pushViewController(addViewController!, animated: true)
    }
    
    @IBAction func toEdit(_ sender: Any) {
        var editViewController = self.storyboard?.instantiateViewController(withIdentifier: "EditVC")
        self.navigationController?.pushViewController(editViewController!, animated: true)
    }
    
    
    
    @IBOutlet weak var addUserButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableVeiw()
        setupViewModel()
        setupTableViewBinding()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupTableVeiw(){
        //이 뷰 컨트롤러는 tableViewController임. 따라서 dataSource와 delegate를 nil처리
        self.tableView.dataSource = nil
        self.tableView.delegate = nil
        
        self.tableView.tableFooterView = UIView()
        
        //***cell을 등록해야함 : Custom셀을 할때는 다름. bind할 때 cell을 정해서 리턴함
//        self.tableView.register(AllCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func setupViewModel(){
        self.viewModel = UsersViewModel.Instance
    }
    
    private func setupTableViewBinding(){
        viewModel.dataSource.bind(to: self.tableView.rx.items){
            (tableView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.rowHeight = 97
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! AllCell
            cell.nameLabel.text = element.name
//            print("AllVC setupTBBinding() : \(row) name : \(element.name)")
            cell.notiLabel.text = { () -> String in
                if element.noti {
                    cell.notiLabel.textColor = UIColor.red
                    return "ON"
                }
                else{
                    cell.notiLabel.textColor = UIColor.gray
                    return "OFF"
                }
            }()
            cell.indexLabel.text = "[\(element.index)]"
            return cell
        }.disposed(by: disposeBag)
        
        self.tableView.rx.itemSelected
            .subscribe(
                onNext: { element in
                    print(element)
                    self.confirmAlertAddToFav(row: element[1])
            }
        ).disposed(by: disposeBag)
        
        self.tableView.rx.itemDeleted
            .subscribe(
                onNext: {
                    var idx = $0[1]
                    print("deleted row: \(idx)")
                    self.viewModel.deleteUser(row: idx)
            }
        ).disposed(by: disposeBag)
    }
    
    func confirmAlertAddToFav(row: Int){
        let confirmAlert = UIAlertController(title: "Add to Favorites?", message: "즐찾?", preferredStyle: .alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel){
            (_) in
            return
        }
        
        let confirm = UIAlertAction(title: "Add", style: .default){
            (_) in
            self.viewModel.addToFavorites(row: row)
            return
        }
        
        confirmAlert.addAction(cancel)
        confirmAlert.addAction(confirm)
        self.present(confirmAlert, animated: true)
    }
}

class AllCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
}

