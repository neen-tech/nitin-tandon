//
//  ChangePasswordViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/14/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate, WebServiceDelegate {

    @IBOutlet var txtOld : UITextField!
    @IBOutlet var txtNew : UITextField!
    @IBOutlet var txtConfirm : UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func changePassword(sender: UIButton!)
    {
        if (self.txtOld.text?.characters.count)! > 0 && (self.txtNew.text?.characters.count)! > 0 &&
            (self.txtConfirm.text?.characters.count)! > 0 {
            
            if(txtNew.text?.characters.count)! > 7
            {
                if(txtNew.text == txtConfirm.text)
                {
                    self.setNewPassword()
                }
                else
                {
                   Alert.showTostMessage(message: APP_VALIDATION.kMSG_CONFIRM_PWD, delay: 3.0, controller: self)
                }
            }
            else
            {
                Alert.showTostMessage(message: APP_VALIDATION.kMSG_PWD_LANGHT, delay: 3.0, controller: self)

            }
            
        }
        else
        {
            Alert.showTostMessage(message: APP_VALIDATION.kMSG_EMPTY_FIELDS, delay: 3.0, controller: self)
        }
    }
    
    func setNewPassword()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_CHANGE_PWD, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject(txtOld.text! , forKey: "oldPassword" as NSCopying)
        dict.setObject(txtNew.text!, forKey: "newPassword" as NSCopying)

        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_CHANGE_PWD as NSString)
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_CHANGE_PWD) {
            
            HUD.closeHUD()
          
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
