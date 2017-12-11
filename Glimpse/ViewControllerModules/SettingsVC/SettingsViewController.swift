//
//  SettingsViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/14/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var arrList : NSMutableArray! = ["My Profile","Change Password"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK:- Table View Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath as IndexPath)
        

        cell.textLabel?.text = arrList[indexPath.row] as? String
        
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 0)
        {
            let moveUserProfileTableViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_USER_PROFILE_VC as NSString) as! UserProfileTableViewController
            moveUserProfileTableViewController.strId = (UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as? String
            self.MOVE(vc: moveUserProfileTableViewController, animated: true)
        }
        if(indexPath.row == 1)
        {
            let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
            
            
            let glimpleViewController : UIViewController = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
            
            self.navigationController?.pushViewController(glimpleViewController, animated: true)
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
