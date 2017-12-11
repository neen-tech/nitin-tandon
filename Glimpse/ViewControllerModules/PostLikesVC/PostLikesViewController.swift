//
//  PostLikesViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 12/1/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class PostLikesViewController: UIViewController, WebServiceDelegate, UITableViewDelegate, UITableViewDataSource {

    var dictDetail : NSDictionary!
    var arrUsers : NSMutableArray! = []
    @IBOutlet var tblUsers : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getPostLikes()
        self.tabBarController?.navigationController?.isNavigationBarHidden = true
        self.navigationController?.isNavigationBarHidden = false
        self.title = "LIKES"
        // Do any additional setup after loading the view.
    }

    func getPostLikes()
    {
        
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_POST_LIKE_USERS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject("1", forKey: "type" as NSCopying)
        
        dict.setObject((dictDetail.value(forKey: "Post") as! NSDictionary).value(forKey: "id") as! String, forKey: "postId" as NSCopying)

        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_POST_LIKE_USERS as NSString)
    }
    
    //MARK:- Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! GlobalTableViewCell
        
        let dict : NSDictionary! = arrUsers.object(at: indexPath.row) as! NSDictionary
        
        
        cell.lblName.text = dict.value(forKey: "firstName") as? String
        cell.imgProfile.af_setImage(withURL: URL(string:(dict.value(forKey: "image") as? String)!)!)
        
        cell.imgProfile.roundCorners(corners: UIRectCorner.allCorners, radius: cell.imgProfile.frame.size.width/2)
        
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_GET_POST_LIKE_USERS) {
            
            HUD.closeHUD()
            self.arrUsers = (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
            
            tblUsers.reloadData()
            
          
            
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
