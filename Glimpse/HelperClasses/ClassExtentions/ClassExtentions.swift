//
//  ClassExtentions.swift
//  SwiftSamples
//
//  Created by Nitin Kumar on 13/06/17.
//  Copyright © 2017 Nitin Kumar. All rights reserved.
//

import Foundation
import UIKit

// MARK: - UIViewController Extentions
extension UIViewController
{
    func MOVE(vc:UIViewController, animated:Bool){
        
    self.navigationController?.pushViewController(vc, animated:animated )
    }
    
    func BACK(animated:Bool){
        
    self.navigationController?.popViewController(animated: animated);
    }
    
    func BACK_TO_ROOT(animated:Bool)  {
    
    self.navigationController?.popToRootViewController(animated: animated)
    }
    
    func PRESENT_VC(vc:UIViewController, animated:Bool) {
        
        self.present(vc, animated: animated) { 
            
        }
    }
    func PRESENT_FROM_NAV(vc:UIViewController, animated:Bool)  {
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func DISMISS(animated:Bool)
    {
        self.dismiss(animated: animated) { 
            
        }
    }
    
    func DISMISS_VC_NAV(animated:Bool)
    {
        self.navigationController?.dismiss(animated: animated, completion: { 
            
        })
    }

    
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
// MARK: - UINavigationController Extentions
extension UINavigationController
{
    //MARK: - make root controller
    
    func NAVIGATION_MAKE_ROOT_VC(vc:UIViewController) -> UINavigationController {
        
       let nav = UINavigationController(rootViewController: vc)
    
        return nav
    }
}

//MARK: - VIEW EXTENTIONS
extension UIView {
    
    //MARK: - addShadow ON UIVIEW
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowPath = UIBezierPath.init(roundedRect: layer.bounds, cornerRadius: layer.cornerRadius).cgPath
        
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
    
    
    //MARK: - addTopBorderWithColor ON UIVIEW
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    //MARK: - addRightBorderWithColor ON UIVIEW
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    //MARK: - addBottomBorderWithColor ON UIVIEW
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    //MARK: - addLeftBorderWithColor ON UIVIEW
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        
        // ========= Uses this methods==========
        // viewHeader.roundCorners(corners: [.topLeft, .bottomLeft], radius: 4.0)
    }
    
    
}

//MARK: - CALAYER Border on view
extension CALayer
{
     //MARK: - addBorder ON UIVIEW
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge
        {
        case UIRectEdge.top:
            border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect.init(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect.init(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
            break
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        self.addSublayer(border)
    }
}


//MARK: - UIAlertController Extentions
// function for show alert in Main View Controller
extension UIAlertController {
    
    func show() {
        present(animated: true, completion: nil)
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        }  else {
            controller.present(self, animated: animated, completion: completion);
        }
    }
    
    func addAction(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?) {
        let alertAction = UIAlertAction(title: title, style: style, handler: handler)
        self.addAction(alertAction)
    }
    
    
    
}

public enum Devices: String {
    case IPodTouch5
    case IPodTouch6
    case IPhone4
    case IPhone4S
    case IPhone5
    case IPhone5C
    case IPhone5S
    case IPhone6
    case IPhone6Plus
    case IPhone6S
    case IPhone6SPlus
    case IPhone7
    case IPhone7Plus
    case IPhoneSE
    case IPad2
    case IPad3
    case IPad4
    case IPadAir
    case IPadAir2
    case IPadMini
    case IPadMini2
    case IPadMini3
    case IPadMini4
    case IPadPro
    case AppleTV
    case Simulator
    case Other
}

public extension UIDevice {
    
    public var modelName: Devices {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            
        case "iPod5,1":                                 return Devices.IPodTouch5
        case "iPod7,1":                                 return Devices.IPodTouch6
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return Devices.IPhone4
        case "iPhone4,1":                               return Devices.IPhone4S
        case "iPhone5,1", "iPhone5,2":                  return Devices.IPhone5
        case "iPhone5,3", "iPhone5,4":                  return Devices.IPhone5C
        case "iPhone6,1", "iPhone6,2":                  return Devices.IPhone5S
        case "iPhone7,2":                               return Devices.IPhone6
        case "iPhone7,1":                               return Devices.IPhone6Plus
        case "iPhone8,1":                               return Devices.IPhone6S
        case "iPhone8,2":                               return Devices.IPhone6SPlus
        case "iPhone9,1", "iPhone9,3":                  return Devices.IPhone7
        case "iPhone9,2", "iPhone9,4":                  return Devices.IPhone7Plus
        case "iPhone8,4":                               return Devices.IPhoneSE
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return Devices.IPad2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return Devices.IPad3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return Devices.IPad4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return Devices.IPadAir
        case "iPad5,3", "iPad5,4":                      return Devices.IPadAir2
        case "iPad2,5", "iPad2,6", "iPad2,7":           return Devices.IPadMini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return Devices.IPadMini2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return Devices.IPadMini3
        case "iPad5,1", "iPad5,2":                      return Devices.IPadMini4
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return Devices.IPadPro
        case "AppleTV5,3":                              return Devices.AppleTV
        case "i386", "x86_64":                          return Devices.Simulator
        default:                                        return Devices.Other
        }
    }
    
    


}
// MARK: - UIImage extension
extension UIImage {
    
     // uses UIImage(assetIdentifier: AssetIdentifier.Menu)
    convenience init(assetIdentifier: AssetIdentifier)
    {
        self.init(named: assetIdentifier.rawValue)!
    }
   
    /*
     // Uses
     let image = UIImage(named: "your_image_name")
     testImage.image =  image?.maskWithColor(color: UIColor.blue)
     */
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    
    
    
    //ennum is define in constants
}

// MARK: - UIColor extension
extension UIColor
{
    
    // MARK: - COLOR_WITH_PATTERN_IMAGE
    func COLOR_WITH_PATTERN_IMAGE(image:NSString, view:UIView) -> UIColor {
        UIGraphicsBeginImageContext(view.frame.size)
        UIImage(named: image as String)?.drawAsPattern(in: view.bounds)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return UIColor(patternImage: image)
}
    
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
    
    
    
    
    
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}



// Mark: - mutable Data
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }

}

// Swift 3:
extension Date {
    var ticks: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}


//Extention uitextfiled
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
