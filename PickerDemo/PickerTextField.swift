//
//  PickerTextField.swift
//  PickerDemo
//
//  Created by Yudiz Pvt.Ltd on 27/12/16.
//  Copyright © 2016 Yudiz Pvt.Ltd. All rights reserved.
//

import UIKit
typealias pickerActionBlock = (_ selectedItem : AnyObject? , _ indexComponent : Int? , _ indexRow : Int? , _ isDone : Bool) -> Void
typealias datePickerActionBlock = (_ date : Date , _ strDate : String, _ isDone : Bool) -> Void

enum KeyboardType
{
    case KeyboardTypeDefault
    case KeyboardTypeASCIICapable
    case KeyboardTypeNumbersAndPunctuation
    case KeyboardTypeURL
    case KeyboardTypeNumberPad
    case KeyboardTypePhonePad
    case KeyboardTypeNamePhonePad
    case KeyboardTypeEmailAddress
    case KeyboardTypeDecimalPad
    case KeyboardTypeTwitter
    case KeyboardTypeWebSearch
    case KeyboardTypeASCIICapableNumberPad
    case KeyboardTypeAlphabet
    case KeyboardTypePicker(data:[AnyObject])
    case KeyboardTypeDatePicker(mode:UIDatePickerMode,minDate:Date, maxDate : Date ,displayFormat:String)
    
}

class PickerTextField: UITextField,UIPickerViewDelegate,UIPickerViewDataSource {
    var keyboard : KeyboardType!
    var arrPickerItems = Array<Any>()
    var pickerBlock : pickerActionBlock!
    var datePickerBlock : datePickerActionBlock!
    var selectedItemFromMultiComp = [String]()
    var selectedComponent = 0
    var selectedRow = 0
    var datePicker: UIDatePicker?
    let dateFormatr = DateFormatter()
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    @IBOutlet var picker: UIPickerView!
    
    override func awakeFromNib() {
        
    }
    var inputType:KeyboardType? {
        didSet {
            
            switch (inputType!) {
            case .KeyboardTypeASCIICapableNumberPad:
                self.keyboardType = .asciiCapableNumberPad
            case .KeyboardTypeASCIICapable:
                self.keyboardType = .asciiCapable
            case .KeyboardTypeNumbersAndPunctuation:
                self.keyboardType = .numbersAndPunctuation
            case .KeyboardTypeURL:
                self.keyboardType = .URL
            case .KeyboardTypeNamePhonePad:
                self.keyboardType = .namePhonePad
            case .KeyboardTypeTwitter:
                self.keyboardType = .twitter
            case .KeyboardTypeAlphabet:
                self.keyboardType = .alphabet
            case .KeyboardTypeDecimalPad:
                self.keyboardType = .decimalPad
            case .KeyboardTypePhonePad:
                self.keyboardType = .phonePad
            case .KeyboardTypeNumberPad:
                self.keyboardType = .numberPad
            case .KeyboardTypeEmailAddress:
                self.keyboardType = .emailAddress
            case .KeyboardTypePicker(let data):
                self.setPickerData(data, { (data, comp, row, done) in
                })
            case .KeyboardTypeDatePicker(let mode,let minDate,let maxDate,let displayFormat):
                self.setDatePicker(mode, minDate: minDate, maxDate: maxDate, dateFormate: displayFormat, { (date) in
                    
                })
            default:
                self.keyboardType = .alphabet
            }
        }
    }
}

// MARK:- set picker and header

