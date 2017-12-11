//
//  NotificationsViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 12/4/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit


class NotificationsViewController: UIViewController, WebServiceDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var arrNot : NSMutableArray! = []
    @IBOutlet var tblNot : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        tblNot.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.getNotifications()
    }
    
    func getNotifications()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_NOTIFICATIONS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_NOTIFICATIONS as NSString)
    }
    
    //MARK:- Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrNot.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! GlobalTableViewCell
        
        let dict : NSDictionary! = arrNot.object(at: indexPath.row) as! NSDictionary
        
        if(dict.value(forKey: "type") as! String == "PostLike" )
        {
            cell.imgPost.af_setImage(withURL: URL(string:((dict.value(forKey: "post") as? NSDictionary)?.value(forKey: "image") as! String))!)
            
            cell.lblName.text = String(format : "%@ liked your post.",dict.value(forKey: "name") as! String)
            
        }
        if( dict.value(forKey: "type") as! String == "PostComment")
        {
            cell.imgPost.af_setImage(withURL: URL(string:((dict.value(forKey: "post") as? NSDictionary)?.value(forKey: "image") as! String))!)
            
            cell.lblName.text = String(format : "%@ commented on your post.",dict.value(forKey: "name") as! String)
            
        }
        
        
   //     cell.lblName.text = dict.value(forKey: "name") as? String
        cell.imgProfile.af_setImage(withURL: URL(string:(dict.value(forKey: "image") as? String)!)!)
        
        cell.imgProfile.roundCorners(corners: UIRectCorner.allCorners, radius: cell.imgProfile.frame.size.width/2)
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let dict : NSDictionary! = arrNot.object(at: indexPath.row) as! NSDictionary

        
        if(dict.value(forKey: "type") as! String == "PostLike" || dict.value(forKey: "type") as! String == "PostComment")
        {
        let moveUserProfileTableViewController = Alert.GET_VIEW_CONTROLLER(identifier: "SinglePostViewController") as! SinglePostViewController
        moveUserProfileTableViewController.strId = (dict.value(forKey: "post") as? NSDictionary)?.value(forKey: "id") as! String
        self.MOVE(vc: moveUserProfileTableViewController, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_GET_NOTIFICATIONS) {
            
            HUD.closeHUD()
            self.arrNot = (jsonResult.object(forKey: "notifications") as? NSArray)?.mutableCopy() as! NSMutableArray
            
            tblNot.reloadData()
            
  
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
