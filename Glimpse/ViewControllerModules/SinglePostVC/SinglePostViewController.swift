//
//  SinglePostViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 12/4/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class SinglePostViewController: UIViewController,WebServiceDelegate {
    @IBOutlet var imgProfile : UIImageView!
    @IBOutlet var lblLikes : UIButton!
    @IBOutlet var lblName : UILabel!
    @IBOutlet var lblEmail : UILabel!
    @IBOutlet var imgPost : UIImageView!
    @IBOutlet var lblTotalComments : UILabel!
    @IBOutlet var btnLike : UIButton!
    @IBOutlet var btnComment : UIButton!
    @IBOutlet var lblText : UILabel!
    @IBOutlet var imgPlay : UIImageView!
    
    var strId : String!
    
    var dictDetails : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getPostDetails()
       
        
        
        // Do any additional setup after loading the view.
    }
    func CommentList(sender : UIButton!)
    {
        
        let moveUserProfileTableViewController = Alert.GET_VIEW_CONTROLLER(identifier: "CommentViewController") as! CommentViewController
        moveUserProfileTableViewController.strId = (dictDetails.value(forKey: "Post") as! NSDictionary).value(forKey: "id") as! String
        moveUserProfileTableViewController.strUser = "no"
        self.MOVE(vc: moveUserProfileTableViewController, animated: true)
        
    }
    func LikeList(sender : UIButton!)
    {
        
        let moveUserProfileTableViewController = Alert.GET_VIEW_CONTROLLER(identifier: "PostLikesViewController") as! PostLikesViewController
        moveUserProfileTableViewController.dictDetail = dictDetails
        self.MOVE(vc: moveUserProfileTableViewController, animated: true)
        
    }
    func LikePost(sender : UIButton!)
    {
        let dict1: NSDictionary! = dictDetails
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_COMMENT_ON_POST, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject((dict1.value(forKey: "Post") as! NSDictionary).value(forKey: "id") as! String, forKey: "postId" as NSCopying)
        dict.setObject("1", forKey: "type" as NSCopying)
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_LIKE_ON_POST as NSString)
    }
    
    func getPostDetails()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_POST_DETAILS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject(strId!, forKey: "postId" as NSCopying)
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_POST_DETAILS as NSString)

    }
    
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
   if methodName.isEqual(to: APIMETHOD.kAPI_GET_POST_DETAILS)
   {
    
    dictDetails =  jsonResult.object(forKey: EXTRA.kAPI_RESPONSE) as! NSDictionary
        self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
    self.imgProfile.af_setImage(withURL: URL(string:(dictDetails.value(forKey: "User") as! NSDictionary ).value(forKey: USER.kUSER_IMAGE) as! String)!)
        self.lblName.text = (dictDetails.value(forKey: "User") as! NSDictionary ).value(forKey: USER.kUSER_FIRST_NAME) as? String
        
        if(dictDetails.value(forKey: "isLikeByMe") as! String == "No")
        {
        self.btnLike.setImage(UIImage(named:"lineheart"), for: UIControlState.normal)
        }
        else
        {
        self.btnLike.setImage(UIImage(named:"hearts"), for: UIControlState.normal)
        }
        
        
        
        
        if(dictDetails.value(forKey: "image") as! String != "")
        {
        
        self.imgPost.af_setImage(withURL: URL(string:dictDetails.value(forKey: "image") as! String)!)
        }
        else
        {
        self.imgPost.image = UIImage(named: "user")
        }
        self.lblLikes.addTopBorderWithColor(color: .gray, width: 0.5)
        
        if(dictDetails.value(forKey: "type") as! String == "2")
        {
        self.imgPlay.isHidden = true
        }
        else
        {
        self.imgPlay.isHidden = false
        
        }
        self.lblText.text = dictDetails.value(forKey: "content") as? String
        self.lblTotalComments.text = String(format:"View all %@ comments",dictDetails.value(forKey: "totalComments") as! String)
        self.lblLikes.setTitle(String(format:" %@ Likes",dictDetails.value(forKey: "TotalLike") as! String), for: UIControlState.normal)
        
        self.btnLike.addTarget(self, action: #selector(self.LikePost(sender:)), for: UIControlEvents.touchUpInside)
        
        
        self.lblLikes.addTarget(self, action: #selector(self.LikeList(sender:)), for: UIControlEvents.touchUpInside)
        
        self.btnComment.addTarget(self, action: #selector(self.CommentList(sender:)), for: UIControlEvents.touchUpInside)
        }
       else  if methodName.isEqual(to: APIMETHOD.kAPI_LIKE_ON_POST) {
            
            print(jsonResult)
            self.getPostDetails()
    
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
