//
//  SearchModuleVC.swift
//  Glimpse
//
//  Created by Rameshwar on 10/10/17.
//  Copyright © 2017 Nitin. All rights reserved.

// Is it possible ki aap hume 17 ko release kr de instead of 20?
//

import UIKit
import AlamofireImage

class SearchModuleVC: UIViewController, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, WebServiceDelegate {
    
    
    var searchBar = UISearchBar ()
    let tableView: UITableView = UITableView()
    var page : Int! = 0
    var totalPages : Int! = 0
    var arrList : NSMutableArray! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_BG_COLOR)
        
        loadCustomiseNavBar()
        loadTableView()
        loadCustomiseSearchBar()
        
    }
    
    //MARK: -  Get Profile Details
    func getSearchUsers(str: String!)
    {
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_QUICK_SEARCH, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject(str, forKey: "searchkey" as NSCopying)
    //    dict.setObject(page, forKey: "page" as NSCopying)
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_QUICK_SEARCH as NSString)
    }
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_QUICK_SEARCH) {
            
            DispatchQueue.main.async() {
                
                
             //   self.totalPages = jsonResult.object(forKey: "totalPage") as! Int
                self.arrList.addObjects(from: jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray as! [Any])
                
                self.tableView.reloadData()
               
                
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
    
    
    func loadCustomiseNavBar() -> Void {
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = Alert.colorFromHexString(hexCode: COLOR_CODE.NAVCOLOR)
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        self.navigationController?.navigationBar.tintColor = .white
        
        // Nav Button Cancel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        
        
        // Nav Button Logout
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(hitLogout))
        
        
        // Nav Image
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        imageView.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2-50, y: 0, width: 100, height: 45)
        self.navigationController?.navigationBar.addSubview(imageView)
        
    }
    
    // MARK: loadTableView
    
    func loadTableView() -> Void {
        
       
        tableView.frame = CGRect(x: 0, y: 56, width: Alert.kSCREEN_WIDTH(), height: Alert.kSCREEN_HEIGHT() - (56+65))
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.NAVCOLOR)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        self.view.addSubview(tableView)
        
    }
    
    // MARK: loadSearchConfigView
    
    
    //MARK: - load customise searchbar...
    func loadCustomiseSearchBar()
    {
        self.searchBar                   = UISearchBar.init(frame: CGRect(x:0, y:0, width:Alert.kSCREEN_WIDTH(),height: 56))
        self.searchBar.placeholder = "Search Here..."
        self.searchBar.backgroundColor   = .clear
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        let textFieldInsideSearchBar = self.searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.textAlignment = .center
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        textFieldInsideSearchBarLabel?.textAlignment = .center
        self.view.addSubview(self.searchBar)
    }

    
    
    
    // MARK: hitLogout
    
    @objc func hitLogout(sender: UIBarButtonItem!) {
        
        
        
    }
    
    // MARK: goBack
    
    @objc func goBack(sender: UIBarButtonItem!){
        self.navigationController?.popViewController(animated: true)
        
    }
    // MARK: Table View Cell Delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        NSLog("sections")
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return arrList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        let dict : NSDictionary = arrList.object(at: indexPath.row) as! NSDictionary
        
        cell.backgroundColor = .clear
        
        let gradientView = UIView(frame: CGRect(x:0, y:0, width:Alert.kSCREEN_WIDTH(), height:200))
        gradientView.backgroundColor = .clear
        cell.addSubview(gradientView)
        
        
        let gradientLayer:CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x:0, y:gradientView.frame.size.height-50, width:Alert.kSCREEN_WIDTH(), height:50)
        gradientLayer.colors =
        [UIColor.clear.cgColor,UIColor.black.withAlphaComponent(0.1).cgColor]
       gradientView.layer.addSublayer(gradientLayer)
        
        
        let borderImageView = UIImageView(image:#imageLiteral(resourceName: "profileborderbold"))
        borderImageView.frame = CGRect(x:Alert.kSCREEN_WIDTH()/2-90, y:10, width:180, height:180)
        borderImageView.layer.cornerRadius = 90;
        borderImageView.clipsToBounds = true
        borderImageView.backgroundColor = .white
        gradientView.addSubview(borderImageView)
        
        let profileImageView = UIImageView()
        profileImageView.frame = CGRect(x:15, y:15, width:150, height:150)
        profileImageView.layer.cornerRadius = 75;
        profileImageView.clipsToBounds = true
        profileImageView.af_setImage(withURL: URL(string: dict.value(forKey: "image") as! String)!)
        profileImageView.backgroundColor = .red
        borderImageView.addSubview(profileImageView)
      
        
        let lblUserName = UILabel(frame: CGRect(x:Alert.kSCREEN_WIDTH()-150, y:10, width:140, height:40))
        
        lblUserName.text = dict.value(forKey: "firstName") as! String
        
        lblUserName.font = UIFont(name:"HelveticaNeue-Light", size:20)
        lblUserName.textColor = .white
        lblUserName.textAlignment = NSTextAlignment.right
        gradientView.addSubview(lblUserName)
        
        
        
        let btnSearchView = UIButton(frame:CGRect(x:Alert.kSCREEN_WIDTH()-90, y:gradientView.frame.size.height-80, width:80, height:80))
        btnSearchView.backgroundColor = .clear
        btnSearchView.setImage(#imageLiteral(resourceName: "message"), for: .normal)
        btnSearchView.imageEdgeInsets = UIEdgeInsetsMake(-30, 20, 0, 0)
        btnSearchView.titleEdgeInsets = UIEdgeInsetsMake(-30, -30, -70, 0)
        btnSearchView.titleLabel?.font = UIFont(name:"HelveticaNeue-Light", size: 20)
        btnSearchView.setTitle("Message", for: .normal)
        gradientView.addSubview(btnSearchView)
        
        
        
        let btnDelete = UIButton(frame:CGRect(x:20, y:gradientView.frame.size.height-60, width:50, height:50))
        btnDelete.backgroundColor = .clear
        btnDelete.setImage(#imageLiteral(resourceName: "error"), for: .normal)
        btnDelete.addTarget(self, action: #selector(deletserFromList), for: .touchUpInside)
        gradientView.addSubview(btnDelete)
        btnDelete.tag = indexPath.row
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 220
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let moveUserProfileTableViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_USER_PROFILE_VC as NSString) as! UserProfileTableViewController
        moveUserProfileTableViewController.strId = (arrList[indexPath.row] as! NSDictionary).value(forKey: "id") as! String
        self.MOVE(vc: moveUserProfileTableViewController, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if indexPath.row + 1 == arrList.count {
//            if(page < totalPages)
//            {
//                page = page+1
//            self.getSearchUsers(str: self.searchBar.text, page: page)
//                
//            }
//        }
//    }
    
    
    
    // MARK : Search Bar Delegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text != "")
        {
            arrList.removeAllObjects()
          //  page = 1
            self.getSearchUsers(str: searchText)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        print("searching print data")
        
    }
    
    @objc func deletserFromList(sender:UIButton!){
       
        let btnSender = sender
        print("row number deleted", btnSender?.tag ?? 0)
        
    }

}
