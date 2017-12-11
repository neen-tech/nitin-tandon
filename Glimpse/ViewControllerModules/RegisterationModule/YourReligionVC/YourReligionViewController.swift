//
//  YourReligionViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/12/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class YourReligionViewController: UIViewController ,UITableViewDataSource,UITableViewDelegate, WebServiceDelegate {
    
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var tableViewReligion: UITableView!
    
    
    var arrayReligion = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.configView()
        self.getOptions()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func getOptions()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_OPTIONS_BY_QUESTION, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject("What's Your Religion?", forKey: USER.kQUESTION as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_OPTIONS_BY_QUESTION as NSString)
    }
    
    
    //MARK: - Configration
    func configView() {
        
        // Blur Effect on ImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.view.frame
        imageViewBG.addSubview(visualEffectView)
        
        // TableView Config
        
        self.tableViewReligion.tableFooterView = UIView.init()
        self.tableViewReligion.dataSource = self
        self.tableViewReligion.delegate = self
        
        // ARRAY ALLOCATION
        
    
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //   //MARK: - UITableView DELEGATE, DATASOURCES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.arrayReligion.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReligionCell", for: indexPath) as! GlobalTableViewCell
        
        let religion = self.arrayReligion.object(at: indexPath.row) as! NSDictionary
        
        cell.labelGender.text = religion.value(forKey: "name") as! String
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let body = self.arrayReligion.object(at: indexPath.row) as! NSDictionary
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_UPDATE_ADVANCE_OPTION, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        dict.setObject(body.value(forKey: "id") as! String, forKey: "optionId" as NSCopying)
        dict.setObject(body.value(forKey: "type_id") as! String, forKey: "typeId" as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_UPDATE_ADVANCE_OPTION as NSString)
        
        
       
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_GET_OPTIONS_BY_QUESTION) {
            
            self.arrayReligion = (jsonResult.object(forKey: EXTRA.kAPI_OPTIONS as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
            
            tableViewReligion.reloadData()
            
        }
        else if methodName.isEqual(to: APIMETHOD.kAPI_UPDATE_ADVANCE_OPTION) {
            
            
            let doYouSmokeViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_YOU_SMOKE_VC as NSString) as! DoYouSmokeViewController
            
            self.MOVE(vc: doYouSmokeViewController, animated: true)
        }
        //
        
        
        
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
