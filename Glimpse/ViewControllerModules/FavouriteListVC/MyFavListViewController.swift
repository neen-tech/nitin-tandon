//
//  MyFavListViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/14/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class MyFavListViewController: UIViewController,WebServiceDelegate, UITableViewDelegate, UITableViewDataSource {

    var arrList : NSMutableArray! = []
    @IBOutlet var tblList : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getFavList()
        // Do any additional setup after loading the view.
    }

    //MARK: -  Get Profile Details
    func getFavList()
    {
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_MY_FAVOURITE_LIST, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_MY_FAVOURITE_LIST as NSString)
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_MY_FAVOURITE_LIST) {
            
            HUD.closeHUD()
            self.arrList = (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
           
                tblList.reloadData()
            
//            imgVideoThumbnail.af_setImage(withURL: URL(string:(arrVideos[0] as! NSDictionary).value(forKey: "thumb") as! String)!)
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_MAKE_FAVOURITE) {
            
            print(jsonResult)
            self.getFavList()
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
        cell.lblEmail.text = dict.value(forKey: "emailId") as? String
   
        if(dict.value(forKey: "image") as? String != "")
        {
            
        cell.imgProfile?.af_setImage(withURL: URL(string: (dict.value(forKey: "image") as? String)!)!)
            
        }
        
        cell.imgProfile.roundCorners(corners: UIRectCorner.allCorners, radius: 20)
        
        
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
   
        
        let deleteAction = UITableViewRowAction(style: .default, title: "Remove", handler: { (action, indexPath) in
            self.RemoveFav(_sender: indexPath.row)

        })
        
        return [deleteAction]
    }
    
    func RemoveFav(_sender : Int)
    {
        
        let dictFav : NSDictionary! = arrList.object(at: _sender) as! NSDictionary

        Alert.showTostMessage(message: "Removed Favourite", delay: 1.0, controller: self)
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_MAKE_FAVOURITE, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        dict.setObject(dictFav.value(forKey: "id") as! String, forKey: USER.kOTHER_USERID as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_MAKE_FAVOURITE as NSString)
        
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
