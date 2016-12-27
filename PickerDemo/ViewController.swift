//
//  ViewController.swift
//  PickerDemo
//
//  Created by Yudiz Pvt.Ltd on 20/12/16.
//  Copyright © 2016 Yudiz Pvt.Ltd. All rights reserved.
//

import UIKit


class ViewController: UIViewController,UITextFieldDelegate {
    
    var arrBlood : Array<Any> = [["A+","A-","B+","B-","O+","O-","AB+","AB-"],[21,22,23,24,25],["Male","Female"]]
    var arrAmount : Array<Any> = [10.20,152.21,485.25,147.258,369.25]

    var strBlood = String()
    var strAge = String()
    var strGender = String()
    
    @IBOutlet var tfDate : PickerTextField!
    @IBOutlet var tfbloodGroup : PickerTextField!
    @IBOutlet var tfAmount : PickerTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tfAmount.setPickerData(arrAmount as [AnyObject]) { (data, compo, row, isDone) in
            print(self.arrAmount[row!])
            if isDone{
                self.tfDate.becomeFirstResponder()
            }
        }
        
        tfDate.setDatePicker(.dateAndTime,dateFormate: "dd MMMM, yyyy") { (date ,strDate, isDone) in
            if isDone{
                self.tfbloodGroup.becomeFirstResponder()
            }
        }
        
        tfbloodGroup.setPickerData(arrBlood as [AnyObject]) { (data, compo, row, isDone) in
            self.tfbloodGroup.text = String(describing: data!)
        }
        
        
    }
}


