//
//  YourGlimpseViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/8/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class YourGlimpseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource, UICollectionViewDelegate,WebServiceDelegate {
    var player : AVPlayer?
    let controller=AVPlayerViewController()
    var arrPosts : NSMutableArray! = []
    @IBOutlet var tblPosts : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

     

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
        self.getPosts()
    }
    
    func getPosts()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_POST, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_POST as NSString)
    }
    
    
    
    
    // MARK :- Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
              let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath as IndexPath) as! UserCollectionViewCell
       
        cell.imageViewProfile.layer.cornerRadius = cell.imageViewProfile.frame.size.width/2
        
        if(indexPath.row != 0)
        {
            cell.imgPlus.isHidden = true
            cell.imgBorder.isHidden = false
        }
        else
        {
            cell.imgPlus.isHidden = false
            cell.imgBorder.isHidden = true
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            let glimpleViewController : VideoViewController = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            let navigationController  = UINavigationController.init(rootViewController: glimpleViewController)
            self.PRESENT_VC(vc: navigationController, animated: true)
            
            
            break
        default:
            break
        }
    }
    
    
    
    
    //MARK: - Tableview Datasources and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrPosts.count
    }
    

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! YourGlimpseTableViewCell
        
        let dict : NSDictionary! = arrPosts.object(at: indexPath.row) as! NSDictionary
        
        
        
       cell.imgProfile.layer.cornerRadius = cell.imgProfile.frame.size.width/2
        cell.imgProfile.af_setImage(withURL: URL(string:((dict.value(forKey: "Post") as! NSDictionary).value(forKey: "User") as! NSDictionary ).value(forKey: USER.kUSER_IMAGE) as! String)!)
        cell.lblName.text = ((dict.value(forKey: "Post") as! NSDictionary).value(forKey: "User") as! NSDictionary ).value(forKey: USER.kUSER_FIRST_NAME) as? String
        
        if((dict.value(forKey: "Post") as! NSDictionary).value(forKey: "isLikeByMe") as! String == "No")
        {
           cell.btnLike.setImage(UIImage(named:"lineheart"), for: UIControlState.normal)
        }
        else
        {
            cell.btnLike.setImage(UIImage(named:"hearts"), for: UIControlState.normal)
        }
        
        
        
        
        if((dict.value(forKey: "Post") as! NSDictionary).value(forKey: "image") as! String != "")
        {
        
        cell.imgPost.af_setImage(withURL: URL(string:(dict.value(forKey: "Post") as! NSDictionary).value(forKey: "image") as! String)!)
        }
        else
        {
            cell.imgPost.image = UIImage(named: "user")
        }
        cell.lblLikes.addTopBorderWithColor(color: .gray, width: 0.5)
        
    if((dict.value(forKey: "Post") as! NSDictionary).value(forKey: "type") as! String == "2")
    {
        cell.imgPlay.isHidden = true
        }
        else
    {
        cell.imgPlay.isHidden = false

        }
        cell.lblText.text = (dict.value(forKey: "Post") as! NSDictionary).value(forKey: "content") as? String
        cell.lblTotalComments.text = String(format:"View all %@ comments",(dict.value(forKey: "Post") as! NSDictionary).value(forKey: "totalComments") as! String)
        cell.lblLikes.setTitle(String(format:" %@ Likes",(dict.value(forKey: "Post") as! NSDictionary).value(forKey: "TotalLikes") as! String), for: UIControlState.normal)
        
        cell.btnLike.addTarget(self, action: #selector(self.LikePost(sender:)), for: UIControlEvents.touchUpInside)
        cell.btnLike.tag = indexPath.row
        
        
        cell.lblLikes.addTarget(self, action: #selector(self.LikeList(sender:)), for: UIControlEvents.touchUpInside)
        cell.lblLikes.tag = indexPath.row

        cell.btnComment.addTarget(self, action: #selector(self.CommentList(sender:)), for: UIControlEvents.touchUpInside)
        cell.btnComment.tag = indexPath.row
        
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath) as! YourGlimpseTableViewCell

        
        let dict: NSDictionary! = arrPosts.object(at: indexPath.row) as! NSDictionary
        
        
        
        if((dict.value(forKey: "Post") as! NSDictionary).value(forKey: "type") as! String == "3")
        {
            self.tabBarController?.navigationController?.isNavigationBarHidden = true
            self.navigationController?.isNavigationBarHidden = false
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(named: "error"), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn1.addTarget(self, action: #selector(self.closeVideo), for: .touchUpInside)
            let item1 = UIBarButtonItem(customView: btn1)
            
            self.navigationItem.setLeftBarButtonItems([item1], animated: true)

            self.title = "VIDEO"

        player = AVPlayer(url:  URL(string: (dict.value(forKey: "Post") as! NSDictionary).value(forKey: "video") as! String)!)
        
        controller.player=player
            if #available(iOS 11.0, *) {
                controller.entersFullScreenWhenPlaybackBegins = true
            } else {
                // Fallback on earlier versions
            }
        controller.view.frame = self.view.frame
        
        self.view.addSubview(controller.view)
        self.addChildViewController(controller)
        
        player?.play()
        }
    }
    func closeVideo()
    {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.navigationController?.isNavigationBarHidden = false
        
        controller.view.removeFromSuperview()
        player?.pause()
        player = nil

        
    }
    func CommentList(sender : UIButton!)
    {
        
        let moveUserProfileTableViewController = Alert.GET_VIEW_CONTROLLER(identifier: "CommentViewController") as! CommentViewController
        moveUserProfileTableViewController.strId = ((arrPosts[sender.tag] as! NSDictionary).value(forKey: "Post") as! NSDictionary).value(forKey: "id") as! String
        moveUserProfileTableViewController.strUser = "no"
        self.MOVE(vc: moveUserProfileTableViewController, animated: true)
        
    }
    func LikeList(sender : UIButton!)
    {
        
        let moveUserProfileTableViewController = Alert.GET_VIEW_CONTROLLER(identifier: "PostLikesViewController") as! PostLikesViewController
        moveUserProfileTableViewController.dictDetail = arrPosts[sender.tag] as! NSDictionary
        self.MOVE(vc: moveUserProfileTableViewController, animated: true)
        
    }
    func LikePost(sender : UIButton!)
    {
        let dict1: NSDictionary! = arrPosts.object(at: sender.tag) as! NSDictionary

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
    
    
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_GET_POST) {
            
            HUD.closeHUD()
            self.arrPosts = (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
            
            tblPosts.reloadData()
            
            //            imgVideoThumbnail.af_setImage(withURL: URL(string:(arrVideos[0] as! NSDictionary).value(forKey: "thumb") as! String)!)
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_LIKE_ON_POST) {

            print(jsonResult)
            self.getPosts()
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
