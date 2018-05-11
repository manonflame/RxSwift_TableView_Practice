//
//  EditViewController.swift
//  RxLineableSample
//
//  Created by Kyungjun Min on 2018. 5. 10..
//  Copyright © 2018년 Kyungjun Min. All rights reserved.
//

import RxSwift
import RxCocoa

enum SortBy: Int{
    case Name = 0
    case Index = 1
}


class EditViewController: UIViewController {

    @IBOutlet weak var switchButton: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    private var viewModel : UsersViewModel!
    let cellIdentifier = "EditCell"
    var disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("EditViewConroller View Did Load()")
        
        //segmentedController <- UserDefault upload
        
        //segmentedController를 구독 :: 세그먼티드 값에 따라 userDefault에 저장.
        
        setupViewModel() //segmentedController 를 ViewModel과 바인딩
        setupTableView()
        setupTableViewBinding()
        
    }
    
    private func setupTableView(){
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
        self.tableView.tableFooterView = UIView()
    }
    
    private func setupViewModel(){
        self.viewModel = UsersViewModel.Instance
        self.viewModel.bindWith(segmentedTap: self.switchButton.rx.selectedSegmentIndex.asDriver())
    }
    
    private func setupTableViewBinding(){
        viewModel.dataSource.bind(to: self.tableView.rx.items){
            (tableView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            self.tableView.rowHeight = 83
            var cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier) as! EditCell
            cell.nameLabel.text = element.name
            cell.notiSwitch.isOn = element.noti
            cell.notiSwitch.rx.isOn
                .skip(1) // notiSwitch는 값이 할당됨 :: 무한루프 방지를 위해 skip(1)함 :: 첫 할당 값을 무시
                .subscribe(
                onNext: {
                    set in
                    self.viewModel.switchNoti(set: set, row: row)
            }).disposed(by: cell.disposeBag)
            return cell
        }.disposed(by: disposeBag)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class EditCell: UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notiSwitch: UISwitch!
    
    let subject = PublishSubject<Bool>()
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    @IBAction func swichTap(_ sender: Any) {
        print("switchTap")
    }
}


