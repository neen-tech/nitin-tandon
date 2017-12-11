//
//  UserLikesViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/15/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class UserLikesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServiceDelegate {
    @IBOutlet var tblList: UITableView!
    var arrList : NSMutableArray! = []
    var strId : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tblList.tableFooterView = UIView()

        self.getLikes()
        // Do any additional setup after loading the view.
    }

    func getLikes()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_LIKE_COMMENTS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject(strId, forKey: USER.kOTHER_USERID as NSCopying)        
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_LIKE_COMMENTS as NSString)
    }
    
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        
        if methodName.isEqual(to: APIMETHOD.kAPI_GET_LIKE_COMMENTS) {
            self.arrList = (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
            
            tblList.reloadData()
            
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
    
    
    //MARK:- Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! GlobalTableViewCell
        
        let dict : NSDictionary! = arrList.object(at: indexPath.row) as! NSDictionary
        
        
        cell.lblName.text = dict.value(forKey: "firstName") as? String
        cell.imgProfile.af_setImage(withURL: URL(string:(dict.value(forKey: "image") as? String)!)!)
        
        cell.imgProfile.roundCorners(corners: UIRectCorner.allCorners, radius: cell.imgProfile.frame.size.width/2)
        
        
        
        return cell
        
        
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
