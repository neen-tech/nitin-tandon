//
//  SeekingViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/9/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class SeekingViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK: - VARIBALE, OBJECTS,
    
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var tableViewGender: UITableView!
    var strIAmData:String!
    var arrayGender = NSArray()
    
     //MARK: - VIEW BASE LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //CONFIG
        
        self.configView()
        
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Configration
    func configView() {
        
        // Blur Effect on ImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.view.frame
        imageViewBG.addSubview(visualEffectView)
        
        // TableView Config
        
        self.tableViewGender.tableFooterView = UIView.init()
        self.tableViewGender.dataSource = self
        self.tableViewGender.delegate = self
        
        // ARRAY ALLOCATION
        
        self.arrayGender = NSArray.init(objects: "Male","Female")
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //   //MARK: - UITableView DELEGATE, DATASOURCES
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return  self.arrayGender.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeekingCell", for: indexPath) as! GlobalTableViewCell
        
        let gender = self.arrayGender.object(at: indexPath.row) as! String
        
        cell.labelGender.text = gender
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fullNameViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_FULLNAME_PICKING_VC as NSString) as! FullNameViewController
        fullNameViewController.strIAmData = self.strIAmData
        fullNameViewController.strSeekingData = self.arrayGender.object(at: indexPath.row) as! String
        self.MOVE(vc: fullNameViewController, animated: true)
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

