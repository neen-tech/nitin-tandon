//
//  FullNameViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/10/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import THCalendarDatePicker
import Quickblox

class FullNameViewController: UIViewController,THDatePickerDelegate,UITextFieldDelegate,WebServiceDelegate {

    @IBOutlet weak var buttonGo: UIButton!
    @IBOutlet  var textFieldDateOfBirth: UITextField!
    @IBOutlet  var textFieldFullName: UITextField!
    @IBOutlet  var textFieldEmail: UITextField!
    @IBOutlet  var textFieldPwd: UITextField!
     @IBOutlet weak var imageViewBG: UIImageView!
    var qbprofile = QBProfile()
    var strSeekingData:String!
    var strIAmData:String!
    
    //
    
    var signUpUser = QBUUser()
    var deviceToken:String?
    var dictSignUpData : NSDictionary?
    
    var curDate : NSDate? = NSDate()
    lazy var formatter: DateFormatter = {
        var tmpFormatter = DateFormatter()
        tmpFormatter.dateFormat = "yyyy-MM-dd"
        return tmpFormatter
    }()
    
    lazy var datePicker : THDatePickerViewController = {
        let picker = THDatePickerViewController.datePicker()
        picker?.delegate = self as THDatePickerDelegate
        picker?.date = self.curDate! as Date
         picker?.setAllowClearDate(false)
         picker?.setClearAsToday(false)
         picker?.setAutoCloseOnSelectDate(true)
         picker?.setAllowSelectionOfSelectedDate(true)
         picker?.setDisableYearSwitch(false)
        //picker.setDisableFutureSelection(false)
         picker?.setDaysInHistorySelection(0)
         picker?.setDaysInFutureSelection(0)
         picker?.setDateTimeZoneWithName("UTC")
         picker?.autoCloseCancelDelay = 5.0
        picker?.isRounded = true
         picker?.dateTitle = "Date of Birth"
         picker?.selectedBackgroundColor = UIColor(red: 125.0/255.0, green: 208.0/255.0, blue: 0.0/255.0, alpha: 1.0)
         picker?.currentDateColor = UIColor(red: 242.0/255.0, green: 121.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        picker?.currentDateColorSelected = UIColor.yellow
        return picker!
    }()
    
    
    
    
    
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
        
        
        Alert.textFieldDesignWithLeftPadding(textField: textFieldDateOfBirth, placeHonderName: "Date of birth", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_PLACEHOLDER), padding: 0, image:#imageLiteral(resourceName: "blankPadding"))
        
        
        Alert.textFieldDesignWithLeftPadding(textField: textFieldEmail, placeHonderName: "E-mail address", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_PLACEHOLDER), padding: 0, image:#imageLiteral(resourceName: "blankPadding"))
        
        
        Alert.textFieldDesignWithLeftPadding(textField: textFieldPwd, placeHonderName: "Password", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_PLACEHOLDER), padding: 0, image:#imageLiteral(resourceName: "blankPadding"))
        
         Alert.textFieldDesignWithLeftPadding(textField: textFieldFullName, placeHonderName: "Full Name", placeHolderColor: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_PLACEHOLDER), padding: 0, image:#imageLiteral(resourceName: "blankPadding"))
        
        
        // Set Delegate UitextField
        
        textFieldDateOfBirth.delegate             = self
        textFieldEmail.delegate                   = self
        textFieldPwd.delegate                     = self
        textFieldFullName.delegate                = self
        
        
        // Border Bottom TextField
        
        textFieldDateOfBirth.addBottomBorderWithColor(color: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_TEXTFIELD_BORDER), width: 0.8)
        
