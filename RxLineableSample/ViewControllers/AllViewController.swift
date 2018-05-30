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
//                    self.confirmAlertAddToFav(row: element[1])
                    self.confirmAlertAddToFavRx(row: element[1])
            }
        ).disposed(by: disposeBag)
        
        
        
        /* < 삭제 > */
        //viewModel의 dataSource의 deleUser()를 호출하여 삭제
        self.tableView.rx.itemDeleted
            .subscribe(
                onNext: {
                    print("deletedRow : \($0[1])")
                    var idx = $0[1]
                    self.viewModel.deleteUser(row: idx)
            }
        ).disposed(by: disposeBag)
    
        //tableView의 rx.itemDeleted : ControlEvent를 이용하여 바인딩
        //멤버 삭제에 대한 구현은 상위에 있고 삭제시 뷰모델에서 로그만 찍음
        var subject : ControlEvent<IndexPath> = self.tableView.rx.itemDeleted
        self.viewModel.bindItemDeleted(subject: subject)
    }
    
    func confirmAlertAddToFavRx(row: Int){
        let actions: [UIAlertController.AlertAction] = [
        .action(title: "Cancel", style: .destructive),
        .action(title: "Confirm", style: .default)
        ]

        
        UIAlertController.present(in: self, title: "Add to Favorites?", message: "즐찾?", style: .alert, actions: actions)
        .subscribe(
            onNext: { buttonIndex in
                print("this is RxUIAlertTest : \(buttonIndex)")
                self.viewModel.addToFavorites(row: row)
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
    
    
    @objc func actionSample(){
        print("action Sample")
    }
}

class AllCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notiLabel: UILabel!
    @IBOutlet weak var indexLabel: UILabel!
}



extension UIAlertController{
    
    struct AlertAction {
        var title: String?
        var style: UIAlertActionStyle
        
        static func action(title: String?, style: UIAlertActionStyle = .default) -> AlertAction {
            return AlertAction(title: title, style: style)
        }
    }
    

    static func present(
        in viewController: UIViewController,
        title: String?,
        message: String?,
        style: UIAlertControllerStyle,
        actions: [AlertAction])
        -> Observable<Int>{
            return Observable.create { observer in
                let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
                actions.enumerated().forEach { index, action in
                    let action = UIAlertAction(title: action.title, style: action.style){ _ in
                        observer.onNext(index)
                        observer.onCompleted()
                    }
                    alertController.addAction(action)
                }
                viewController.present(alertController, animated: true, completion: nil)
                return Disposables.create { alertController.dismiss(animated: true, completion: nil)}
            }
    }
}

