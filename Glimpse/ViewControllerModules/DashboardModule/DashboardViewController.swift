//
//  DashboardModule.swift
//  Glimpse
//
//  Created by Rameshwar on 10/6/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

import JTMaterialTransition
import AVFoundation
import AVKit
import AlamofireImage
import CoreLocation
import Quickblox


class DashboardViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource,UIScrollViewDelegate,AVPlayerViewControllerDelegate,WebServiceDelegate,CLLocationManagerDelegate {
    
    var backgroundImage = UIImageView()
    var profileImageView = UIImageView()
 var lblFirstName = UILabel()
    var buttonComment       = UIButton()
    var buttonLike          = UIButton()
    var buttonFavourite     = UIButton()
    var btnPhotos     = UIButton()
    var btnVideos     = UIButton()
    var upperView           = UIView()
    var YAxis:Double!
    var collectionGridView: UICollectionView!
    var arrImages :NSArray! = []
    var arrVideos :NSArray! = []
    var photoView = UIView()
    var transition: JTMaterialTransition?
    var pageControl = UIPageControl()
    var player : AVPlayer?
    let controller=AVPlayerViewController()
    var dictDetails : NSDictionary!
    var lblTemp : UILabel!
    var lblTempHeading : UILabel!
    var lblDateTitle : UILabel!
   var imgVideoThumbnail = UIImageView()
    var imgPhotos = UIImageView()
    var tempImage = UIImageView()
    
    //QB PROFILE FOR VIDEO CHAT
    var qbprofile = QBProfile()
    
    let timeout: TimeInterval = 2.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   self.getWeather(place: UserDefaults.standard.value(forKey: "locality") as! String)
        
        
        let currentUser:QBUUser = ServicesManager.instance().currentUser
        
        self.qbprofile.synchronize(withUserData: currentUser)
        
        ServicesManager.instance().chatService.connect(completionBlock: nil)
        
        QBChat.instance.pingServer(withTimeout: timeout) { (timeout:TimeInterval,seccess:Bool) in
            
            
            }

