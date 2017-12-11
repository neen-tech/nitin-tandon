//
//  WelcomeToGlimpseViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/12/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class WelcomeToGlimpseViewController: UIViewController {
    
    
    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var labelWelcome:UILabel!
    @IBOutlet weak var buttonDone: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.configView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    
override var preferredStatusBarStyle: UIStatusBarStyle {
   
    return .lightContent
    
    }
    
    //MARK: - Configration
    func configView() {
        
        // Blur Effect on ImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.view.frame
        imageViewBG.addSubview(visualEffectView)
        
        
        let myMutableString = NSMutableAttributedString(
            string: "Welcome to Glimpse!",
            attributes: [:])
        
        myMutableString.addAttribute(
            NSForegroundColorAttributeName,
            value:Alert.colorFromHexString(hexCode:COLOR_CODE.COLOR_APPICON),
            range: NSRange(
                location:10,
                length:8))
        
        labelWelcome.attributedText = myMutableString
        labelWelcome.addBottomBorderWithColor(color: Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_FULNAME_TEXTFIELD_BORDER), width: 0.8)
        
        buttonDone.roundCorners(corners: [.allCorners], radius: buttonDone.frame.size.height/2)
        
        
      //  Alert.showTostMessage(message: "Dashboard module will be in new build", delay: 3.0, controller: self)
        
    }
    
    
    //MARK: - button Actions
    @IBAction func buttonDoneClick(sender: AnyObject) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            self.buttonDone.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            self.buttonDone.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                let newViewController = DashboardViewController()
                
                Alert.appDelegate().setIntialVC(viewController: newViewController)
                
               // Alert.showTostMessage(message: "Dashboard module will be in new build", delay: 3.0, controller: self)
              
            }
            
        })
        
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
