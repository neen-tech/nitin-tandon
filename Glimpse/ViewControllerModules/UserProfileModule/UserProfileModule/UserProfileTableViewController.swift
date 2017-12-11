//
//  UserProfileTableViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 10/12/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class UserProfileTableViewController: UITableViewController, WebServiceDelegate {
    
    @IBOutlet weak var gradientView : UIView!
    @IBOutlet weak var bgImageView : UIView!
    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var btnLikes : UIButton!
    @IBOutlet var lblFav : UILabel!
    @IBOutlet var lblComments : UILabel!
    @IBOutlet var txtChildren : UITextField!
    @IBOutlet var txtEthnicity : UITextField!
    @IBOutlet var txtBodyType : UITextField!
    @IBOutlet var txtHeight : UITextField!
    @IBOutlet var txtReligion : UITextField!
    @IBOutlet var txtSmoke : UITextField!
    @IBOutlet var txtEducation : UITextField!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnFav : UIButton!


    var strId : String!
    var dictDetails : NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
            txtChildren.isUserInteractionEnabled    = false
            txtEducation.isUserInteractionEnabled   = false
            txtSmoke.isUserInteractionEnabled       = false
            txtReligion.isUserInteractionEnabled    = false
            txtHeight.isUserInteractionEnabled      = false
            txtBodyType.isUserInteractionEnabled    = false
            txtEthnicity.isUserInteractionEnabled   = false

            // 
            loadCustomiseNavBar()
            loadProfileView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getProfileDetails()

    }

  
    func loadCustomiseNavBar() -> Void {
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = Alert.colorFromHexString(hexCode: COLOR_CODE.NAVCOLOR)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        // Nav Button Logout
        
        self.navigationItem.rightBarButtonItems = [Alert.LOGOUT_BUTTON()]
        
        
            // Nav Image
            let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
            imageView.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2-50, y: 0, width: 100, height: 45)
        self.navigationController?.navigationBar.addSubview(imageView)
        
    }
    
    //MARK: -  Get Profile Details
    func getProfileDetails()
    {
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_PROFILE_DETAILS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject(strId, forKey: USER.kOTHER_USERID as NSCopying)

        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_PROFILE_DETAILS as NSString)
    }
    // MARK: loadProfileView
    
    func loadProfileView() -> Void {
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = bgImageView.bounds
        blurEffectView.autoresizingMask = [UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(bgImageView.frame.width)), UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(bgImageView.frame.height))]
        bgImageView.addSubview(blurEffectView)
        
    }
    // MARK: goBack
    @IBAction func goBack(sender: UIButton!){
        self.navigationController?.popViewController(animated: true)
        
    }
    
   
    
    // MARK: hitLike
    @IBAction func hitLike(sender: UIButton!){
        if(self.dictDetails.value(forKey: "profileLikeByMe") as! String == "Yes")
        {
            Alert.showTostMessage(message: "Unliked", delay: 1.0, controller: self)

        }
        else
        {
            Alert.showTostMessage(message: "Liked", delay: 1.0, controller: self)

        }
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_LIKE_COMMENT_PROFILE, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)

        dict.setObject(strId, forKey: USER.kOTHER_USERID as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_LIKE_COMMENT_PROFILE as NSString)
        
    }
    
    @IBAction func likesClick(sender: UIButton!){

        let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        
        
        let glimpleViewController : UserLikesViewController = storyBoard.instantiateViewController(withIdentifier: "UserLikesViewController") as! UserLikesViewController
        
        glimpleViewController.strId = strId
        self.navigationController?.pushViewController(glimpleViewController, animated: true)
    }
    
    
    
    // MARK: hitComment
    @IBAction func hitComment(sender: UIButton!){
        
        let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        
        
        let glimpleViewController : CommentViewController = storyBoard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        
        glimpleViewController.strId = strId
       glimpleViewController.strUser = "yes"
        self.navigationController?.pushViewController(glimpleViewController, animated: true)
        
    }
    
    
    // MARK: hitFav
    @IBAction func hitFav(sender: UIButton!){
        if(self.dictDetails.value(forKey: "isMyFavourite") as! String == "Yes")
        {
            Alert.showTostMessage(message: "Unfavourite", delay: 1.0, controller: self)

        }
        else
        {
            Alert.showTostMessage(message: "Favourite", delay: 1.0, controller: self)

        }
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_MAKE_FAVOURITE, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        dict.setObject(strId, forKey: USER.kOTHER_USERID as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_MAKE_FAVOURITE as NSString)
        
        
    }
    

    
    
    
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
          if methodName.isEqual(to: APIMETHOD.kAPI_PROFILE_DETAILS) {
        
            self.dictDetails = NSDictionary.init()
            
            self.dictDetails = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSDictionary
            
            self.lblName.text = self.dictDetails.value(forKey: "firstName") as? String
            self.imgProfile.af_setImage(withURL: URL(string: (self.dictDetails.value(forKey: "image") as? String)!)!)
            self.btnLikes.setTitle(self.dictDetails.value(forKey: "totalLikes") as? String, for: UIControlState.normal)
            
            self.lblFav.text = self.dictDetails.value(forKey: "totalFavourite") as? String
            self.lblComments.text = self.dictDetails.value(forKey: "totalComments") as? String
            self.txtChildren.text = self.dictDetails.value(forKey: "Do You Have Children?") as? String
            self.txtEthnicity.text = self.dictDetails.value(forKey: "What's Your Ethnicity?") as? String
            self.txtBodyType.text = self.dictDetails.value(forKey: "What's Your Body Type?") as? String
            self.txtHeight.text = self.dictDetails.value(forKey: "height") as? String
            self.txtReligion.text = self.dictDetails.value(forKey: "What's Your Religion?") as? String
            self.txtSmoke.text = self.dictDetails.value(forKey: "Do You Smoke?") as? String
            self.txtEducation.text = self.dictDetails.value(forKey: "What's Your Highest Education?") as? String


//            if(self.dictDetails.value(forKey: "profileLikeByMe") as! String == "Yes")
//            {
//                self.btnLike.setImage(UIImage(named:"filledheart"), for: UIControlState.normal)
//            }
//            else
//            {
//                self.btnLike.setImage(UIImage(named:"like"), for: UIControlState.normal)
//
//            }
            if(self.dictDetails.value(forKey: "isMyFavourite") as! String == "Yes")
            {
                self.btnFav.setImage(UIImage(named:"filledstar"), for: UIControlState.normal)
            }
            else
            {
                self.btnFav.setImage(UIImage(named:"star-1"), for: UIControlState.normal)
                
            }
            tableView.reloadData()
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_LIKE_COMMENT_PROFILE) {
            self.getProfileDetails()

            print(jsonResult)
        }
          else if methodName.isEqual(to: APIMETHOD.kAPI_MAKE_FAVOURITE) {
            self.getProfileDetails()

            print(jsonResult)
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