        self.loadCustomNavBar()
        self.loadConfigView()
       
        
    }
   
    override func viewWillAppear(_ animated: Bool) {
 
         self.getProfileDetails()
         self.getGalleryImages()
         self.getGalleryVideos()
    }
    


    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    
    // MARK: Navigation Bar
    func loadCustomNavBar()-> Void{
    
    self.navigationController?.isNavigationBarHidden = false
    self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
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
   
     // MARK: loadConfigView
    
    func loadConfigView()->Void{
      
        self.view.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_BG_COLOR)
        
        self.loadUpperView()
        self.loadBottomView()
        
    }
    
    // MARK : loadUpperView
    func loadUpperView() -> Void{
        
        // Add Upper View For user image and background blur image
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: Alert.kSCREEN_WIDTH(), height: 220))
        upperView.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_UPPER_HEADER)
        self.view.addSubview(upperView)
        
        // Blur User image
        backgroundImage = UIImageView(image:#imageLiteral(resourceName: "girl"))
        backgroundImage.frame = CGRect(x:0 , y:0, width:Alert.kSCREEN_WIDTH(), height:180)
        upperView.addSubview(backgroundImage)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(backgroundImage.frame.width)), UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(backgroundImage.frame.height))]
        
        backgroundImage.addSubview(blurEffectView)
        
        // Profile Pic
     
        
        let borderImageView = UIImageView(image:#imageLiteral(resourceName: "profileborderbold"))
        borderImageView.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2-80, y:10, width:160, height:160)
        borderImageView.layer.cornerRadius = 80;
        borderImageView.clipsToBounds = true
        borderImageView.backgroundColor = .white
        upperView.addSubview(borderImageView)
        
        profileImageView = UIImageView(image: #imageLiteral(resourceName: "girl"))
        profileImageView.frame = CGRect(x:15, y:15, width:130, height:130)
        profileImageView.layer.cornerRadius = 65;
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .red
        borderImageView.addSubview(profileImageView)
        
        
        // Show Name
        lblFirstName = UILabel(frame: CGRect(x: Alert.kSCREEN_WIDTH()-130, y: 10, width: 120, height: 30))
        lblFirstName.textColor = .black
        lblFirstName.textAlignment = .right
        lblFirstName.text = "Keyosha"
        lblFirstName.font = UIFont(name: "HelveticaNeue", size: 20)
        upperView.addSubview(lblFirstName)
        
        
        // Buttons Like, Comment & Favourite
        buttonComment =  UIButton(frame: CGRect(x:30, y:upperView.frame.size.height-35, width:Alert.kSCREEN_WIDTH()/3 , height:30))
        buttonComment.setTitle("1,212", for: .normal)
        buttonComment.setTitleColor(.white, for: .normal)
        buttonComment.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        buttonComment.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        buttonComment.titleLabel?.font = UIFont(name:"HelveticaNeue" , size:15)
        upperView.addSubview(buttonComment)
        
        
        buttonLike =  UIButton(frame: CGRect(x:Alert.kSCREEN_WIDTH()/3+20, y:upperView.frame.size.height-35, width:Alert.kSCREEN_WIDTH()/3 , height:30))
        buttonLike.setTitle("4,212", for: .normal)
        buttonLike.setTitleColor(.white, for: .normal)
        buttonLike.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        buttonLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        buttonLike.titleLabel?.font = UIFont(name:"HelveticaNeue" , size:15)
        upperView.addSubview(buttonLike)
        
        
        buttonFavourite =  UIButton(frame: CGRect(x:2*Alert.kSCREEN_WIDTH()/3, y:upperView.frame.size.height-35, width:Alert.kSCREEN_WIDTH()/3 , height:30))
        buttonFavourite.setTitle("4,212", for: .normal)
        buttonFavourite.setTitleColor(.white, for: .normal)
        buttonFavourite.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        buttonFavourite.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
        buttonFavourite.titleLabel?.font = UIFont(name:"HelveticaNeue" , size:15)
        upperView.addSubview(buttonFavourite)
        
    }
    
    // MARK : loadBottomView
    
    func loadBottomView() -> Void {
      
        let scrollBottomView = UIScrollView(frame:CGRect(x:0, y:upperView.frame.size.height+upperView.frame.origin.y, width: Alert.kSCREEN_WIDTH(), height: Alert.kSCREEN_HEIGHT()-(upperView.frame.size.height+upperView.frame.origin.y+10)))
        scrollBottomView.backgroundColor = .clear
        self.view .addSubview(scrollBottomView)
        
        
        
        YAxis = 5.0
        // Message View
        let viewMessage = UIView(frame: CGRect(x:10.0,y: 10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewMessage.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_MESSAGE_VIEW)
        scrollBottomView .addSubview(viewMessage)
        
        let lblMessageHeading = UILabel(frame: CGRect(x:10 , y:viewMessage.frame.size.height-30, width:100, height:20))
        lblMessageHeading.textColor = UIColor.white
        lblMessageHeading.backgroundColor = UIColor.clear
        lblMessageHeading.text = "Message"
        lblMessageHeading.font = UIFont(name:"HelveticaNeue-Light", size:14)
        
        viewMessage.addSubview(lblMessageHeading)
        
        
        let btnShowTotalMessage = UIButton(frame: CGRect (x:30, y:0, width:viewMessage.frame.size.width-40, height:viewMessage.frame.size.height))
        btnShowTotalMessage.backgroundColor = UIColor.clear
        btnShowTotalMessage.setImage(#imageLiteral(resourceName: "message"), for: .normal)
        btnShowTotalMessage.setTitle("4,212", for: .normal)
        btnShowTotalMessage.imageEdgeInsets = UIEdgeInsetsMake(-30, -10, 0, 0)
        btnShowTotalMessage.titleEdgeInsets = UIEdgeInsetsMake(-30, 0, -20, 0)
        btnShowTotalMessage.titleLabel?.font = UIFont(name:"HelveticaNeue", size:25)
        btnShowTotalMessage.addTarget(self, action: #selector(btnShowTotalMessageClick), for: .touchUpInside)
        self.transition = JTMaterialTransition(animatedView: btnShowTotalMessage)
        viewMessage.addSubview(btnShowTotalMessage)
        
        
      // Date View
        let viewDate = UIView(frame: CGRect(x:Alert.kSCREEN_WIDTH()/2+5, y:10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewDate.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_DATE_VIEW)
       scrollBottomView .addSubview(viewDate)
        
        
        
         lblDateTitle = UILabel(frame:CGRect(x:10, y:0, width:viewDate.frame.size.width-60, height:80))
        lblDateTitle.numberOfLines = 0
        lblDateTitle.textColor = UIColor.white
        lblDateTitle.font = UIFont(name:"HelveticaNeue-Light", size:15)
        viewDate.addSubview(lblDateTitle)
        
        let strDate : String! = Alert.dateToString(date: Date(), format: "dd")
        
        let btnCalendarDate = UIButton(frame:CGRect(x:lblDateTitle.frame.size.width+5, y:10, width: viewDate.frame.size.width-(lblDateTitle.frame.size.width+10), height:viewDate.frame.size.height/2-10))
        btnCalendarDate.setTitle(strDate, for: .normal)
        btnCalendarDate.titleLabel?.font = UIFont(name:"HelveticaNeue", size:30)
        btnCalendarDate.backgroundColor = UIColor.clear
        viewDate.addSubview(btnCalendarDate)
        
        let strMonth : String! = Alert.dateToString(date: Date(), format: "MMM")

        
        let btnCalendarDateMonth = UIButton(frame:CGRect(x:lblDateTitle.frame.size.width+5, y:viewDate.frame.size.height/2-10, width: viewDate.frame.size.width-(lblDateTitle.frame.size.width+10), height:viewDate.frame.size.height/2-10))
        btnCalendarDateMonth.setTitle(strMonth, for: .normal)
        btnCalendarDateMonth.titleLabel?.font = UIFont(name:"HelveticaNeue", size:18)
        btnCalendarDateMonth.backgroundColor = UIColor.clear
       // btnCalendarDateMonth.addTarget(self, action: #selector(btnCalendarDateMonthClick), for: .touchUpInside)
       // self.transition = JTMaterialTransition(animatedView: btnCalendarDateMonth)
        viewDate.addSubview(btnCalendarDateMonth)
        
        
        let btnCalendar = UIButton.init(type: .custom)
        btnCalendar.frame = CGRect(x: 0, y: 0, width: viewDate.frame.size.width, height: viewDate.frame.size.height)
        btnCalendar.backgroundColor = UIColor.clear
      //  btnCalendar.setTitle("nov", for: .normal)
      //   btnCalendar.titleLabel?.font = UIFont(name:"HelveticaNeue", size:18)
        btnCalendar.addTarget(self, action: #selector(btnCalendarDateMonthClick), for: .touchUpInside)
        self.transition = JTMaterialTransition(animatedView: btnCalendar)
        viewDate.addSubview(btnCalendar)
        
        // Photos View
        let viewPhotos = UIView(frame: CGRect(x:10, y:viewDate.frame.size.height+viewDate.frame.origin.y+10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewPhotos.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_DATE_VIEW)
        scrollBottomView .addSubview(viewPhotos)
        
       
//        let imgPhotos =  UIImageView(image: #imageLiteral(resourceName: "girl"))
        imgPhotos.frame =  CGRect(x:0, y:0, width:viewPhotos.frame.size.width, height:viewPhotos.frame.size.height)
       // imgPhotos.contentMode = .scaleAspectFit
        viewPhotos .addSubview(imgPhotos)
        
        
        btnPhotos = UIButton(frame:CGRect(x:0, y:0, width:viewPhotos.frame.size.width, height:viewPhotos.frame.size.height))
        btnPhotos.backgroundColor = .clear
        btnPhotos.tag = 0;
        btnPhotos.addTarget(self, action: #selector(hitPhotos(sender:)), for: .touchUpInside)
        viewPhotos.addSubview(btnPhotos)
        
        let lblPhotos = UILabel(frame:CGRect(x:5,y:viewPhotos.frame.size.height-30, width:viewPhotos.frame.size.width-10, height:30))
        lblPhotos.text = "Photos"
        lblPhotos.font = UIFont(name:"HelveticaNeue", size:16)
        lblPhotos.textColor = .white
        lblPhotos.backgroundColor = .clear
        viewPhotos.addSubview(lblPhotos)
        
        // Videos View
        let viewVideos = UIView(frame: CGRect(x:Alert.kSCREEN_WIDTH()/2+5, y:viewDate.frame.size.height+viewDate.frame.origin.y+10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewVideos.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_DATE_VIEW)
        scrollBottomView .addSubview(viewVideos)
    
        
        
        
  //      let imgVideoThumbnail =  UIImageView(image: #imageLiteral(resourceName: "girl"))
        imgVideoThumbnail.frame =  CGRect(x:0, y:0, width:viewPhotos.frame.size.width, height:viewPhotos.frame.size.height)
        // imgVideoThumbnail.contentMode = .scaleAspectFit
        viewVideos .addSubview(imgVideoThumbnail)
        
        btnVideos = UIButton(frame:CGRect(x:0, y:0, width:viewVideos.frame.size.width, height:viewVideos.frame.size.height))
        btnVideos.tag = 1;
        btnVideos.backgroundColor = .clear
        btnVideos.addTarget(self, action: #selector(hitVideos(sender:)), for: .touchUpInside)
        viewVideos.addSubview(btnVideos)
        
        let lblVideos = UILabel(frame:CGRect(x:5,y:viewVideos.frame.size.height-30, width:viewVideos.frame.size.width-10, height:30))
        lblVideos.text = "Videos"
        lblVideos.font = UIFont(name:"HelveticaNeue", size:16)
        lblVideos.textColor = .white
        lblVideos.backgroundColor = .clear
        viewVideos.addSubview(lblVideos)
        
        // Video Chat and Search View
        let viewVideoChatNSearch = UIView(frame: CGRect(x:10, y:viewVideos.frame.size.height+viewVideos.frame.origin.y+10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewVideoChatNSearch.backgroundColor = .clear
        scrollBottomView .addSubview(viewVideoChatNSearch)
        
        
        let btnVideoChat = UIButton(frame:CGRect(x:0, y:0, width:viewVideoChatNSearch.frame.size.width/2-5, height:viewVideoChatNSearch.frame.size.height))
        btnVideoChat.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_DATE_VIEW)
        btnVideoChat.setImage(#imageLiteral(resourceName: "videochat"), for: .normal)
        btnVideoChat.imageEdgeInsets = UIEdgeInsetsMake(-30, 8, 0, 0)
        btnVideoChat.titleEdgeInsets = UIEdgeInsetsMake(-30, -65, -95, 0)
        btnVideoChat.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 14)
        btnVideoChat.setTitle("Video Chat", for: .normal)
        btnVideoChat.addTarget(self, action: #selector(hitVideoChatButton), for: .touchUpInside)
        viewVideoChatNSearch.addSubview(btnVideoChat)
        
        
        let btnSearchView = UIButton(frame:CGRect(x:viewVideoChatNSearch.frame.size.width/2+5, y:0, width:viewVideoChatNSearch.frame.size.width/2-5, height:viewVideoChatNSearch.frame.size.height))
        btnSearchView.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_DATE_VIEW)
        btnSearchView.setImage(#imageLiteral(resourceName: "search"), for: .normal)
        btnSearchView.imageEdgeInsets = UIEdgeInsetsMake(-20, 15, 0, 0)
        btnSearchView.titleEdgeInsets = UIEdgeInsetsMake(-30, -70, -95, 0)
        btnSearchView.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 14)
        btnSearchView.setTitle("Search", for: .normal)
        viewVideoChatNSearch.addSubview(btnSearchView)
        
        btnSearchView.addTarget(self, action: #selector(moveOnSearch), for:.touchUpInside)
        
        
        // Temp View
        let viewTemp = UIView(frame: CGRect(x:Alert.kSCREEN_WIDTH()/2+5, y:viewVideos.frame.size.height+viewVideos.frame.origin.y+10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewTemp.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_TEMP_VIEW)
        scrollBottomView .addSubview(viewTemp)
        
        tempImage.frame = CGRect(x:10, y:viewTemp.frame.size.height/2-45, width: 50, height: 50)
        tempImage.backgroundColor = .clear
        viewTemp.addSubview(tempImage)
        
        
        lblTemp = UILabel(frame:CGRect(x:tempImage.frame.size.width+25,y:tempImage.frame.size.height/2-5, width:viewTemp.frame.size.width-(tempImage.frame.size.width+10), height:30))
        lblTemp.text = "76"
        lblTemp.font = UIFont(name:"HelveticaNeue-Medium", size:25)
        lblTemp.textColor = .white
        lblTemp.backgroundColor = .clear
        viewTemp.addSubview(lblTemp)
        
        
        
        lblTempHeading = UILabel(frame:CGRect(x:tempImage.frame.size.width-5,y:tempImage.frame.size.height+20, width:viewTemp.frame.size.width-(tempImage.frame.size.width-5), height:30))
        lblTempHeading.text = "Houston Cloudy"
        lblTempHeading.font = UIFont(name:"HelveticaNeue", size:16)
        lblTempHeading.textColor = .white
        lblTempHeading.backgroundColor = .clear
        viewTemp.addSubview(lblTempHeading)
        
        
        
        // Favourites & Glimpse View
        let viewFavNGlimpse = UIView(frame: CGRect(x:10, y:viewTemp.frame.size.height+viewTemp.frame.origin.y+10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewFavNGlimpse.backgroundColor = .clear
        scrollBottomView .addSubview(viewFavNGlimpse)
        
        
        let btnFav = UIButton(frame:CGRect(x:0, y:0, width:viewVideoChatNSearch.frame.size.width/2-5, height:viewVideoChatNSearch.frame.size.height))
        btnFav.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_DATE_VIEW)
        btnFav.setImage(#imageLiteral(resourceName: "star"), for: .normal)
        btnFav.addTarget(self, action: #selector(moveOnFavourite), for: .touchUpInside)

        btnFav.imageEdgeInsets = UIEdgeInsetsMake(-30, 10, 0, 0)
        btnFav.titleEdgeInsets = UIEdgeInsetsMake(-30, -70, -95, 0)
        btnFav.setTitle("Favourites", for: .normal)
        btnFav.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size:14)
        viewFavNGlimpse.addSubview(btnFav)
        
        let btnMyGlimpse = UIButton(frame:CGRect(x:viewVideoChatNSearch.frame.size.width/2+5, y:0, width:viewVideoChatNSearch.frame.size.width/2-5, height:viewVideoChatNSearch.frame.size.height))
        btnMyGlimpse.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_TEMP_VIEW)
        btnMyGlimpse.setImage(#imageLiteral(resourceName: "tv"), for: .normal)
        btnMyGlimpse.imageEdgeInsets = UIEdgeInsetsMake(-30, 10, 0, 0)
        btnMyGlimpse.titleEdgeInsets = UIEdgeInsetsMake(-30, -65, -95, 0)
        btnMyGlimpse.setTitle("Your Glimpse", for: .normal)
         btnMyGlimpse.addTarget(self, action: #selector(moveOnGlimpse), for: .touchUpInside)
        btnMyGlimpse.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size:13)
        viewFavNGlimpse.addSubview(btnMyGlimpse)
        
        
       // Settings & Discover View
        let viewSettingsNDiscover = UIView(frame: CGRect(x:Alert.kSCREEN_WIDTH()/2+5, y:viewTemp.frame.size.height+viewTemp.frame.origin.y+10, width:Alert.kSCREEN_WIDTH()/2-15, height:scrollBottomView.frame.size.height/4))
        viewSettingsNDiscover.backgroundColor = .clear
        scrollBottomView .addSubview(viewSettingsNDiscover)
        
        
        let btnSetting = UIButton(frame:CGRect(x:0, y:0, width:viewVideoChatNSearch.frame.size.width/2-5, height:viewVideoChatNSearch.frame.size.height))
        btnSetting.backgroundColor = UIColor.black .withAlphaComponent(0.6)
        btnSetting.setImage(#imageLiteral(resourceName: "setting"), for: .normal)
        btnSetting.imageEdgeInsets = UIEdgeInsetsMake(-25, 10, 0, 0)
        btnSetting.titleEdgeInsets = UIEdgeInsetsMake(-30, -70, -95, 0)
        btnSetting.addTarget(self, action: #selector(moveOnSettings(sender:)), for: .touchUpInside)

        btnSetting.setTitle("Settings", for: .normal)
        btnSetting.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size:13)
        viewSettingsNDiscover.addSubview(btnSetting)
        
       
        let btnDiscover = UIButton(frame:CGRect(x:viewVideoChatNSearch.frame.size.width/2+5, y:0, width:viewVideoChatNSearch.frame.size.width/2-5, height:viewVideoChatNSearch.frame.size.height))
        btnDiscover.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_MESSAGE_VIEW)
        btnDiscover.setImage(#imageLiteral(resourceName: "locator"), for: .normal)
        btnDiscover.imageEdgeInsets = UIEdgeInsetsMake(-25, 10, 0, 0)
        btnDiscover.titleEdgeInsets = UIEdgeInsetsMake(-30, -70, -95, 0)
        btnDiscover.setTitle("Discover", for: .normal)
        btnDiscover.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size:13)
        btnDiscover.addTarget(self, action: #selector(moveOnDiscover), for: .touchUpInside)
        viewSettingsNDiscover.addSubview(btnDiscover)
        
        
        scrollBottomView.contentSize = CGSize(width:Alert.kSCREEN_WIDTH(),height: scrollBottomView.frame.size.height+viewSettingsNDiscover.frame.size.height)
        
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
       
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kOTHER_USERID as NSCopying)

      
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_PROFILE_DETAILS as NSString)
    }
    
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_PROFILE_DETAILS) {
            
            DispatchQueue.main.async() {
                
                self.dictDetails = NSDictionary.init()
                
                self.dictDetails = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSDictionary
                
             
                self.buttonLike.setTitle(self.dictDetails.value(forKey: "totalLikes") as? String, for: UIControlState.normal)
                self.buttonComment.setTitle(self.dictDetails.value(forKey: "totalComments") as? String, for: UIControlState.normal)
                self.buttonFavourite.setTitle(self.dictDetails.value(forKey: "totalFavourite") as? String, for: UIControlState.normal)

                self.lblFirstName.text = self.dictDetails.value(forKey: "firstName") as? String
                self.profileImageView.af_setImage(withURL: URL(string: (self.dictDetails.value(forKey: "image") as? String)!)!)
                
                if((self.dictDetails.value(forKey: "todayCalendar") as! NSArray).count > 0)
                {
                let dictCalendar : NSDictionary! = (self.dictDetails.value(forKey: "todayCalendar") as! NSArray)[0] as! NSDictionary
                self.lblDateTitle.text = String(format : "%@ at %@",dictCalendar.value(forKey: "title") as! String,dictCalendar.value(forKey: "time") as! String)
                
                }
                else
                {
                      self.lblDateTitle.text = "No Reminder Today"
                }
                
                
                
               
                
            }
            
            
        }
        else if methodName.isEqual(to: "Weather") {
            
            let dictMain : NSDictionary! = jsonResult.object(forKey: "main") as? NSDictionary
            print("%.2f",(dictMain.value(forKey: "temp") as! Float ))
            DispatchQueue.main.async(execute: {
                self.lblTemp.text = String(format:"%.2fº",(dictMain.value(forKey: "temp") as! Float ))
                self.lblTempHeading.text = ((jsonResult.object(forKey: "weather") as! NSArray)[0] as! NSDictionary).value(forKey: "main") as? String
                
                self.tempImage.af_setImage(withURL: URL(string:String(format:"http://openweathermap.org/img/w/%@.png",(((jsonResult.object(forKey: "weather") as! NSArray)[0] as! NSDictionary).value(forKey: "icon") as? String)!))!)
            
            })
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_GET_GALLARY) {
           
            HUD.closeHUD()
            self.arrImages = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray
            if(collectionGridView != nil)
            {
            collectionGridView.reloadData()
            pageControl.numberOfPages = self.arrImages.count
            }
            if(arrImages.count > 0)
            {
                imgPhotos.isHidden = false

             imgPhotos.af_setImage(withURL: URL(string:(arrImages[0] as! NSDictionary).value(forKey: "image") as! String)!)
                
            }
            else
            {
                imgPhotos.isHidden = true
                self.removeCV()
            }
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_GET_VIDEO_GALLARY) {

            HUD.closeHUD()
            self.arrVideos = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray
            if(collectionGridView != nil)
            {
            collectionGridView.reloadData()
            pageControl.numberOfPages = self.arrVideos.count
            }
            if(arrVideos.count > 0)
            {
                imgVideoThumbnail.isHidden = false

            imgVideoThumbnail.af_setImage(withURL: URL(string:(arrVideos[0] as! NSDictionary).value(forKey: "thumb") as! String)!)
            }
            else
            {
                imgVideoThumbnail.isHidden = true
                self.removeCV()

            }
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_DELETE_GALLERY_IMAGE) {
            print(jsonResult)

            self.getGalleryImages()
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_DELETE_GALLERY_VIDEO) {
            print(jsonResult)
            
            self.getGalleryVideos()
            
        }
        
    }
    
    func webServiceFailWithApplicationServerMSG(msg: String) {
        HUD.closeHUD()
        Alert.showTostMessage(message:msg as String, delay: 2.0, controller: self)
        
    }
    
    func webServiceFail(error: NSError) {
        HUD.closeHUD()
        Alert.showTostMessage(message:error.localizedDescription as String, delay: 2.0, controller: self)
        
    }
    

    
    
     // MARK: hitLogout
    
    @objc func hitLogout(sender: UIBarButtonItem!) {
        
        
        
    }
    
    @objc func hitVideoChatButton(sender: UIButton!) {
        
         let videoListViewController = VideoListViewController()
        
        MOVE(vc: videoListViewController, animated: true)
    }
    
    // MARK: moveOnSearch
    
    @objc func moveOnSearch(sender: UIButton!){
        
        let moveController = SearchModuleVC()
    self.navigationController?.pushViewController(moveController, animated: true)
        
    }
    @objc func moveOnFavourite(sender: UIButton!){
        
        let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        
        
        let glimpleViewController : UIViewController = storyBoard.instantiateViewController(withIdentifier: "MyFavListViewController") as! MyFavListViewController
        
        self.navigationController?.pushViewController(glimpleViewController, animated: true)
    }
    @objc func moveOnGlimpse(sender: UIButton!){
        
        let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        
        
        let glimpleViewController : UIViewController = storyBoard.instantiateViewController(withIdentifier: "GlimpseTabBarViewController") as! GlimpseTabBarViewController
        
        self.navigationController?.pushViewController(glimpleViewController, animated: true)
    }
    @objc func moveOnSettings(sender: UIButton!){
        
        let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        
        
        let glimpleViewController : UIViewController = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        
        self.navigationController?.pushViewController(glimpleViewController, animated: true)
    }
    @objc func moveOnDiscover(sender: UIButton!){
        
       // let moveController = Alert.GET_VIEW_CONTROLLER(identifier: "DiscoverViewController" as NSString) as! DiscoverViewController
        
        let discoverViewController =  DiscoverViewController ()
        
     self.navigationController?.pushViewController(discoverViewController, animated: true)
        
        
    }
//
    
    @objc func hitVideos(sender: UIButton!){

        if(arrVideos.count == 0)
        {
            self.uploadPhoto(sender: btnVideos)
        }
        else
        {
   //     HUD.addHudWithWithGif()
        self.getGalleryVideos()
        
        self.photoViewWithCallection(tag: sender.tag)
        }
    }
    
    @objc func hitPhotos(sender: UIButton!){
    //    HUD.addHudWithWithGif()
        if(arrImages.count == 0)
        {
            self.uploadPhoto(sender: btnPhotos)
        }
        else
        {
        self.getGalleryImages()

        self.photoViewWithCallection(tag: sender.tag)
        }
    }
    
    func getGalleryVideos()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_VIDEO_GALLARY, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_VIDEO_GALLARY as NSString)
    }
    
    
    func getGalleryImages()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_GALLARY, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_GALLARY as NSString)
    }
    
    func uploadPhoto(sender : UIButton!)
    {
        if(arrImages.count > 0)
        {
        self.removeCV()
        }
                let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
        
        
                let glimpleViewController : UploadPhotoViewController = storyBoard.instantiateViewController(withIdentifier: "UploadPhotoViewController") as! UploadPhotoViewController
        
        
                if(sender.tag == 0)
                {
                    glimpleViewController.strType = "photo"
                }
               else
                {
                   glimpleViewController.strType = "video"
                }
                self.navigationController?.pushViewController(glimpleViewController, animated: true)
    }
    //MARK: - photoView With Callectionview
    func photoViewWithCallection(tag : Int)  {
        photoView = UIView(frame:CGRect(x:5, y:0, width:Alert.kSCREEN_WIDTH()-10, height:Alert.kSCREEN_HEIGHT()-70))
        photoView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(photoView)
        
        
        let btnUpload = UIButton(frame:CGRect(x:20, y:photoView.frame.size.height/2-(photoView.frame.size.height/4)-40, width:30, height:30))
        btnUpload.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        btnUpload.addTarget(self, action: #selector(uploadPhoto(sender:)), for: .touchUpInside)
        btnUpload.tag = tag
        photoView.addSubview(btnUpload)
        
        let btnCancel = UIButton(frame:CGRect(x:photoView.frame.size.width-60, y:photoView.frame.size.height/2-(photoView.frame.size.height/4)-60, width:60, height:60))
        btnCancel.setImage(#imageLiteral(resourceName: "error"), for: .normal)
        btnCancel.addTarget(self, action: #selector(removeCV), for: .touchUpInside)
        photoView.addSubview(btnCancel)
        
        
        let btnDelete = UIButton(frame:CGRect(x:photoView.frame.size.width-60, y:photoView.frame.size.height/2-(photoView.frame.size.height/4)-60, width:60, height:60))
        btnDelete.center.x = photoView.center.x
        btnDelete.tag = tag
        btnDelete.setImage(#imageLiteral(resourceName: "garbage"), for: .normal)
        btnDelete.addTarget(self, action: #selector(deletePhotoVideo(sender:)), for: .touchUpInside)
        photoView.addSubview(btnDelete)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: photoView.frame.size.width, height: photoView.frame.size.height)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionGridView = UICollectionView(frame: CGRect(x:0, y:photoView.frame.size.height/2-(photoView.frame.size.height/4), width:photoView.frame.size.width, height: photoView.frame.size.height/2), collectionViewLayout: layout)
        collectionGridView.tag = tag
        collectionGridView.isPagingEnabled = true
        collectionGridView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionGridView.backgroundColor = UIColor.white
        photoView.addSubview(collectionGridView)
        
        collectionGridView.delegate = self
        collectionGridView.dataSource = self
        
        pageControl = UIPageControl(frame: CGRect(x: 0,y:collectionGridView.frame.origin.y+collectionGridView.frame.size.height+30 ,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = 0
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray
        self.photoView.addSubview(pageControl)
    }
    /*
    // Called when the cell is displayed
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        self.pageControl.currentPage = indexPath.row
    }
 
 */
    
    func deletePhotoVideo(sender : UIButton!){
        
        if(sender.tag == 0)
        {
            let dictImage = arrImages.object(at: pageControl.currentPage) as! NSDictionary
            //Web Service Delegate
            let webservice = WebService.init()
            webservice.delegate = self
            
            let dict = NSMutableDictionary.init()
            dict.setObject(APIMETHOD.kAPI_DELETE_GALLERY_IMAGE, forKey: ACTION.kAPI_ACTION as NSCopying)
            dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
          dict.setObject(dictImage.value(forKey: "imageId") as! String, forKey: "imageId" as NSCopying)
            
            
            webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_DELETE_GALLERY_IMAGE as NSString)
        }
        else
        {
            
            let dictImage = arrVideos.object(at: pageControl.currentPage) as! NSDictionary
            //Web Service Delegate
            let webservice = WebService.init()
            webservice.delegate = self
            
            let dict = NSMutableDictionary.init()
            dict.setObject(APIMETHOD.kAPI_DELETE_GALLERY_VIDEO, forKey: ACTION.kAPI_ACTION as NSCopying)
            dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
            dict.setObject(dictImage.value(forKey: "videoId") as! String, forKey: "videoId" as NSCopying)
            
            
            webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_DELETE_GALLERY_VIDEO as NSString)
            
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: scrollView.contentOffset, size: collectionGridView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        let indexPath = collectionGridView.indexPathForItem(at: visiblePoint)
        self.pageControl.currentPage = (indexPath?.row)!
    }
 
 
    func getWeather(place : String!)
    {
        
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        webservice.serviceGETMethod(urlStr: String(format:"http://api.openweathermap.org/data/2.5/weather?q=%@&units=metric&appid=4bd8e729d40bf7996f50448b4533e256",place) as NSString, methodName: "Weather")
        
    }
 
    
    
    @objc func btnCalendarDateMonthClick(sender: UIButton!){
        
        let calendarDateViewController = CalendarDateViewController()
        
        let navigationController = UINavigationController.init(rootViewController: calendarDateViewController)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self.transition
        
        self.present(navigationController, animated: true, completion: nil)
        
        //  self.navigationController?.pushViewController(dashBoardWithUsersViewController, animated: false)
        
    }
    
    
      // MARK : - btnShowTotalMessageClick
      @objc func btnShowTotalMessageClick(sender: UIButton!){
    
        let dashBoardWithUsersViewController = DashBoardWithUsersViewController()
        
        let navigationController = UINavigationController.init(rootViewController: dashBoardWithUsersViewController)
        navigationController.modalPresentationStyle = .custom
        navigationController.transitioningDelegate = self.transition
        
      self.present(navigationController, animated: true, completion: nil)
        
      //  self.navigationController?.pushViewController(dashBoardWithUsersViewController, animated: false)
    
      }
    
    
    
    // MARK :- Collection View Delegate

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if(collectionView.tag == 0)
        {
        return arrImages.count
        }
        else
        {
            return arrVideos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath)
        for subview in myCell.subviews {
            
            if subview.isKind(of: UIImageView.self)
            {
                subview.removeFromSuperview()
            }
        }
        if(collectionView.tag == 0)
        {
        let dict: NSDictionary! = arrImages.object(at: indexPath.row) as! NSDictionary
        
        
        
        
        let cellImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: photoView.frame.size.width, height: photoView.frame.size.height))
        cellImage.contentMode = .scaleAspectFit
        myCell.addSubview(cellImage)
        cellImage.af_setImage(withURL: URL(string: dict.value(forKey: "image") as! String)!)
        }
        else
        {
            let dict: NSDictionary! = arrVideos.object(at: indexPath.row) as! NSDictionary

            let cellImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: photoView.frame.size.width, height: photoView.frame.size.height))
            cellImage.contentMode = .scaleAspectFit
            myCell.addSubview(cellImage)
            cellImage.af_setImage(withURL: URL(string: dict.value(forKey: "thumb") as! String)!)
            
            
        let playImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        playImage.center = cellImage.center
        myCell.addSubview(playImage)
        playImage.image = #imageLiteral(resourceName: "play")
        }
        
        myCell.backgroundColor = .black
        
        return myCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("hit==>%@", indexPath.row);
        
        if(collectionView.tag == 1)
        {
            
            let dict: NSDictionary! = arrVideos.object(at: indexPath.row) as! NSDictionary

            
  

                
            player = AVPlayer(url:  URL(string: dict.value(forKey: "file") as! String)!)
            
                controller.player=player
                controller.view.frame = collectionGridView.frame
            
                photoView.addSubview(controller.view)
                self.addChildViewController(controller)
            
            player?.play()
            
        }
        
        
    }
    
    
    
    private func getSubviewsOf<T: UIView>(view: UIView) -> [T] {
        var subviews = [T]()
        
        for subview in view.subviews {
            subviews += getSubviewsOf(view: subview) as [T]
            
            if let subview = subview as? T {
                subviews.append(subview)
            }
        }
        
        return subviews
    }
    
    func removeCV(){
        if ((player?.rate != 0) && (player?.error == nil) && player != nil) {
            controller.view.removeFromSuperview()
            player?.pause()
            player = nil
            
        }
        else
        {
            if(collectionGridView != nil)
            {
        collectionGridView.removeFromSuperview()
            }
           
        photoView.removeFromSuperview()
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
