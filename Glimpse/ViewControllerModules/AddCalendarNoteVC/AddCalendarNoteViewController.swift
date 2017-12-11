//
//  AddCalendarNoteViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/15/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class AddCalendarNoteViewController: UIViewController,WebServiceDelegate,UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet var txtTitle : UITextField!
    @IBOutlet var txtDesc : UITextView!
    var strDate : String!
    @IBOutlet var timeTxt: UITextField!
    @IBOutlet var time_picker : UIDatePicker!
    var time: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        time_picker.addTarget(self, action: #selector(selectTime), for: .valueChanged)
 
        time_picker.isHidden = true
        time_picker.timeZone = TimeZone(abbreviation: "GMT+0:00")
            
       
        // Do any additional setup after loading the view.
    }

    func displayTime(){
        let toolbar_time = UIToolbar()
        toolbar_time.sizeToFit()
        
        let doneButton_time = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(selectTime))
        toolbar_time.setItems([doneButton_time], animated: false)
        
        timeTxt.inputAccessoryView = toolbar_time
        timeTxt.inputView = time_picker
    }
    
    func selectTime() {
        
        print(time_picker.date)
        timeTxt.text = Alert.dateToString(date: time_picker.date, format: "HH:mm")
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func addNote()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_ADD_IN_CALENDAR, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        dict.setObject(txtTitle.text!, forKey: "title" as NSCopying)

        dict.setObject(txtDesc.text!, forKey: "notes" as NSCopying)
        
        dict.setObject(strDate, forKey: "date" as NSCopying)

        dict.setObject(timeTxt.text!, forKey: "time" as NSCopying)

        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_ADD_IN_CALENDAR as NSString)
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        
        if methodName.isEqual(to: APIMETHOD.kAPI_ADD_IN_CALENDAR) {
   
            txtDesc.text = "Description"
            txtDesc.resignFirstResponder()
            txtTitle.resignFirstResponder()
            timeTxt.resignFirstResponder()

            self.navigationController?.popViewController(animated: true)
            
        }
    }
    
    func webServiceFailWithApplicationServerMSG(msg: String) {
        HUD.closeHUD()
        Alert.showTostMessage(message:msg as String, delay: 3.0, controller: self)
        
    }
    
    func webServiceFail(error: NSError) {
        HUD.closeHUD()
        Alert.showTostMessage(message:error.localizedDescription as String, delay: 3.0, controller: self)
        
    }
    
    
    //MARK: Text View Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Description")
        {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "")
        {
            textView.text = "Description"
        }
    }
    
    
    //MARK: Text Field Delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField == timeTxt)
        {
            time_picker.isHidden = false
            self.view.endEditing(true)
            timeTxt.resignFirstResponder()
            self.displayTime()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
