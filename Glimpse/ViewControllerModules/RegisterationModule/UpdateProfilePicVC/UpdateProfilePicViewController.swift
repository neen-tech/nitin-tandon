//
//  UpdateProfilePicViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import Fusuma
import Quickblox
import Alamofire
import AlamofireImage

class UpdateProfilePicViewController: UIViewController,FusumaDelegate {

    @IBOutlet weak var imageViewBG: UIImageView!
    @IBOutlet weak var imageViewProfile:UIImageView!
    @IBOutlet weak var buttonBack:UIButton!
    @IBOutlet weak var buttonPickPhoto:UIButton!
    @IBOutlet weak var lblUserName:UILabel!
    var dictSignUpData : NSDictionary?
    var qbprofile = QBProfile()
    //MARK: - View Base Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
  
        // Configration view
        self.configView()

        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - Configration
    func configView() {
        
        // Blur Effect on ImageView
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        visualEffectView.frame = self.view.frame
        imageViewBG.addSubview(visualEffectView)
      
        // Round corners of Profile Picture
      imageViewProfile.roundCorners(corners: [.allCorners], radius: imageViewProfile.frame.size.height/2)
        
      buttonPickPhoto.roundCorners(corners: [.allCorners], radius: buttonPickPhoto.frame.size.height/2)
        
          print("user data:\(String(describing: self.dictSignUpData))")
        
         lblUserName.text = self.dictSignUpData?.object(forKey: USER.kUSER_FIRST_NAME) as? String
    }
        
    
    
     //MARK: - Button Actions
    @IBAction func buttonBackClick(sender: AnyObject)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            self.buttonBack.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            self.buttonBack.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
           self.BACK(animated: true)
            
            
        })
    }

    @IBAction func buttonPickPhotoClick(sender: AnyObject)
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            self.buttonPickPhoto.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            self.buttonPickPhoto.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                
                if (self.buttonPickPhoto.titleLabel?.text == "OK!" as String)
                {
                    
                    /*
                    let bodyTypeViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_BODY_TYPE_VC as NSString) as! BodyTypeViewController
                    
                    self.MOVE(vc: bodyTypeViewController, animated: true)
 
                        */
                    
                    self.uploadImageOnServer()
                }
                else
                {
                    // Validate Fields
                    let fusuma = FusumaViewController()
                    fusuma.title = "All Photos"
                    
                    fusuma.delegate = self
                    fusuma.cropHeightRatio = 1.0
                    fusuma.allowMultipleSelection = false
                    //        fusuma.availableModes = [.video]
                    fusumaSavesImage = true
                    self.present(fusuma, animated: true, completion: nil)
                }
            }
            
           
        })
    }
    
    
    // MARK: FusumaDelegate Protocol
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Image captured from Camera")
            
        case .library:
            
            print("Image selected from Camera Roll")
            
        default:
            
            print("Image selected")
        }
        
        self.imageViewProfile.image = image
        self.buttonPickPhoto.setImage(nil, for: .normal)
        self.buttonPickPhoto.setTitle("OK!", for: .normal)
    }
    
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")
        
        var count: Double = 0
        
        for image in images {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                
                self.imageViewProfile.image = image
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            count += 1
        }
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode, metaData: ImageMetadata) {
        
        print("Image mediatype: \(metaData.mediaType)")
        print("Source image size: \(metaData.pixelWidth)x\(metaData.pixelHeight)")
        print("Creation date: \(String(describing: metaData.creationDate))")
        print("Modification date: \(String(describing: metaData.modificationDate))")
        print("Video duration: \(metaData.duration)")
        print("Is favourite: \(metaData.isFavourite)")
        print("Is hidden: \(metaData.isHidden)")
        print("Location: \(String(describing: metaData.location))")
        self.imageViewProfile.image = image
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("video completed and output to file: \(fileURL)")
       // self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
        switch source {
            
        case .camera:
            
            print("Called just after dismissed FusumaViewController using Camera")
       
            
        case .library:
            
            print("Called just after dismissed FusumaViewController using Camera Roll")
            
            
        default:
            
            print("Called just after dismissed FusumaViewController")
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested",
                                      message: "Saving image needs to access your photo album",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default) { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                
                UIApplication.shared.openURL(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
            
        })
        
        guard let vc = UIApplication.shared.delegate?.window??.rootViewController,
            let presented = vc.presentedViewController else {
                
                return
        }
        
        presented.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the FusumaViewController disappeared")
    }
    
    func fusumaWillClosed() {
        
        print("Called when the close button is pressed")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func uploadImageOnServer() {
        
        HUD.addHudWithWithGif()
        
        let url =  URL(string:SERVER.kBASE_URL)!
        
        //Parameter
        let parameters = [ACTION.kAPI_ACTION:APIMETHOD.kAPI_CHANGE_PROFILE_PIC ,
                          USER.kUSERID: self.dictSignUpData?.object(forKey: "id") ?? ""] as [String : Any]
        
        print("Parameter:\(parameters)")
        print("Dictionary:\(self.dictSignUpData)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.imageViewProfile.image!, 1)!, withName: "profile_image", fileName: "image.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //Print progress
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.responseJSON { response in
                    //print response.result
                    HUD.closeHUD()
                    if response.result.value != nil{
                        
                        //
                        
                        print("Result:\(response.result.value!)")
                        
                        let dict:NSDictionary! = (response.result.value!) as! NSDictionary
                        
                        HUD.closeHUD()
                        
                        //Store info Nsuser Default
                        UserDefaults.standard.set(dict.object(forKey: "response"), forKey:EXTRA.kAPI_LOGIN_DATA)
                        UserDefaults.standard.synchronize()
                        
                        let currentUser:QBUUser = ServicesManager.instance().currentUser
                        
                        self.qbprofile.synchronize(withUserData: currentUser)
                        
                        ServicesManager.instance().chatService.connect(completionBlock: nil)
                        
                        let bodyTypeViewController = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_BODY_TYPE_VC as NSString) as! BodyTypeViewController
                        self.MOVE(vc: bodyTypeViewController, animated: true)
                        
                        
                    }
                    else
                    {
                        HUD.closeHUD()
                        
                        
                        Alert.alertWithImage(viewController: self, image:"cloud-error", msg:response.result.error!.localizedDescription as NSString )
                        
                    }
                    
                    
                }
                break
            case .failure(_):
                //print encodingError.description
                
                HUD.closeHUD()
                Alert.alertWithImage(viewController: self, image:"cloud-error", msg:"Error" as NSString )
                
                break
                
            }
        }
        
        
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
