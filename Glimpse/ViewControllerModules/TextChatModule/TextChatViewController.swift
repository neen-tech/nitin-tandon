//
//  TextChatViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/23/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import Quickblox
import UITextView_Placeholder
import Alamofire
import AlamofireImage



class TextChatViewController: UIViewController{
   
    
    
    
    var imageViewUser       = UIImageView()
    var labelNameUser       = UILabel()
    var buttonComment       = UIButton()
    var buttonLike          = UIButton()
    var buttonFavourite     = UIButton()
    var upperView           = UIView()
    var chatDialog:QBChatDialog!
    var viewUserInfo        = UIView()
    
    var messagesAllMessages = [QBChatMessage]()
    
    // chat View Objects
    var viewChat            = UIView()
    var dictUser            = Dictionary<String, Any>()
    var dictMy              = Dictionary<String, Any>()
    var senderID :UInt?
    var senderName          : String!

    var imageSET            = UIImage()
    
    // MARKL: - View Base life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dictLogin = UserDefaults.standard.dictionary(forKey: EXTRA.kAPI_LOGIN_DATA)
        
        print(dictLogin!)
        
        configView()
        let image = self.dictUser[USER.kUSER_IMAGE] as! String
        let url = URL(string: image)
        let data = try? Data(contentsOf: url!)
        
        if data != nil {
            let image = UIImage(data: data!)
            imageSET = image!
          
        }

       
        // Do any additional setup after loading the view.
    }
    
   
    
    
    // MARK: - configView
    func configView() {
        
        self.loadCustomiseNavBar()
        self.loadUpperView()
        self.bottomView()
        self.loadViewChat()
        //  CONFIGURE CHAT WITH QUICK BLOX
     
       
    }
    
    
    //MARK: - CUSTOM NAVIGATION CONTROLLER
    func loadCustomiseNavBar() -> Void {
        self.view.backgroundColor = .white
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = Alert.colorFromHexString(hexCode: COLOR_CODE.NAVCOLOR)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        // Nav Button Cancel
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        // Nav Button Logout
        
        navigationItem.rightBarButtonItems = [Alert.LOGOUT_BUTTON()]
        
        // Nav Image
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        imageView.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2-50, y: 0, width: 100, height: 45)
        self.navigationController?.navigationBar.addSubview(imageView)
        
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
    
    
    //MARK: - bottomView()
    func bottomView() {
        
        // View User Info
         viewUserInfo = UIView.init(frame: CGRect(x: 0, y: upperView.frame.origin.y+upperView.frame.size.height, width: Alert.kSCREEN_WIDTH(),height: 70))
        
        viewUserInfo.backgroundColor = Alert.colorFromHexString(hexCode: "#580654")
        // Button Cross
        
        let buttonCross = UIButton.init(frame: CGRect(x:8,y: 8,width: 32,height:32))
        buttonCross.setImage(#imageLiteral(resourceName: "error"), for: .normal)
        buttonCross.backgroundColor = .clear
        buttonCross.addTarget(self, action: #selector(buttonCrossClick), for: .touchUpInside)
        
        let image = self.dictUser[USER.kUSER_IMAGE] as! String
        // User Image View
        imageViewUser = UIImageView.init(frame: CGRect(x:Alert.kSCREEN_WIDTH()/2 - 30,y: 5, width:60,height:60))
        
        let url =  URL(string:image)!
        
        imageViewUser.af_setImage(withURL: url)
        Alert.LAYER_ON_VIEW(view: imageViewUser, color: Alert.colorFromHexString(hexCode: "#AB83A9"), radius: imageViewUser.frame.size.height/2, border: 2.0)
        imageViewUser.backgroundColor = .black
        imageViewUser.contentMode = .scaleAspectFit
        
        
        // Label Name
        let name = self.dictUser[USER.kUSER_FIRST_NAME] as! String
        labelNameUser = UILabel.init(frame: CGRect(x:imageViewUser.frame.origin.x+imageViewUser.frame.size.width+8,y: 40, width: 150, height: 30))
        labelNameUser.textColor = .white
        labelNameUser.text      = name
        labelNameUser.font      = UIFont.init(name: FONT.kFONT_REGULAR, size: 20)
        
        
        let labelNo = UILabel.init(frame: CGRect(x:Alert.kSCREEN_WIDTH() - 88 ,y: 0, width: 80, height: 40))
        labelNo.textColor = .white
        labelNo.text      = "123"
        labelNo.textAlignment = .right
        labelNo.font = UIFont.init(name: FONT.kFONT_LIGHT, size: 25)
        
        viewUserInfo.addSubview(buttonCross)
        viewUserInfo.addSubview(imageViewUser)
        viewUserInfo.addSubview(labelNameUser)
        viewUserInfo.addSubview(labelNo)
        self.view.addSubview(viewUserInfo)
    }
    
    //MARK: - view Chat
    func loadViewChat() {
        
        // Chat Table
        self.viewChat = UIView.init(frame: CGRect(x:0, y: viewUserInfo.frame.origin.y+viewUserInfo.frame.size.height,width: Alert.kSCREEN_WIDTH(), height:Alert.kSCREEN_HEIGHT() - (220+135)))
        
        self.viewChat.backgroundColor = .blue
        
        
        let chatViewController = ChatViewController()
        chatViewController.senderID = (QBSession.current.currentUser?.id)!
        chatViewController.senderDisplayName = "Nitin"
        chatViewController.dialog = self.chatDialog!
        self.displayContentController(content: chatViewController)
       
        
    }    
    
    func displayContentController(content:UIViewController) {
        
        self.addChildViewController(content)
        content.view.frame =  CGRect(x:0, y: viewUserInfo.frame.origin.y+viewUserInfo.frame.size.height,width: Alert.kSCREEN_WIDTH(), height:Alert.kSCREEN_HEIGHT() - (220+135))
        self.view.addSubview(content.view)
        content.didMove(toParentViewController: self)
    }
    
    //MARK: - Button Cross Click
    @objc func buttonCrossClick(sender:UIButton)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            sender.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                
                self.DISMISS(animated: false)
            }
        })
    }
    
    
    
    //MARK: -  USER INFO
    
    func SHOW_USER_INFO() {
        
        
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
