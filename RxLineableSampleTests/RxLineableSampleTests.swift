//
//  RxLineableSampleTests.swift
//  RxLineableSampleTests
//
//  Created by Kyungjun Min on 2018. 5. 9..
//  Copyright © 2018년 Kyungjun Min. All rights reserved.
//

import XCTest
import RxSwift

@testable import RxLineableSample

class RxLineableSampleTests: XCTestCase {
    
    var controllerUnderTest: AllViewController!
    var VMUnderTest: UsersViewModel!
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        controllerUnderTest = UIStoryboard(name: "AllVC", bundle: nil).instantiateInitialViewController() as! AllViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        controllerUnderTest = nil
        super.tearDown()
    }
    
    func testCustom(){
        
        
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
