//
//  YourHeightViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/12/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class YourHeightViewController: UIViewController,UITextFieldDelegate, WebServiceDelegate {

    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var textFieldFeets: UITextField!
    @IBOutlet weak var textFieldInches: UITextField!
    @IBOutlet weak var labelHeight: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CONFIG
        
        self.configView()

        // Do any additional setup after loading the view.
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    //MARK: - Configration
    func configView() {
        
        // Blur Effect on ImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.view.frame
        imageViewBG.addSubview(visualEffectView)
        
        
        //TextFields
        
        
        Alert.textFieldDesignWithLeftPadding(textField: textFieldFeets, placeHonderName: "Feets", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_PLACEHOLDER), padding: 0, image:#imageLiteral(resourceName: "blankPadding"))
        
        
        Alert.textFieldDesignWithLeftPadding(textField: textFieldInches, placeHonderName: "Inches", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_PLACEHOLDER), padding: 0, image:#imageLiteral(resourceName: "blankPadding"))
        
   
        
        
        // Set Delegate UitextField
        
        textFieldFeets.delegate                     = self
        textFieldInches.delegate                    = self
      
        
        
        // Border Bottom TextField
        
        textFieldFeets.addBottomBorderWithColor(color: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_TEXTFIELD_BORDER), width: 0.8)
        
        textFieldInches.addBottomBorderWithColor(color: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_TEXTFIELD_BORDER), width: 0.8)
        

        
        buttonNext.roundCorners(corners: [.allCorners], radius: buttonNext.frame.size.height/2)
        
        Alert.SET_TOOLBAR_ON_VIEW(view: self.view, fields: [textFieldFeets,textFieldInches])
        
    }
    
    
    //MARK: - TextFieldDelegete
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == textFieldInches {
            
            if (textFieldFeets.text?.characters.count)!>0
            {
                let guess:Int = Int(textFieldFeets.text!)!
                
                if (guess >= 1) && (guess <= 8)
                {
          
                    self.labelHeight.text = "\(textFieldFeets.text!)'\(textFieldInches.text!)"
                    
                }
                else
                {
                    Alert.showTostMessage(message: "Please Enter a Valid Feets (Ex: 2 - 8)", delay: 3.0, controller: self)
                }
                
            }
            else
            {
                Alert.showTostMessage(message: "Please fill Feets first.", delay: 3.0, controller: self)
            }
        }
        
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == textFieldFeets {
            
            let maxLength = 1
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == textFieldInches {
            let maxLength = 2
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
       
        return false
    }
    
    
    
    //MARK: - button Actions
    @IBAction func buttonNextClick(sender: AnyObject) {
    
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            self.buttonNext.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            self.buttonNext.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                
                self.validateFields()
            }
            
        })
        
    }
    
    //MARK: - Validate Fields
    func validateFields() {
        
           if (self.textFieldFeets.text?.characters.count)!>0 &&  (self.textFieldInches.text?.characters.count)!>0 {
            
            let guess:Int = Int(textFieldFeets.text!)!
            
            if (guess >= 1) && (guess <= 8)
            {
                 let guess2:Int = Int(textFieldInches.text!)!
                
                 if (guess2 <= 12)
                 {
                    //
                    
                    
                    //Web Service Delegate
                    let webservice = WebService.init()
                    webservice.delegate = self
                    
                    let dict = NSMutableDictionary.init()
                    dict.setObject(APIMETHOD.kAPI_EDIT_PROFILE, forKey: ACTION.kAPI_ACTION as NSCopying)
                    dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
                    dict.setObject(String(format:"%@ft%@inch",textFieldFeets.text!,textFieldInches.text!), forKey: "height" as NSCopying)
                    
                    
                    
                    webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_EDIT_PROFILE as NSString)
                    
                 
                 }
                 else
                 {
                    
                    Alert.showTostMessage(message: "Please enter a valid Inches.", delay: 3.0, controller: self)
                 }
            }
            else
            {
                 Alert.showTostMessage(message: "Please enter a valid Feets.", delay: 3.0, controller: self)
            }
            
           }
           else
           {
            
             Alert.showTostMessage(message: APP_VALIDATION.kMSG_EMPTY_FIELDS, delay: 3.0, controller: self)
           }
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_EDIT_PROFILE) {
            

            let yourReligionViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_YOUR_RELIGION_VC as NSString) as! YourReligionViewController
            
            self.MOVE(vc: yourReligionViewController, animated: true)
        }
        
        //
        
        
        
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
