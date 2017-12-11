//
//  HUD.swift
//  SwiftSamples
//
//  Created by Nitin Kumar on 14/07/17.
//  Copyright © 2017 Nitin Kumar. All rights reserved.
//

import UIKit
import FLAnimatedImage

class HUD: NSObject {

   // ADD HUD
    class func addHud()
    {
       
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
        indicatorView.startAnimating()
        indicatorView.frame = CGRect(x: 0, y: 0, width: 10 , height:10)
        
        indicatorView.backgroundColor = UIColor.clear
        indicatorView.color = UIColor.black
        indicatorView.autoresizesSubviews = true
        indicatorView.autoresizingMask  = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]

        // Centre View
        let viewCentre = UIView(frame:CGRect(x: 0, y: 0, width: 30 , height:30))
        viewCentre.backgroundColor = Alert.colorFromHexString(hexCode: "#FFFFFF")
        
        viewCentre.autoresizesSubviews = true
        viewCentre.autoresizingMask  = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
        
        viewCentre.roundCorners(corners: [.topLeft,.topRight ,.bottomLeft,.bottomRight], radius: 4.0)
        
        // Full Screen View
        let screenSize: CGRect = UIScreen.main.bounds
        let viewHUD = UIView(frame:screenSize)
        viewHUD.tag = -2000
        viewHUD.backgroundColor = UIColor(hex:"#37455F").withAlphaComponent(0.5)
        viewHUD.autoresizesSubviews = true
        viewHUD.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
        indicatorView.center = viewCentre.center
        viewCentre.center = viewHUD.center
        
        viewHUD.addSubview(viewCentre)
        viewCentre.addSubview(indicatorView)
        
    
        let window = UIApplication.shared.keyWindow
        
        window?.addSubview(viewHUD)
        
      //  view.addSubview(viewHUD)
       
        
    }
    
    
    class func addHudWithWithGif()
    {
         let viewBg =  UIView(frame:CGRect(x: 0, y: 0, width: Alert.kSCREEN_WIDTH() , height: Alert.kSCREEN_HEIGHT()))
         viewBg.autoresizingMask = [.flexibleWidth,.flexibleHeight ]
         viewBg.backgroundColor = UIColor.black.withAlphaComponent(0.8)
         viewBg.tag = -2000

        let imageView = FLAnimatedImageView.init(frame: CGRect(x: 0, y: 0, width: 120 , height: 120))
        
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.autoresizesSubviews = true
        imageView.autoresizingMask = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
        
        imageView.center = viewBg.center
        if let path =  Bundle.main.path(forResource: "loader", ofType: "gif") {
            if let data = NSData(contentsOfFile: path) {
                let gif = FLAnimatedImage(animatedGIFData: data as Data!)
                imageView.animatedImage = gif
            }
        }
        
        viewBg.addSubview(imageView)
        //print(data)
    
        let window = UIApplication.shared.keyWindow
        
        window?.addSubview(viewBg)
        
    }
    
    class func addHudWithBlur()
    {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        
        indicatorView.startAnimating()
        indicatorView.frame = CGRect(x: 0, y: 0, width: 10 , height:10)
        
        indicatorView.backgroundColor = UIColor.clear
        indicatorView.color = UIColor.black
        indicatorView.autoresizesSubviews = true
        indicatorView.autoresizingMask  = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
        
        // Centre View
        let viewCentre = UIView(frame:CGRect(x: 0, y: 0, width: 30 , height:30))
        viewCentre.backgroundColor = Alert.colorFromHexString(hexCode: "#FFFFFF")
        
        viewCentre.autoresizesSubviews = true
        viewCentre.autoresizingMask  = [.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleBottomMargin]
        
        viewCentre.roundCorners(corners: [.topLeft,.topRight ,.bottomLeft,.bottomRight], radius: 4.0)
        
        
         // Full Screen View
        let screenSize: CGRect = UIScreen.main.bounds
        //var viewHUD = UIView(frame:screenSize)
       // viewHUD.tag = -2000
        
        let viewHUD = UIBlurEffect.init(style: .extraLight)
        let visualEffectView = UIVisualEffectView.init(effect: viewHUD)
        visualEffectView.frame = screenSize
        visualEffectView.isUserInteractionEnabled = true
        visualEffectView.autoresizingMask = [.flexibleWidth,.flexibleHeight ]
        visualEffectView.tag = -2000
        
        indicatorView.center = viewCentre.center
        viewCentre.center = visualEffectView.center
        viewCentre.addSubview(indicatorView)
        visualEffectView.addSubview(viewCentre)

        let window = UIApplication.shared.keyWindow
        
        window?.addSubview(visualEffectView)
        
        
    }
    
    // CLOSE HUD
    class func closeHUD()
    {
        DispatchQueue.main.async  {
            let window = UIApplication.shared.keyWindow
            window?.viewWithTag(-2000)?.removeFromSuperview()
        }
        
    }
    
    
    
    
}