        textFieldEmail.addBottomBorderWithColor(color: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_TEXTFIELD_BORDER), width: 0.8)
        
        textFieldPwd.addBottomBorderWithColor(color: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_TEXTFIELD_BORDER), width: 0.8)
        
        textFieldFullName.addBottomBorderWithColor(color: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_TEXTFIELD_BORDER), width: 0.8)
        
        buttonGo.roundCorners(corners: [.allCorners], radius: buttonGo.frame.size.height/2)
        
    }
    
    
    //MARK: - TextFieldDelegete
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
    }
    
    
  
    func refreshTitle() {
        
      //  dateButton.setTitle((curDate != nil ? formatter.string(from: curDate! as Date) : "Date of Birth"), for: UIControlState.normal)
        
        print("date:\((curDate != nil ? formatter.string(from: curDate! as Date) : "Date of Birth"))")
        self.textFieldDateOfBirth.text = (curDate != nil ? formatter.string(from: curDate! as Date) : "")
    }
    
  
    
    
    
    func convertCfTypeToString(cfValue: Unmanaged<NSString>!) -> String?{
        /* Coded by Vandad Nahavandipoor */
        let value = Unmanaged<CFString>.fromOpaque(
            cfValue.toOpaque()).takeUnretainedValue() as CFString
        if CFGetTypeID(value) == CFStringGetTypeID(){
            return value as String
        } else {
            return nil
        }
    }
    
    
    // MARK: THDatePickerDelegate
    
    func datePickerDonePressed(_ datePicker: THDatePickerViewController!) {
        curDate = datePicker.date! as NSDate
        refreshTitle()
        dismissSemiModalView()
    }
    
    func datePickerCancelPressed(_ datePicker: THDatePickerViewController!) {
        dismissSemiModalView()
    }
    
    func datePicker(datePicker: THDatePickerViewController!, selectedDate: NSDate!) {
      //  print("Date selected: ", formatter.string(from: selectedDate as Date))
        
        self.textFieldDateOfBirth.text = formatter.string(from: selectedDate as Date)
    }
    
    
      //MARK: - button Actions
    @IBAction func buttonGOClick(sender: AnyObject) {
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            self.buttonGo.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            self.buttonGo.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            // Validate Fields
            
            DispatchQueue.main.async(){
                
                self.validateFields()
                }
            
        })
        
    }
    
    
    @IBAction func touchedButton(sender: AnyObject) {
        textFieldDateOfBirth.resignFirstResponder()
        datePicker.date = self.curDate! as Date
        datePicker.delegate = self
        datePicker.setDateHasItemsCallback {
            (date: Date?) -> Bool in
            let tmp = (arc4random() % 30)+1
            return (tmp % 5 == 0)
        }
        presentSemiViewController(datePicker, withOptions: [
            convertCfTypeToString(cfValue: KNSemiModalOptionKeys.shadowOpacity) as String! : 0.3 as Float,
            convertCfTypeToString(cfValue: KNSemiModalOptionKeys.animationDuration) as String! : 1.0 as Float,
            convertCfTypeToString(cfValue: KNSemiModalOptionKeys.pushParentBack) as String! : false as Bool
            ])
    }
    
    
    //MARK: - ValidateFields
    
    func validateFields(){
        
        print("textFieldDateOfBirth:\(self.textFieldDateOfBirth.text!)")
        
        if (self.textFieldDateOfBirth.text?.characters.count)!>0 && (self.textFieldFullName.text?.characters.count)!>0 &&
            (self.textFieldEmail.text?.characters.count)!>0 &&  (self.textFieldPwd.text?.characters.count)!>0 {
            
            
            if SwiftValidation.isValidTextField(textFiled: self.textFieldFullName, langht: 1)
            {
                if SwiftValidation.isValidEmail(testStr: textFieldEmail.text!)
                {
                    if (textFieldPwd.text?.characters.count)!>7
                    {
                        if Alert.netwokStatus()
                        {
                            //  Service
                          
                            HUD.addHudWithWithGif()
                            self.quickbloaxSignUp()
                          
                        }
                        else
                        {
                            Alert.showTostMessage(message: APP_CONST.kNETWORK_ISSUE, delay: 3.0, controller: self)
                        }
                    }
                    else
                    {
                        Alert.showTostMessage(message: APP_VALIDATION.kMSG_PWD_LANGHT, delay: 3.0, controller: self)
                    }
                }
                else
                {
                    
                    Alert.showTostMessage(message: APP_VALIDATION.kMSG_VALID_MAIL, delay: 3.0, controller: self)
                }
            }
            else
            {
                 Alert.showTostMessage(message: APP_VALIDATION.kMSG_NAME_LENGTH, delay: 3.0, controller: self)
            }
        }
        else
        {
             Alert.showTostMessage(message: APP_VALIDATION.kMSG_EMPTY_FIELDS, delay: 3.0, controller: self)
        }
    }
    
    
    
    //MARK: - quickbloaxSignUp
    
    func quickbloaxSignUp(){
        
        self.signUpUser.password  =  textFieldPwd.text
        self.signUpUser.email     =  textFieldEmail.text
        self.signUpUser.fullName  =  textFieldFullName.text
        QBRequest.signUp(self.signUpUser, successBlock: { (response:QBResponse, user:QBUUser?) in
            
            
           self.qbprofile.synchronize(withUserData: user!)
        
            
            if response.isSuccess{
                
                self.hitSignUp(strQuickBloxId: NSString.init(format: "%d", (user?.id)!))
                
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
    
    
    //MARK: - hitSignUp
    func hitSignUp(strQuickBloxId:NSString){
        
        print("Quickblox Id ==>", strQuickBloxId)
        
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
        dict.setObject(APIMETHOD.kAPI_REGISTRATION, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject(textFieldEmail.text!, forKey: USER.kUSER_EMAIL as NSCopying)
        dict.setObject(textFieldPwd.text!, forKey: USER.kUSER_PWD as NSCopying)
        dict.setObject(textFieldDateOfBirth.text!, forKey: USER.kUSER_DOB as NSCopying)
        dict.setObject(textFieldFullName.text!, forKey: USER.kUSER_FIRST_NAME as NSCopying)
        dict.setObject(DEVICE.kDEVICE_NAME, forKey: DEVICE.kDEVICE as NSCopying)
        dict.setObject(self.strSeekingData!, forKey: USER.kUSER_SEEKING as NSCopying)
         dict.setObject(self.strIAmData!, forKey: USER.kUSER_GENDER as NSCopying)
        
        dict.setObject(strQuickBloxId, forKey: QUICKBLOX.QUICKBLOX_ID as NSCopying)
        if deviceToken == nil {
            
        dict.setObject("42840239dnasdhqsau28093842", forKey: DEVICE.kDEVICE_TOKEN as NSCopying)
            
        }
        else
        {
            dict.setObject(deviceToken!, forKey: DEVICE.kDEVICE_TOKEN as NSCopying)
        }
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_REGISTRATION as NSString)
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        if methodName.isEqual(to: APIMETHOD.kAPI_REGISTRATION) {
            
            DispatchQueue.main.async() {
                
                self.dictSignUpData = NSDictionary.init()
                
                self.dictSignUpData = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSDictionary
                
                //Store info Nsuser Default
                UserDefaults.standard.set(self.dictSignUpData, forKey:EXTRA.kAPI_LOGIN_DATA)
                UserDefaults.standard.set(self.textFieldPwd.text!, forKey:USER.kUSER_PWD)
                
                UserDefaults.standard.synchronize()
                
                self.moveUpdatePic(dictMoveData: self.dictSignUpData!)
                
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
    
    // MARK: moveUpdatePic Page
    func moveUpdatePic(dictMoveData:NSDictionary){
        
        let updateProfilePicViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_UPDATE_PROFILE_PIC_VC as NSString) as! UpdateProfilePicViewController
        updateProfilePicViewController.dictSignUpData = dictMoveData
        self.MOVE(vc: updateProfilePicViewController, animated: true)
        
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
