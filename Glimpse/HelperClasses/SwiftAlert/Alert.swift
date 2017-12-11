//
//  Alert.swift
//  SwiftSamples
//
//  Created by Nitin Kumar on 13/06/17.
//  Copyright © 2017 Nitin Kumar. All rights reserved.
//

import UIKit
import STPopup
import PNTToolbar
import Quickblox



class Alert: NSObject {
    
    //MARK:- Show Tost Message...
    class func showTostMessage(message:String, delay:Double, controller:UIViewController!)
    {
        let alert = UIAlertController(title: nil,
                                      message: message as String,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        
         alert.show()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            // do stuff 42 seconds later
            
        alert.dismiss(animated: true, completion: nil)
        }
        
        // Uses
        
        //Alert.showTostMessage(message: "Server connection failed ! Please try later.", delay: 3.0, controller: self)
    }
    
    
    class func CALL_DELAY_INSEC(delay:Double, completion: (() -> Void)?)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
        }
    }
    
    
    //MARK: Get Hex String From UIcolor
    class func hexFromUIColor(color: UIColor)  -> String
    {
        let hexString = String(format: "%02X%02X%02X",
                               Int((color.cgColor.components?[0])! * 255.0),
                               Int((color.cgColor.components?[1])!*255.0),
                               Int((color.cgColor.components?[2])! * 255.0))
        return hexString
    }
    //MARK: Get UIcolor From Hex String  
    
    
   class func colorFromHexString(hexCode:String!)->UIColor{
        let scanner  = Scanner(string:hexCode)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "$+#")
        var hex: CUnsignedInt = 0
        if(!scanner.scanHexInt32(&hex))
        {
            return UIColor()
        }
        let  r  = (hex >> 16) & 0xFF;
        let  g  = (hex >> 8) & 0xFF;
        let  b  = (hex) & 0xFF;
        
        return UIColor.init(red: CGFloat(r) / 255.0, green:  CGFloat(g) / 255.0, blue:  CGFloat(b) / 255.0, alpha: 1)
    }
    
    
    //MARK: - convert dictionary to json object string
    class func jsonStringWithJSONObject(dictionary:NSDictionary)->NSString {
        let data: NSData? = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        
        var jsonStr: NSString?
        if data != nil {
            jsonStr = String(data: data! as Data, encoding: String.Encoding.utf8) as NSString?
        }
        
        return jsonStr!
    }
    
    //MARK: - GET_VIEW_CONTROLLER
    class func GET_VIEW_CONTROLLER(identifier:NSString)-> UIViewController
    {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier as String) as UIViewController
        return viewController
    }
    
    //MARK: - Date
    
    class func date() -> NSString
    {
        let date = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString as NSString
    }
    
    class func dateToString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    class func dateToString(date: Date, format: String!) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!

        let dateString = dateFormatter.string(from: date as Date)
        return dateString
    }
    class func stringToDate(strDate : String!) -> Date
    {
    let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" //Your date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!

        let date = dateFormatter.date(from: strDate) //accordin
    
        return date!
    }
    //MARK: - SET CUSTOM IMAGE IN UIBG
    
   class func isNull(someObject: AnyObject?) -> Bool {
        guard let someObject = someObject else {
            return true
        }
        
        return (someObject is NSNull)
    }
    
  class func showAlert(alerttitle :String, alertmessage: String,ButtonTitle: String, viewController: UIViewController)
    {
        
        
        let alertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle: .alert)
        let okButtonOnAlertAction = UIAlertAction(title: ButtonTitle, style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
        }
        alertController.addAction(okButtonOnAlertAction)
        alertController.show()
        
    }
    //MARK:- SCREEN HEIGHT
    class func kSCREEN_HEIGHT()->CGFloat
    {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        
        return height
    }
    //MARK:- SCREEN WITDH
    class func kSCREEN_WIDTH()->CGFloat
    {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        
        return width
    }
    
    //MARK: - ADD LABEL BG
    class func ADD_LABEL_TABLE_BG(tableView:UITableView,color:UIColor,msg:NSString)
    {
        let labelMsg = UILabel.init(frame: CGRect(x:0,y:0, width:Alert.kSCREEN_WIDTH(), height:Alert.kSCREEN_HEIGHT()))
        
        labelMsg.text = msg as String
        labelMsg.textColor = color
        labelMsg.numberOfLines = 0
        labelMsg.textAlignment = .center
        labelMsg.font = UIFont.init(name: "Palatino-Italic", size: 18.0)
        labelMsg.sizeToFit()
        tableView.backgroundView = labelMsg
        tableView.separatorStyle = .none
    }
    
    //MARK:- add a image in view background
   class func ADD_IMAGE_VIEWBG(view:UIView, image:UIImage )  {
        
        let frame       = UIScreen.main.bounds;
        let imageView   = UIImageView(frame:frame)
        imageView.image = image
       // imageView.contentMode = .scaleAspectFit
        view.insertSubview(imageView, at: 0)
       
    }
    //MARK:- add a image in UITableview background
   class func ADD_IMAGE_TABLEVIEWBG(tableView:UITableView, image:UIImage)  {
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0, width:Alert.kSCREEN_WIDTH(), height:Alert.kSCREEN_HEIGHT()))
        imageView.autoresizesSubviews = true
        imageView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        imageView.image = image
        tableView.backgroundView = imageView
    }
    
    // MARK:- string by commas...
  class  func stringByCommas(str:String) -> NSArray {
        
        let lines = str.characters.split(separator: ",").map(String.init)
        
        return lines as NSArray;
    }
    
    //MARK:- Left Right Padding of UITextField
    class func textFieldDesignWithLeftPadding(textField:UITextField,placeHonderName:NSString,placeHolderColor:UIColor, padding:Int, image:UIImage)
    {
        let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: padding , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 24 , height: 24))
        
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        textField.placeholder = placeHonderName as String
        textField.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        textField.leftView = viewPadding
        textField.leftViewMode = .always
        
    }
    
    
    class func textFieldDesignWithRightPadding(textField:UITextField,placeHonderName:NSString,placeHolderColor:UIColor, padding:Int, image:UIImage)
    {
        let viewPadding = UIView(frame: CGRect(x: 0, y: 0, width: padding , height: Int(textField.frame.size.height)))
        
        let imageView = UIImageView (frame:CGRect(x: 0, y: 0, width: 16 , height: 16))
        
        imageView.center = viewPadding.center
        imageView.image  = image
        viewPadding .addSubview(imageView)
        
        textField.placeholder = placeHonderName as String
        textField.setValue(placeHolderColor, forKeyPath: "_placeholderLabel.textColor")
        textField.rightView = viewPadding
        textField.rightViewMode = .always
    
    }
    
    //MARK:- ADD LOADER
    class func addLoader(view:UIView,viewColor:UIColor,indicatorColor:UIColor)
    {
        
      let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
        indicatorView.startAnimating()
        indicatorView.frame = CGRect(x: 0, y: 0, width: 40 , height:40)
        
        indicatorView.backgroundColor = UIColor.clear
        indicatorView.color = indicatorColor
        indicatorView.autoresizesSubviews = true
        indicatorView.autoresizingMask  = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
        
        let viewIndi = UIView(frame:view.bounds)
        viewIndi.tag = -2000
        viewIndi.backgroundColor = viewColor
        viewIndi.autoresizesSubviews = true
        viewIndi.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        indicatorView.center   = viewIndi.center
        viewIndi.addSubview(indicatorView)
        view.bringSubview(toFront: viewIndi)
        view.addSubview(viewIndi)
    }

    class func closeLoaders(yourView:UIView)
    {
        for view in yourView.subviews {
            
            if view.tag == -2000 {
                
                view.removeFromSuperview()
            }
            
        }
        
        
    }
    
    //MARK:- function to convert the given UIView into a UIImage
   class func imageWithView(view:UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    
   class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    //MARK:- Alert controller With Image
    class func alertWithImage(viewController: UIViewController, image:NSString, msg: NSString)
    {
        let alertController = UIAlertController(title: "\n\n\n\n\n\n", message: msg as String, preferredStyle: UIAlertControllerStyle.alert)
        
        let margin:CGFloat = 10.0
        let rect = CGRect(x: margin, y: margin, width: 260 - margin, height: 120)

        let imageView : UIImageView
        imageView  = UIImageView(frame:rect)
        imageView.image = UIImage(named:image as String)
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        alertController.view.addSubview(imageView)
        alertController.view.tintColor = UIColor.init(hex: "#465970")
        
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in print("cancel")})
        alertController.addAction(cancelAction)
        
        alertController.show()
        
       
    }
    
   // MARK: - ui color From Hex
   class func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    // MARK: - APP DELEGATE OBJECT
   class func appDelegate () -> AppDelegate
    {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
     // MARK: -  platform
   class func platform() -> String {
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    
  //MARK: - NETWORK STATUS
   class func netwokStatus() -> Bool {
    
    let reachbility = Reachability.forInternetConnection()
    
    let network  = reachbility?.currentReachabilityStatus()
    
    if network?.rawValue == 0 {
        
        return false
    }
    else
    {
        return true
    }
    
    }
    
    
    //MARK: -  Line on UIView
    
   class func lineOnView(view:UIView, color:UIColor, width:CGFloat, startPoint:CGPoint, endPoint:CGPoint) {
        
        let path = UIBezierPath()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        
        view.layer.addSublayer(shapeLayer)
    }
    
    //MARK: - Add image into view background
  class func ADD_IMAGEVIEW_VIEWBG(view:UIView) {
        
        let imageView = UIImageView.init(frame: CGRect(x:0,y:0, width:view.frame.size.width, height:view.frame.size.height))
        imageView.autoresizesSubviews = true
        imageView.autoresizingMask = [.flexibleHeight,.flexibleWidth]
        imageView.image = #imageLiteral(resourceName: "bg6")
        
        view.insertSubview(imageView, at: 0)
    }
    
    //MARK: - LAYER ON VIEW
    class func LAYER_ON_VIEW(view:UIView,color:UIColor,radius:CGFloat,border:CGFloat) {
        
        view.layer.cornerRadius         = radius
        view.layer.masksToBounds        = true;
        view.layer.borderColor          = color.cgColor
        view.layer.borderWidth          = border;
    }
    //MARK: - SHADOW ON VIEW
    class func SHADOW_ON_UIVIEW(view:UIView,shadowColor:UIColor,shadowRadius:Float, masksToBounds:Bool, radius:Float,shadowOpacity:Float)
    {
        
        view.layer.shadowColor    = shadowColor.cgColor
        view.layer.shadowOffset   = CGSize(width: 0, height: 2.0)
        view.layer.shadowOpacity  = Float(shadowOpacity)
        view.layer.shadowRadius   = CGFloat(shadowRadius)
        view.layer.masksToBounds  = masksToBounds
        view.layer.cornerRadius   = CGFloat(radius)
        view.layer.shadowPath = UIBezierPath(roundedRect:view.bounds, cornerRadius:view.layer.cornerRadius).cgPath
    }
    
    //MARK: - RATE APP
   class func rateApp(appId: String, completion: @escaping ((_ success: Bool)->())) {
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }

    //MARK: - GET APP INFO
   class func appinfo() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
    
        let build = dictionary["CFBundleVersion"] as! String
    
        let buildName = dictionary["CFBundleName"] as! String
    
    
    
        return "\(buildName) \(version) (\(build))"
    }
    
    
   class func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
  // MARK: - createRequestBodyWith for image uploading
  class func createRequestBodyWith(parameters:[String:NSObject], filePathKey:String, boundary:String,fileName:NSString,image:UIImage) -> NSData{
        
        let body = NSMutableData()
        
        for (key, value) in parameters {
            body.appendString(string: "--\(boundary)\r\n")
            body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.appendString(string: "\(value)\r\n")
        }
        
        body.appendString(string: "--\(boundary)\r\n")
        
        let mimetype = "image/jpg"
        
        let defFileName = fileName as NSString
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(defFileName)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageData!)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    
    
    // MARK: - CONFIG NAVIGATION STPOPUP CONTROLLER
   class func CONFIG_NAVIGATION_STPOPUP(){
        // barTintColor setting
        STPopupNavigationBar.appearance().barTintColor = Alert.colorFromHexString(hexCode:COLOR_CODE.NAVCOLOR)
        // TINT COLOR
        STPopupNavigationBar.appearance().tintColor = UIColor.white
        // ATTRIBUTE COLOR WITH FONT
    STPopupNavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.red,
                                                             NSFontAttributeName: UIFont(name: "mplus-1c-regular", size: 21)!]
    }
    
    //MARK: -  <STPopup showPopupWithTransitionStyle>
    class func SHOW_POPUP_WITH_TRANSACTION_STYLE(transitionStyle:STPopupTransitionStyle, style:STPopupStyle,rootController:UIViewController,presentController:UIViewController)
    {
        let stPopUpController = STPopupController.init(rootViewController: rootController)
        stPopUpController.containerView.layer.cornerRadius = 4.0
        stPopUpController.transitionStyle = transitionStyle
        stPopUpController.style           = style
        stPopUpController.present(in: presentController)
    }
    
    
    //MARK: - CHNAGE_BUTTON_IMAGE_COLOR
    class func CHNAGE_BUTTON_IMAGE_COLOR(image:UIImage,button:UIButton,color:UIColor)
    {
        
        let tintedImage = image.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        button.tintColor = color
    }
    
    
    //MARK: -  PNT TOOLBAR
    
    class func SET_TOOLBAR_ON_TABLEVIEW(tableView:UITableView,fields:NSArray)
    {
        let toolbar:PNTToolbar! = PNTToolbar.default()
        toolbar.mainScrollView = tableView
        toolbar.inputFields = fields as! [Any]
    }
    
    class func SET_TOOLBAR_ON_VIEW(view:UIView,fields:NSArray)
    {
        let toolbar:PNTToolbar! = PNTToolbar.default()
        toolbar.inputFields = fields as! [Any]
    }
    
    class func SET_TOOLBAR_ON_SCROLLVIEW(view:UIScrollView,fields:NSArray)
    {
        let toolbar:PNTToolbar! = PNTToolbar.default()
        toolbar.mainScrollView = view
        toolbar.inputFields = fields as! [Any]
    }
    
    
    
    //MARK: - ADD HOME Bar button
    class func LOGOUT_BUTTON() -> UIBarButtonItem {
        
        let buttonLogout = UIButton.init(type: .custom)
        buttonLogout.frame = CGRect(x:0, y:0, width: 80, height: 44);
        buttonLogout.backgroundColor = .clear
        buttonLogout.setTitle("Logout", for: .normal)
        buttonLogout.titleLabel?.font = UIFont.init(name: "Helvetica-Bold", size: 14)
        buttonLogout.addTarget(self, action: #selector(Alert.barButtonLogoutClick), for: UIControlEvents.touchUpInside)
        let barButtonLogout:UIBarButtonItem! = UIBarButtonItem.init(customView: buttonLogout)
       // let barButtonLogout:UIBarButtonItem! = UIBarButtonItem.init(title: "Logout", style: .plain, target: self , action: #selector(Alert.barButtonLogoutClick))
        return barButtonLogout;
        
        
    }
    // MARK: - HOME button Click
    @objc class func barButtonLogoutClick() {
        
        // Load menu
        
        let alertController = UIAlertController(title: "Glimpse" , message: APP_CONST.kLOGOUT_CONFIRMATION, preferredStyle: .alert)
        
        let logoutButtonOnAlertAction = UIAlertAction(title: "Logout", style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
            
             //let user:QBUUser = QBSession.current.currentUser!
            
            QBRequest.logOut(successBlock: { (response:QBResponse?) in
                
                UserDefaults.standard.set(nil, forKey:EXTRA.kAPI_LOGIN_DATA)
                UserDefaults.standard.set("", forKey:USER.kUSER_PWD)
                
                UserDefaults.standard.synchronize()
                ServicesManager.instance().chatService.disconnect()
                ServicesManager.instance().logout(completion: {
                    
                })
                let glimpseViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_WELCOME_VC as NSString) as! GlimpseViewController
                
                Alert.appDelegate().setIntialVC(viewController: glimpseViewController)
                
            }, errorBlock: { (error) in
                
            })
            
           
            
        }
        
        let cancelButtonOnAlertAction = UIAlertAction(title: "Cancel", style: .default)
        { (action) -> Void in
            //what happens when "ok" is pressed
            
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addAction(cancelButtonOnAlertAction)
        alertController.addAction(logoutButtonOnAlertAction)
        alertController.show()
        
    }
   
    //MARK: - ADD HOME Bar button
    class func HOME_BUTTON() -> UIBarButtonItem {
        
        let barButtonHome:UIBarButtonItem! = UIBarButtonItem(image:#imageLiteral(resourceName: "home_nav"), style: .plain, target: self, action: #selector(Alert.barButtonHomeClick))
        barButtonHome.imageInsets = UIEdgeInsetsMake(0.0, 0.0, 0, 0);
        return barButtonHome;
        
        
    }
    
    // MARK: - HOME button Click
    @objc class func barButtonHomeClick() {
        
        // Load menu
        
        Alert.MENU()
        
    }
    
    
    //MARK: - LOAD MENU
   class func MENU()
    {
       // let dasboardVC = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_DASHBOARD_VC as NSString) as! DashboardViewController
        
        //let menuVC = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_MENU_VC as NSString) as! MenuViewController
        
        
       // Alert.appDelegate().setMenuVC(rearVC: menuVC, frontVC: dasboardVC)
        
    }
    
    
    //MARK: - Ramdom Color iOS
  class func getRandomColor() -> UIColor{
        
    let randomRed:CGFloat = CGFloat(drand48())
        
    let randomGreen:CGFloat = CGFloat(drand48())
        
    let randomBlue:CGFloat = CGFloat(drand48())
        
    return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    
}