extension PickerTextField
{
    func setDatePicker(_ mode:UIDatePickerMode, minDate : Date? = nil, maxDate : Date? = nil, dateFormate:String,_ block: @escaping datePickerActionBlock){
        self.datePickerBlock = block
        self.setHeaderView()
        dateFormatr.dateFormat = dateFormate
        if datePicker == nil{
            datePicker = UIDatePicker(frame: CGRect(x:0, y: 0, width: screenWidth, height:173))
            datePicker?.backgroundColor = UIColor.white
            datePicker?.datePickerMode = mode
            if minDate != nil{
                datePicker?.minimumDate = minDate
            }
            if maxDate != nil{
                datePicker?.maximumDate = maxDate
            }
            datePicker?.addTarget(self, action: #selector(self.dateChanged), for: .valueChanged)
            self.inputView = datePicker
        }
    }
    
    func setPickerData(_ arrData: [AnyObject], _ block: @escaping pickerActionBlock){
        self.pickerBlock = block
        self.setHeaderView()
        if picker == nil{
            arrPickerItems = arrData
            picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 173))
            picker?.backgroundColor = UIColor.white
            picker?.delegate = self
            picker?.dataSource = self
            self.inputView = picker
            
            if(arrPickerItems.count > 0){
                if(arrPickerItems[0] is NSArray ){
                    for component in arrPickerItems.enumerated()
                    {
                        let str = String(describing: (arrPickerItems[component.offset] as! NSArray)[0])
                        selectedItemFromMultiComp.insert(str, at: component.offset)
                    }
                }
            }
        }
    }
    
    func setHeaderView(_ background:UIColor = UIColor.lightGray,textColor:UIColor = UIColor.black)
    {
        
        let TCHeader: UIView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        TCHeader.backgroundColor = background
        let btnDone =  UIButton(frame: CGRect(x: screenWidth - 80 , y: 0, width: 80, height: 44))
        btnDone.setTitle("DONE", for: .normal)
        btnDone.setTitleColor(textColor, for: UIControlState.normal)
        btnDone.backgroundColor = UIColor.clear
        btnDone.addTarget(self, action: #selector(self.doneAction), for: UIControlEvents.touchUpInside)
        TCHeader.addSubview(btnDone)
        self.inputAccessoryView = TCHeader
    }
    
    //MARK:- Action
    
    func dateChanged(sender : UIDatePicker)
    {
        self.text = dateFormatr.string(from: (datePicker?.date)!)
        self.datePickerBlock(sender.date ,dateFormatr.string(from: sender.date),false)
    }
    
    func doneAction() {
        self .resignFirstResponder()
        if(picker != nil)
        {
            if arrPickerItems.count > 0{
                if arrPickerItems[0] is NSArray{
                    let strSend = selectedItemFromMultiComp.joined(separator: "  ")
                    self.pickerBlock(strSend as AnyObject,selectedComponent,selectedRow,true)
                }else{
                    self.pickerBlock(arrPickerItems[selectedRow] as AnyObject,selectedComponent,selectedRow,true)
                    self.text = String(describing: arrPickerItems[selectedRow])
                }
            }
        }
        else if(datePicker != nil)
        {
            self.datePickerBlock((datePicker?.date)! ,dateFormatr.string(from: (datePicker?.date)!),true)
            self.text = dateFormatr.string(from: (datePicker?.date)!)
        }
    }
}



// MARK:- picker view delegate

extension PickerTextField
{
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if arrPickerItems.count > 0 {
            if arrPickerItems[0] is NSArray {
                return (arrPickerItems[component] as! NSArray).count
            }
        }
        return arrPickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if arrPickerItems[0] is NSArray {
            return String(describing: (arrPickerItems[component] as! NSArray)[row])
        }
        return String(describing: arrPickerItems[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedComponent = component
        selectedRow = row
        if arrPickerItems.count > 0{
            if arrPickerItems[0] is NSArray{
                
                selectedItemFromMultiComp[component] = String(describing: (arrPickerItems[component] as! NSArray)[row])
                let strSend = selectedItemFromMultiComp.joined(separator: "  ")
                self.pickerBlock(strSend as AnyObject,selectedComponent,selectedRow,true)
                
            }else{
                self.text = String(describing: arrPickerItems[selectedRow])
                self.pickerBlock(arrPickerItems[selectedRow] as AnyObject,selectedComponent,selectedRow,false)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if arrPickerItems.count > 0 {
            if arrPickerItems[0] is NSArray {
                return arrPickerItems.count
            }
        }
        return 1
    }    
}


