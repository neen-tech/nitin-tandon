//
//  HintSchoolClassView.swift
//  Wallopp
//
//  Created by Nitin on 9/27/17.
//  Copyright © 2017 Nitin Kumar. All rights reserved.
//

import UIKit


class HintSchoolClassView: NSObject {
    
    
    var blurEffect = UIBlurEffect()
    var blurEffectView = UIVisualEffectView()
    var labelMessage = UILabel()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    func draw() {
        // Drawing code
        
        
        // Blur view
        
        blurEffect = UIBlurEffect.init(style: .dark)
        blurEffectView = UIVisualEffectView.init(effect: blurEffect)
        blurEffectView.frame = CGRect(x: 0, y: 0, width: Alert.kSCREEN_WIDTH() , height:Alert.kSCREEN_HEIGHT())
        blurEffectView.tag = 111
        blurEffectView.isUserInteractionEnabled  = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // Add ImageView on BlurView
        
        let imageViewOneHand = UIImageView.init(frame: CGRect(x: Alert.kSCREEN_WIDTH() - 100, y: 80, width: 64 , height:64))
        imageViewOneHand.image = #imageLiteral(resourceName: "one-finger-swipe-to-left-black-hand-symbol")
        blurEffectView.contentView.addSubview(imageViewOneHand)
        
        
        // ImageView Arraow
        
        let imageViewArrow = UIImageView.init(frame: CGRect(x: Alert.kSCREEN_WIDTH() - 120, y: imageViewOneHand.frame.origin.y + imageViewOneHand.frame.size.height+6, width: 64 , height:64))
        
        imageViewArrow.image = #imageLiteral(resourceName: "arrow_hints")
        blurEffectView.contentView.addSubview(imageViewArrow)
        
        //Label Message
        labelMessage = UILabel.init(frame: CGRect(x: 50, y: imageViewArrow.frame.origin.y+imageViewArrow.frame.size.height+5, width: Alert.kSCREEN_WIDTH() - 100 , height:100))
        
        labelMessage.textColor = .white
        labelMessage.text      = "Swipe left to Delete and Edit a class. !"
        labelMessage.textAlignment = .center
        labelMessage.font      = UIFont.init(name: "Palatino-Italic", size: 24)
        labelMessage.numberOfLines = 0
        blurEffectView.contentView.addSubview(labelMessage)
        
        
        let okButton = UIButton.init(type: .custom)
        okButton.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2 - 50, y: Alert.kSCREEN_HEIGHT() - 110, width: 100 , height:100)
        okButton.setTitle("OK", for: .normal)
        okButton.titleLabel?.textColor = .white
        okButton.backgroundColor = .clear
        okButton.titleLabel?.font = UIFont.init(name: "Palatino-Italic", size: 24)
        okButton.addTarget(self, action: #selector(HintSchoolClassView.buttonOKClick), for: .touchUpInside)
        
        okButton.roundCorners(corners: .allCorners, radius: okButton.frame.size.height/2)
        /*
        //Label OK
        let labelOK = UILabel.init(frame: CGRect(x: Alert.kSCREEN_WIDTH()/2 - 50, y: Alert.kSCREEN_HEIGHT() - 110, width: 100 , height:100))
        labelOK.textAlignment = .center
        labelOK.text = "OK"
        labelOK.textColor = .white
        labelOK.font      = UIFont.init(name: "Palatino-Italic", size: 24)
        labelOK.roundCorners(corners: .allCorners, radius: labelOK.frame.size.height/2)
         */
        
        blurEffectView.contentView.addSubview(okButton)
        
        // Gesture on BlurView
        
       let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGesture1Click(sender:)))
        blurEffectView.isUserInteractionEnabled = true
        blurEffectView.contentView.addGestureRecognizer(tapGesture)
        
        

       blurEffectView.tag = 111
       let window = UIApplication.shared.keyWindow
        window?.addSubview(blurEffectView)
      
        
    }
    
     @objc func tapGesture1Click(sender:UITapGestureRecognizer)
    {
       
        
        let window = UIApplication.shared.keyWindow
        window?.viewWithTag(111)?.removeFromSuperview()
    }
    
    // Tap Gesture Click
    @objc class func buttonOKClick(){
        
        let window = UIApplication.shared.keyWindow
        window?.viewWithTag(111)?.removeFromSuperview()
        
        
    }

}
