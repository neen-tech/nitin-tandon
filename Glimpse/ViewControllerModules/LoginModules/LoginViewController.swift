//
//  LoginViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/6/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import Quickblox


class LoginViewController: UIViewController,UITextFieldDelegate,WebServiceDelegate {

    @IBOutlet weak var imageViewProfile:UIImageView!
    @IBOutlet weak var textFieldEmail:UITextField!
    @IBOutlet weak var textFieldPwd:UITextField!
    @IBOutlet weak var buttonLogin  : UIButton!
    @IBOutlet weak var buttonForgotPassword  : UIButton!
    var deviceToken: String?
    var dictLogin:NSDictionary?
    var dictFPData:NSDictionary?
    var qbprofile = QBProfile()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Config
        self.config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden  = true
    }
    
    // MARK: - config
    func config() {
        
        self.view.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_LOGIN_BG)
        
        imageViewProfile.roundCorners(corners: [.allCorners], radius: imageViewProfile.frame.size.height/2)
        
      
         Alert.textFieldDesignWithLeftPadding(textField: textFieldEmail, placeHonderName: "E-mail address", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_TEXTFILED_PLACEHOLDER), padding: 16, image:#imageLiteral(resourceName: "blankPadding"))
        
          Alert.textFieldDesignWithLeftPadding(textField: textFieldPwd, placeHonderName: "***********", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_TEXTFILED_PLACEHOLDER), padding: 16, image:#imageLiteral(resourceName: "blankPadding"))
        
        textFieldEmail.roundCorners(corners: [.allCorners], radius: 5.0)
        textFieldPwd.roundCorners(corners: [.allCorners], radius: 5.0)
        buttonLogin.roundCorners(corners: [.allCorners], radius: 5.0)
        
        textFieldEmail.autocorrectionType = .no
        textFieldPwd.autocorrectionType = .no
        
        // Set Delegate
        
        textFieldEmail.delegate = self
        textFieldPwd.delegate     = self
        
        
    }
    
    
    
    //MARK: -  Button Actions
    
   @IBAction func buttonLoginClick(_ sender: Any)
   {
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
        self.buttonLogin.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }, completion: nil)
    
    UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
        self.buttonLogin.transform = CGAffineTransform.identity
        
        
    }, completion: {(finished) in
        
        // All Validate
    //   self.validateFieldsLogin()
        
        DispatchQueue.main.async(){
            
            /*
            let newViewController = DashboardViewController()
            
            Alert.appDelegate().setIntialVC(viewController: newViewController)
 
             */
            
            // All Validate
           self.validateFieldsLogin()
        }
        
      
        
    })
   }
    
    @IBAction func buttonForgotPasswordClick(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            self.buttonForgotPassword.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            self.buttonForgotPassword.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
                    DispatchQueue.main.async(){
                          self.validateFieldsForgotPassword()
         }
            
          
            
        })
    }
    
    //MARK: - TextFiledDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    //Validate Fields
    func validateFieldsForgotPassword() {
        
        if (textFieldEmail.text?.characters.count)!>0
        {
            
            if SwiftValidation.isValidEmail(testStr: textFieldEmail.text!)
            {
                if Alert.netwokStatus()
                {
                    // Service
                    Alert.LAYER_ON_VIEW(view: textFieldEmail, color: .clear, radius: 5.0, border: 2.0)
                    
                    HUD.addHud()
                    
                    self.hitForgotPass()
                }
                else
                {
                    Alert.showTostMessage(message: APP_CONST.kNETWORK_ISSUE, delay: 3.0, controller: self)
                }
            }
            else
            {
                Alert.LAYER_ON_VIEW(view: textFieldEmail, color: .red, radius: 5.0, border: 2.0)
                Alert.showTostMessage(message: APP_VALIDATION.kMSG_VALID_MAIL, delay: 3.0, controller: self)
            }
            
        }
        else
        {
            Alert.LAYER_ON_VIEW(view: textFieldEmail, color: .red, radius: 5.0, border: 2.0)
            Alert.showTostMessage(message: APP_VALIDATION.kMSG_EMPTY_FIELDS, delay: 3.0, controller: self)
        }
    }
    
    
    //MARK: hitForgotPass
    
    func hitForgotPass(){
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_FORGOT_PWD, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject(textFieldEmail.text!, forKey: USER.kUSER_EMAIL as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_FORGOT_PWD as NSString)
    }
    
    
    //Validate Fields
    func validateFieldsLogin() {
        
        if (textFieldEmail.text?.characters.count)!>0 && (textFieldPwd.text?.characters.count)!>0{
            
            if SwiftValidation.isValidEmail(testStr: textFieldEmail.text!)
            {
                   if SwiftValidation.isValidTextField(textFiled: textFieldPwd, langht: 5)
                   {
                    if Alert.netwokStatus()
                    {
                        //SERVICE USING MAIL
                        
                        //Add Hud
                        HUD.addHudWithWithGif()
                        self .quickbloxLoginUsingMailNPassword()
                        
                    }
                    else
                    {
                        Alert.showTostMessage(message: APP_CONST.kNETWORK_ISSUE, delay: 3.0, controller: self)
                    }
                   }
                else
                   {
                    
                   }
            }
            else
            {
                 Alert.showTostMessage(message: APP_VALIDATION.kMSG_VALID_MAIL, delay: 3.0, controller: self)
            }
            
        }
        else
        {
            Alert.showTostMessage(message: APP_VALIDATION.kMSG_EMPTY_FIELDS, delay: 3.0, controller: self)
        }
    }
    
    //MARK: -  QUICKBLOX LOGIN USING MAIL N PASSWORD
    func quickbloxLoginUsingMailNPassword(){
        
        QBRequest.logIn(withUserEmail: textFieldEmail.text!, password: textFieldPwd.text!, successBlock: { (response:QBResponse, user:QBUUser?) in
            
            if response.isSuccess{
                
                self.qbprofile.synchronize(withUserData: user!)
                print("user\(String(describing: user?.email))\n\(String(describing: user?.fullName))")
                
                ServicesManager.instance().logIn(with: user!, completion:{
                    [unowned self] (success, errorMessage) -> Void in
                    
                    self.serviceLoginUsingMail()
                    
                    guard success else {
                      
                        return
                    }
               })
                
              
               
               
            }
            else{
               
                 HUD.closeHUD()
                print("dict==>%@",response.error?.description ?? "error")
            }
            
            
        }) { (response:QBResponse) in
            
             HUD.closeHUD()
            
            print("dict==>%@",response.error?.description ?? "error")
            
             print("dict==>%@",response.error ?? "error")
            
        }
        
    }

    //MARK: -  SERVICE LOGIN USING MAIL
    func serviceLoginUsingMail()
    {
        if Platform.isSimulator {
            
            
        }
        else
        {
            deviceToken = UserDefaults.standard.value(forKey: DEVICE.kDEVICE_TOKEN) as? String
        }
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_LOGIN, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject(textFieldEmail.text!, forKey: USER.kUSER_EMAIL as NSCopying)
        dict.setObject(textFieldPwd.text!, forKey: USER.kUSER_PWD as NSCopying)
        dict.setObject(DEVICE.kDEVICE_NAME, forKey: DEVICE.kDEVICE as NSCopying)
        
        if deviceToken == nil {
            
            dict.setObject("42840239dnasdhqsau28093842", forKey: DEVICE.kDEVICE_TOKEN as NSCopying)
            
        }
        else
        {
            dict.setObject(deviceToken!, forKey: DEVICE.kDEVICE_TOKEN as NSCopying)
        }
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_LOGIN as NSString)
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_LOGIN) {
            
            DispatchQueue.main.async() {
                
                self.dictLogin = NSDictionary.init()
                
                self.dictLogin = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSDictionary
                
                
                //Store info Nsuser Default
                UserDefaults.standard.set(self.dictLogin, forKey:EXTRA.kAPI_LOGIN_DATA)
                UserDefaults.standard.set(self.textFieldPwd.text!, forKey:USER.kUSER_PWD)
                
                UserDefaults.standard.synchronize()
                
            let newViewController = DashboardViewController()
            Alert.appDelegate().setIntialVC(viewController: newViewController)
                
            }
            
            
        }
        
        //
        
        
        if methodName.isEqual(to: APIMETHOD.kAPI_FORGOT_PWD) {
            
            DispatchQueue.main.async() {
                
             self.dictFPData = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSDictionary
                
                Alert.showTostMessage(message: self.dictFPData?.object(forKey: "msg") as! String, delay: 2.0, controller: self)
                
            }
            
            
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
    

}
