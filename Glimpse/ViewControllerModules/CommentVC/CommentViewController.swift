//
//  CommentViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/15/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WebServiceDelegate, UITextViewDelegate {

    @IBOutlet var viewComment : UIView!
    @IBOutlet var txtComment : UITextView!
    @IBOutlet var tblList: UITableView!
    @IBOutlet var btnComment: UIButton!

    var arrList : NSMutableArray! = []
    var strId : String!
    var strUser : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewComment.addTopBorderWithColor(color: UIColor.black, width: 0.3)
        
        tblList.tableFooterView = UIView()

        if(strUser == "yes")
        {
        self.getComments()
            btnComment.addTarget(self, action: #selector(self.commentClick), for: UIControlEvents.touchUpInside)
        }
        else
        {
            self.tabBarController?.navigationController?.isNavigationBarHidden = true
            self.navigationController?.isNavigationBarHidden = false
            self.title = "COMMENTS"
            btnComment.addTarget(self, action: #selector(self.commentOnPostClick), for: UIControlEvents.touchUpInside)
            self.getpostComments()
        }
        // Do any additional setup after loading the view.
    }

    func getComments()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_LIKE_COMMENTS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject(strId, forKey: USER.kOTHER_USERID as NSCopying)
        dict.setObject("comments" , forKey: "type" as NSCopying)
        
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_LIKE_COMMENTS as NSString)
    }
    func getpostComments()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_POST_LIKE_USERS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject(strId, forKey: "postId" as NSCopying)
        dict.setObject("2", forKey: "type" as NSCopying)

        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_POST_LIKE_USERS as NSString)
    }
    @IBAction func commentClick()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_LIKE_COMMENT_PROFILE, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject(strId, forKey: USER.kOTHER_USERID as NSCopying)
        dict.setObject(txtComment.text! , forKey: "comments" as NSCopying)
   
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_LIKE_COMMENT_PROFILE as NSString)
    }
    @IBAction func commentOnPostClick()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_COMMENT_ON_POST, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject(strId, forKey: "postId" as NSCopying)
        dict.setObject(txtComment.text! , forKey: "comment" as NSCopying)
        dict.setObject("2" , forKey: "type" as NSCopying)

        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_COMMENT_ON_POST as NSString)
    }
    
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_LIKE_COMMENT_PROFILE) {
            
            HUD.closeHUD()
            
            txtComment.text = "Comment..."
            txtComment.resignFirstResponder()
            self.getComments()
            Alert.showTostMessage(message:"Commented Successfully", delay: 2.0, controller: self)

            
       //     self.navigationController?.popViewController(animated: true)
            
        }
        else  if methodName.isEqual(to: APIMETHOD.kAPI_COMMENT_ON_POST) {
            
            HUD.closeHUD()
            
            txtComment.text = "Comment..."
            txtComment.resignFirstResponder()
            self.getpostComments()
            Alert.showTostMessage(message:"Commented Successfully", delay: 2.0, controller: self)
            
            
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_GET_LIKE_COMMENTS) {
            self.arrList = (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
            
            tblList.reloadData()
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_GET_POST_LIKE_USERS) {
            self.arrList = (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
            
            tblList.reloadData()
            
        }    }
    
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
         cell.txt.text = dict.value(forKey: "comments") as? String
        cell.imgProfile.af_setImage(withURL: URL(string:(dict.value(forKey: "image") as? String)!)!)
        
        cell.imgProfile.roundCorners(corners: UIRectCorner.allCorners, radius: cell.imgProfile.frame.size.width/2)
        
        cell.txt.isScrollEnabled = false
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict : NSDictionary! = arrList.object(at: indexPath.row) as! NSDictionary

        
        
        
        let strHeight = (dict.value(forKey: "comments") as? String)?.height(withConstrainedWidth: self.view.frame.size.width-100, font: UIFont.systemFont(ofSize: 15))
        
        if((CGFloat)(strHeight!) < (CGFloat)(50))
        {
            return 100
        }
        else
        {
        return  strHeight!+50
        }
    }
    
    
    //MARK: Text View Delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Comment...")
        {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == "")
        {
            textView.text = "Comment..."
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
