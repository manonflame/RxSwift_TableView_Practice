//
//  AddViewController.swift
//  RxLineableSample
//
//  Created by Kyungjun Min on 2018. 5. 10..
//  Copyright © 2018년 Kyungjun Min. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    
    
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    
    var viewModel : UsersViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        // Do any additional setup after loading the view.
    }
    
    func setupViewModel(){
        self.viewModel = UsersViewModel.Instance
        
    }
    
    @IBAction func confirmButtonTap(_ sender: Any) {
        viewModel.addUser(name: textField.text!)
        self.textField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
