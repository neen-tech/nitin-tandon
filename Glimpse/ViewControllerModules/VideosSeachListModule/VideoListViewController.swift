//
//  VideoListViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/23/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import Quickblox



class VideoListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,WebServiceDelegate,QBCoreDelegate,QBRTCClientDelegate,IncomingCallViewControllerDelegate {
    
    
    
    
    
    
    
    var tableViewVideo = UITableView()
    var searchBarVideo = UISearchBar()
    // ARRAY
    
    var arrayUserStore           = NSMutableArray()
    
    // session
    
    var session:QBRTCSession!
    
    var usersDataSource = UsersDataSource.init(currentUser: ServicesManager.instance().currentUser)
    
    var navController = UINavigationController()
    
    //MARK: - VIEW BASE CONROLLER LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        configView()
        
        if Alert.netwokStatus() {
            
            self.SERIVICE_GET_USERS(pageno: "1")
            QBCore.instance().add(self)
            QBRTCClient.instance().add(self)
        }
        else
        {
            Alert.showTostMessage(message: APP_CONST.kNETWORK_ISSUE, delay: 3.0, controller: self)
        }

        // Do any additional setup after loading the view.
    }
    
    // MARK: -  CONFIG VIEW CONTROLLER
    func configView() {
        
        //  Alert.ADD_IMAGE_VIEWBG(view: self.view, image: #imageLiteral(resourceName: "video_list_bg"))
        
        
        
          loadCustomiseNavBar()
          self.loadUI()
        
    }
    
    
    //MARK: - CUSTOM NAVIGATION CONTROLLER
    func loadCustomiseNavBar() -> Void {
        self.view.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_BG_COLOR)
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
    
    //MARK: -  loadTableView
    func loadUI() {
        
        let bgImage = UIImageView.init(frame: CGRect(x: 0,y: 0,width: Alert.kSCREEN_WIDTH(),height: Alert.kSCREEN_HEIGHT()))
            bgImage.image = #imageLiteral(resourceName: "video_list_bg")
            bgImage.contentMode = .scaleAspectFit
        self.view.insertSubview(bgImage, at: 0)
        

        // View Search bar Backgroud
        let viewSearch = UIView.init(frame: CGRect(x: 0,y: 0,width: Alert.kSCREEN_WIDTH(), height: 70))
        viewSearch.backgroundColor = UIColor.clear
        
        // Search bar
        self.searchBarVideo = UISearchBar.init(frame: CGRect(x: 0,y: 0,width: Alert.kSCREEN_WIDTH(), height: 56))
        self.searchBarVideo.placeholder = "SEARCH"
        searchBarVideo.backgroundColor = .clear
        searchBarVideo.searchBarStyle  = .minimal
        searchBarVideo.barStyle        = .default
        searchBarVideo.tintColor       = .white
        let textFieldInsideSearchBar = self.searchBarVideo.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = "Nearby Users"
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.textAlignment = .center
        
        // Button Cancel
        
        let buttonCancel = UIButton.init(frame:  CGRect(x:Alert.kSCREEN_WIDTH() - 58 ,y: searchBarVideo.frame.size.height+searchBarVideo.frame.origin.y, width: 50 , height: 24))
        
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.titleLabel?.textColor = .white
        buttonCancel.titleLabel?.font = UIFont.init(name: FONT.kFONT_REGULAR, size: 16)
        buttonCancel.addTarget(self, action: #selector(cancelButtonClick), for: .touchUpInside)
        
        
        // Tableview For Videos
        
        tableViewVideo = UITableView.init(frame: CGRect(x: 0,y: viewSearch.frame.origin.y + viewSearch.frame.size.height+8, width: Alert.kSCREEN_WIDTH(), height: Alert.kSCREEN_HEIGHT() - (70+60)))
        tableViewVideo.backgroundColor = UIColor.clear
        tableViewVideo.delegate        = self
        tableViewVideo.dataSource      = self
        tableViewVideo.separatorColor  = Alert.colorFromHexString(hexCode: "#C367C5")
        tableViewVideo.tableFooterView = UIView.init()
        tableViewVideo.register(UITableViewCell.self, forCellReuseIdentifier: "VideosCell")
        tableViewVideo.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        viewSearch.addSubview(searchBarVideo)
        viewSearch.addSubview(buttonCancel)
        self.view.addSubview(viewSearch)
        self.view.addSubview(tableViewVideo)
    }
    
    // MARK: - goBack
    
    @objc func goBack(sender: UIBarButtonItem!){
        self.BACK(animated: true)
        
    }
    
    @objc func cancelButtonClick(sender: UIButton!){
       
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            sender.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                
                self.BACK(animated: true)
            }
        })
    }
    
    
    //MARK: - Tableview Datasources and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayUserStore.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideosCell", for: indexPath as IndexPath)
        
        let dictCell = self.arrayUserStore.object(at: indexPath.row) as! Dictionary<String, Any>
        
        
        let firstName = dictCell["firstName"] as! String
        let image = dictCell["image"] as! String
        
        
        
        // User imageview
        let imageViewUser = UIImageView.init(frame: CGRect(x: 8, y: 4, width: 52, height:52))
        imageViewUser.contentMode = .scaleAspectFit
        imageViewUser.backgroundColor = .black
        Alert.LAYER_ON_VIEW(view: imageViewUser, color: Alert.colorFromHexString(hexCode: "#4D83B0"), radius: 26, border: 2.0)
        
        if (image == "")  {
            imageViewUser.image = #imageLiteral(resourceName: "user")
        }
        else
        {
            imageViewUser.af_setImage(withURL: URL(string:image)!)
        }
        
        
        // Label Name
        
        let labelUserName = UILabel.init(frame: CGRect(x: imageViewUser.frame.size.width+imageViewUser.frame.origin.x+8, y:8, width: 200, height:24))
        
        labelUserName.textColor = .white
        labelUserName.text      = firstName
        labelUserName.font      = UIFont.init(name: FONT.kFONT_REGULAR, size: 16)
        labelUserName.textAlignment = .left
        labelUserName.numberOfLines = 2
        
        
        // Label Date/Desc
        
        let labelDate = UILabel.init(frame: CGRect(x: imageViewUser.frame.size.width+imageViewUser.frame.origin.x+8, y:labelUserName.frame.size.height+labelUserName.frame.origin.y, width: 200, height:24))
        
        labelDate.textColor = Alert.colorFromHexString(hexCode: "#FF82FF")
        labelDate.text      = "Glimpse vChat - 04/04/2017"
        labelDate.font      = UIFont.init(name: FONT.kFONT_REGULAR, size: 12)
        labelDate.textAlignment = .left
        labelDate.numberOfLines = 2
        
        // Video Image with Button
        
        
        let buttonVideos = UIButton.init(frame: CGRect(x: labelDate.frame.size.width+labelDate.frame.origin.x+4, y: 14, width: 32, height: 32))
        
        buttonVideos.setBackgroundImage(#imageLiteral(resourceName: "play"), for: .normal)
        buttonVideos.backgroundColor = .clear
        buttonVideos.tag = indexPath.row
        buttonVideos.addTarget(self, action: #selector(buttonVideosClick), for: .touchUpInside)
        
        // Add all object on cell
        cell.addSubview(imageViewUser)
        cell.addSubview(labelUserName)
        cell.addSubview(labelDate)
        cell.addSubview(buttonVideos)
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
        
    }
    
    // MARK: - Button Video Click
    @objc func buttonVideosClick(sender:UIButton!){
        
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            sender.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                
                
                 let dictCell = self.arrayUserStore.object(at: sender.tag) as! Dictionary<String, Any>
                
                self.callWithConferenceType(confrancetype: QBRTCConferenceType.video, cellDict: dictCell)
              
            }
        })
    }
    
    
    func callWithConferenceType(confrancetype:QBRTCConferenceType,cellDict:Dictionary<String, Any>) {
        
        if self.session != nil {
            return
        }
        if Alert.netwokStatus() {
            
            
            QBAVCallPermissions.check(with: confrancetype, completion: { (granted) in
                
                if granted
                {
                   
                    
                    let quickbloxID  = cellDict["quickbloxID"] as! String
                    
                    QBRequest.user(withID: UInt(quickbloxID)!, successBlock: { (response:QBResponse, user:QBUUser?) in
                        
                        let currentUser:QBUUser = ServicesManager.instance().currentUser
                        
                        self.usersDataSource = UsersDataSource.init(currentUser: currentUser)
                        self.usersDataSource.ids(for: [user!])
                        
                        
                        let newSession = QBRTCClient.instance().createNewSession(withOpponents: [user!.id as NSNumber], with: QBRTCConferenceType.video)
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let callViewController = storyboard.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
                        
                        callViewController.session = newSession
                        callViewController.usersDatasource = self.usersDataSource
                        
                        let navigationContoller = UINavigationController.init(rootViewController: callViewController)
                       navigationContoller.modalTransitionStyle = .crossDissolve
                        
                        self.PRESENT_VC(vc: navigationContoller, animated: true)
                        
                        
                        
                    })
                    { (response:QBResponse) in
                        
                        print("response",response)
                    }
                }
            })
            
        }
        else
        {
            Alert.showTostMessage(message: APP_CONST.kNETWORK_ISSUE, delay: 3.0, controller: self)
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
            
           self.tableViewVideo.reloadData()
            
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
    
    
    
    //MARK: - IncomingCallViewControllerDelegate
    
    
    func incomingCallViewController(_ vc: IncomingCallViewController!, didAccept session: QBRTCSession!) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let callViewController = storyboard.instantiateViewController(withIdentifier: "CallViewController") as! CallViewController
        
        callViewController.session = session
        callViewController.usersDatasource = self.usersDataSource
    
        let navigationContoller = UINavigationController.init(rootViewController: callViewController)
        navigationContoller.modalTransitionStyle = .crossDissolve
        
        vc.PRESENT_VC(vc: navigationContoller, animated: true)
        
        
    }
    
    func incomingCallViewController(_ vc: IncomingCallViewController!, didReject session: QBRTCSession!) {
        
        session.rejectCall(nil)
        self.dismiss(animated: true, completion:nil)
        self.session = nil
    }
        
    //MARK: - QBWebRTCChatDelegate
    
    func didReceiveNewSession(_ session: QBRTCSession, userInfo: [String : String]? = nil) {
        
        if self.session != nil  {
            
            session.rejectCall(["reject":"busy"])
            
            return
        }
        self.session = session
         let storyboard = UIStoryboard(name: "Main", bundle: nil)
         let incomingCallViewController = storyboard.instantiateViewController(withIdentifier: "IncomingCallViewController") as! IncomingCallViewController
        
        
        let currentUser:QBUUser = ServicesManager.instance().currentUser
        
        let usersDataSource = UsersDataSource.init(currentUser: currentUser)
       // usersDataSource.ids(for: [user!])
        
        incomingCallViewController.delegate = self
        incomingCallViewController.session = session
        incomingCallViewController.usersDatasource =  self.usersDataSource
        
         let navigationContoller = UINavigationController.init(rootViewController: incomingCallViewController)
        
        self.PRESENT_VC(vc: navigationContoller, animated: true)
        
    }
    
    func sessionDidClose(_ session: QBRTCSession) {
        
        if session == self.session {
           
            Alert.CALL_DELAY_INSEC(delay: 1.5, completion: {
                self.view.isUserInteractionEnabled = false
                self.dismiss(animated: true, completion:nil)
                self.session = nil
            })
           
            
               
           
        }
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
