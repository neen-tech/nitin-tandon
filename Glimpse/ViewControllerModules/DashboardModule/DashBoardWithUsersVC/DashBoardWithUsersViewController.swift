//
//  DashBoardWithUsersViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/13/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import JTMaterialTransition
import AlamofireImage
import Quickblox
import QMCVDevelopment
import QMServices

class DashBoardWithUsersViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UICollectionViewDelegate,WebServiceDelegate, QMChatServiceDelegate, QMChatConnectionDelegate, QMAuthServiceDelegate  {
    
     var transition: JTMaterialTransition?
    fileprivate let itemsPerRow: CGFloat = 3
    var buttonComment       = UIButton()
    var buttonLike          = UIButton()
    var buttonFavourite     = UIButton()
    var upperView           = UIView()
    var collectionView: UICollectionView!
    fileprivate let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    var YAxis:Double!
    
    
    // ARRAY
    
     var arrayUserStore           = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load Initial UI
        self.loadCustomNavBar()
        self.loadConfigView()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
          ServicesManager.instance().chatService.connect(completionBlock: nil)
          
        
        // SERVICE GET ALL USER
        if Alert.netwokStatus() {
              self.SERIVICE_GET_USERS(pageno: "1")
            
            
          
            
        }
        else
        {
            Alert.showTostMessage(message: APP_CONST.kNETWORK_ISSUE, delay: 3.0, controller: self)
        }
        
      
       
    }
    
    // MARK: Navigation Bar
    func loadCustomNavBar(){
        
        self.navigationController?.isNavigationBarHidden = false
        
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
    
    func loadConfigView(){
        
        self.view.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_BG_COLOR)
        
        self.loadUpperView()
        self.loadBottomView()
        
        ServicesManager.instance().chatService.addDelegate(self)
        ServicesManager.instance().authService.add(self)
        
        //
        
        
        // Stop Button X
        let stopButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "error"), style: .plain, target: self, action: #selector(self.stopButtonClick))
        
        self.navigationItem.leftBarButtonItem = stopButton
    }
    
    //MARK: - STOP BUTTON CLICK
    func stopButtonClick()  {
        DISMISS_VC_NAV(animated: true)
    }
    
    
    
    
    
    // MARK : loadUpperView
    func loadUpperView(){
        
        // Add Upper View For user image and background blur image
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: Alert.kSCREEN_WIDTH(), height: 220))
        upperView.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_UPPER_HEADER)
        self.view.addSubview(upperView)
        
        // Blur User image
        let backgroundImage = UIImageView(image:#imageLiteral(resourceName: "girl"))
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
        
        let profileImageView = UIImageView(image: #imageLiteral(resourceName: "girl"))
        profileImageView.frame = CGRect(x:15, y:15, width:130, height:130)
        profileImageView.layer.cornerRadius = 65;
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .red
        borderImageView.addSubview(profileImageView)
        
        
        // Show Name
        let lblFirstName = UILabel(frame: CGRect(x: Alert.kSCREEN_WIDTH()-130, y: 10, width: 120, height: 30))
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
  
    // Load CollectionView
    func loadBottomView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        layout.itemSize = CGSize(width: 111, height: 111)
        
        collectionView = UICollectionView(frame: CGRect(x:0, y:upperView.frame.size.height+upperView.frame.origin.y, width: Alert.kSCREEN_WIDTH(), height: Alert.kSCREEN_HEIGHT()-(upperView.frame.size.height+upperView.frame.origin.y)-64), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
      //  collectionView.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: "UserCollectionViewCell")
        
        collectionView.register(UINib(nibName: "UserCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "UserCollectionViewCell")
        
        collectionView.backgroundColor = UIColor.clear
        self.view.addSubview(collectionView)
        
    }
    
     //MARK: - UICollectionViewDelegate, Datasources
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.arrayUserStore.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath as IndexPath) as! UserCollectionViewCell
        cell.backgroundColor = Alert.getRandomColor()
        
        
        
        for subview in cell.subviews {
            
            if subview.isKind(of: UIImageView.self)
            {
                subview.removeFromSuperview()
            }
        }
        
         Alert.LAYER_ON_VIEW(view: cell.imageViewProfile, color:(UIColor.white.withAlphaComponent(0.8)), radius: cell.imageViewProfile.frame.size.height/2, border: 2)
        
        
        let dictCell = self.arrayUserStore.object(at: indexPath.row) as! Dictionary<String, Any>
        
        let name = dictCell["firstName"] as! String
        let image = dictCell["image"] as! String
        
        cell.labelName.text = name
        
        if image == "" {
            
            cell.imageViewProfile.image = #imageLiteral(resourceName: "user")
        }
        else
        {
            let url = URL(string: image)
            cell.imageViewProfile.af_setImage(withURL: url!)
        }
        
        
        return cell
    }
    
    
    
    
    //MARK: - UICollectionViewDelegateFlowLayout
    
   
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        //2
        
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        
        
        let widthPerItem = availableWidth / itemsPerRow
        
        /*
        switch indexPath.item {
        case 0:
             return CGSize(width: (widthPerItem*2)-(widthPerItem/2) , height: widthPerItem)
        case 5:
            return CGSize(width: (widthPerItem*2)-(widthPerItem/2) , height: widthPerItem)
        case indexPath.item+1:
            return CGSize(width: (widthPerItem*2)-(widthPerItem/2) , height: widthPerItem)
        case indexPath.item+4:
            return CGSize(width: (widthPerItem*2)-(widthPerItem/2) , height: widthPerItem)
        case 12:
            return CGSize(width: (widthPerItem*2)-(widthPerItem/2) , height: widthPerItem)
        case 12:
            return CGSize(width: (widthPerItem*2)-(widthPerItem/2) , height: widthPerItem)
            
        default:
            return CGSize(width: widthPerItem, height: widthPerItem)
        }
 
             */
        if (indexPath.row == 0)
        {
             return CGSize(width: (widthPerItem*2)-(widthPerItem/2) , height:  widthPerItem - 20)
        }
        
        if (indexPath.row == 5)
        {
             return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        
        if (indexPath.row == 6)
        {
             return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5), height:  widthPerItem - 20)
        }
        
        if (indexPath.row == 11)
        {
             return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 12)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 17)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 18)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 19)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 24)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 25)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 30)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 31)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 36)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 37)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 42)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 43)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 48)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 49)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        if (indexPath.row == 54)
        {
            return CGSize(width: (widthPerItem*2)-((widthPerItem/2)+5) , height:  widthPerItem - 20)
        }
        else
        {
             return CGSize(width: (widthPerItem/2)+26, height: widthPerItem - 20)
        }
        
 
 
        
      //  return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        
        
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return sectionInsets.left
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
          let dictCell = self.arrayUserStore.object(at: indexPath.row) as! Dictionary<String, Any>
        let textChatViewController = TextChatViewController()
        textChatViewController.dictUser = dictCell
        
        
        
      let quickbloxID  = dictCell["quickbloxID"] as! String
        
       
        
        QBRequest.user(withID: UInt(quickbloxID)!, successBlock: { (response:QBResponse, user:QBUUser?) in
            
          //  let completion = {[weak self] (response: QBResponse?, createdDialog: QBChatDialog?) -> Void in
            print(user!)
            
            self.createChat(name: nil, users: [user!], completion: { (response:QBResponse?, createdDialog: QBChatDialog?) in
                
                print("createdDialog",createdDialog!)
                
                textChatViewController.chatDialog = createdDialog!
                textChatViewController.senderName = "nitin"
                let navigationController = UINavigationController.init(rootViewController: textChatViewController)
                navigationController.modalPresentationStyle = .custom
                navigationController.transitioningDelegate = self.transition
                self.present(navigationController, animated: false, completion: nil)
            })
           
            
        }) { (response:QBResponse) in
            
            print("response",response)
        }
        
        
        
       
       
        
    }
    
    
    
    
    //MARK:- SERIVICE_GET_USERS For Messages
    func SERIVICE_GET_USERS(pageno:String)
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_ALL_USERS, forKey: ACTION.kAPI_ACTION as NSCopying)
      dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        dict.setObject(pageno, forKey: EXTRA.kAPI_PAGE_NO as NSCopying)
        
        print(dict)

        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_ALL_USERS as NSString)
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_GET_ALL_USERS) {
            
            HUD.closeHUD()
            
            print("jsonResult:",jsonResult)
            
            self.arrayUserStore = NSMutableArray.init()
            
            self.arrayUserStore =  (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
            
            self.collectionView.reloadData()
            
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
    
    // CREATE CHAT
    func createChat(name: String?, users:[QBUUser], completion: ((_ response: QBResponse?, _ createdDialog: QBChatDialog?) -> Void)?) {
        
        if users.count == 1 {
            // Creating private chat.
            ServicesManager.instance().chatService.createPrivateChatDialog(withOpponent: users.first!, completion: { (response, chatDialog) in
                
                
                
                completion?(response, chatDialog)
            })
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    // MARK: - QMChatServiceDelegate
    
    func chatService(_ chatService: QMChatService, didUpdateChatDialogInMemoryStorage chatDialog: QBChatDialog) {
        
       // self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService,didUpdateChatDialogsInMemoryStorage dialogs: [QBChatDialog]){
        
      //  self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didAddChatDialogsToMemoryStorage chatDialogs: [QBChatDialog]) {
        
      //  self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didAddChatDialogToMemoryStorage chatDialog: QBChatDialog) {
        
      //  self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didDeleteChatDialogWithIDFromMemoryStorage chatDialogID: String) {
        
       // self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didAddMessagesToMemoryStorage messages: [QBChatMessage], forDialogID dialogID: String) {
        
       // self.reloadTableViewIfNeeded()
    }
    
    func chatService(_ chatService: QMChatService, didAddMessageToMemoryStorage message: QBChatMessage, forDialogID dialogID: String){
        
       // self.reloadTableViewIfNeeded()
    }
    
    // MARK: QMChatConnectionDelegate
    
    func chatServiceChatDidFail(withStreamError error: Error) {
       
    }
    
    func chatServiceChatDidAccidentallyDisconnect(_ chatService: QMChatService) {
      
    }
    
    func chatServiceChatDidConnect(_ chatService: QMChatService) {
      
        if !ServicesManager.instance().isProcessingLogOut! {
         
        }
    }
    
    func chatService(_ chatService: QMChatService,chatDidNotConnectWithError error: Error){
        
    }
    
    
    func chatServiceChatDidReconnect(_ chatService: QMChatService) {
      
        if !ServicesManager.instance().isProcessingLogOut! {
          
        }
    }

}




extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
}
