//
//  UploadPhotoViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 11/9/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import Fusuma
import Alamofire
import AlamofireImage
import MobileCoreServices
import AVFoundation

class UploadPhotoViewController: UIViewController, FusumaDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
   
    var strType : String!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var collImages : UICollectionView!
    var arrImages : [UIImage] = []
     @IBOutlet weak var buttonPickPhoto:UIButton!
    var videoURL : NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.strType == "video")
        {
            lblType.text = "Upload Video"
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func buttonPickPhotoClick(sender: AnyObject)
    {
        if(self.strType == "video")
        {
            if (self.buttonPickPhoto.titleLabel?.text == "OK!" as String)
            {
                self.uploadVideo()
            }
            else
            {
            
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                
                let videoPicker = UIImagePickerController()
                videoPicker.delegate = self
                videoPicker.sourceType = .photoLibrary
                videoPicker.mediaTypes = [kUTTypeMovie as String]
                self.present(videoPicker, animated: true, completion: nil)
            }
                
            }
        }
        else
        
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
                    
                    if(self.strType == "video")
                    {
                        fusuma.hasVideo = true
                    }
                    //        fusuma.availableModes = [.video]
                    fusumaSavesImage = true
                    self.present(fusuma, animated: true, completion: nil)
                }
            }
            
            
        })
            
        }
    }
    
    //Mark :- Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        videoURL = info[UIImagePickerControllerMediaURL]as? NSURL
        print(videoURL!)
        do {
            let asset = AVURLAsset(url: videoURL! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            self.buttonPickPhoto.setImage(nil, for: .normal)
            self.buttonPickPhoto.setTitle("OK!", for: .normal)
            
            arrImages.append(thumbnail)
            collImages.reloadData()
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //Mark:- Fusuma Delegate

    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        print("fusumaImageSelected")
        
        self.buttonPickPhoto.setImage(nil, for: .normal)
        self.buttonPickPhoto.setTitle("OK!", for: .normal)

        arrImages.append(image)
        collImages.reloadData()
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("fusumaVideoCompleted")
    }
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        
        print("Number of selection images: \(images.count)")
        self.buttonPickPhoto.setImage(nil, for: .normal)
        self.buttonPickPhoto.setTitle("OK!", for: .normal)
        var count: Double = 0
        arrImages = images
        collImages.reloadData()
        
        for image in images {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (3.0 * count)) {
                
                print("w: \(image.size.width) - h: \(image.size.height)")
            }
            count += 1
        }
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
    
    func uploadImageOnServer() {
        
        HUD.addHudWithWithGif()
        
        let url =  URL(string:SERVER.kBASE_URL)!
        
        //Parameter
        let parameters = [ACTION.kAPI_ACTION:APIMETHOD.kAPI_UPLOAD_GALLERY_IMAGE ,
                          USER.kUSERID:(UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String]
        
        print("Parameter:\(parameters)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.arrImages[0], 1)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
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
                        self.navigationController?.popViewController(animated: true)
         
                        
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

    func uploadVideo()
    {
        
        HUD.addHudWithWithGif()
        
        let url =  URL(string:SERVER.kBASE_URL)!
        
        //Parameter
        let parameters = [ACTION.kAPI_ACTION:APIMETHOD.kAPI_UPLOAD_GALLERY_VIDEO ,
                          USER.kUSERID:(UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String]
        
        print("Parameter:\(parameters)")
        var movieData: NSData?
        do {
            movieData = try NSData(contentsOfFile: (videoURL?.relativePath)!, options: NSData.ReadingOptions.dataReadingMapped)
        } catch _ {
            movieData = nil
            return
        }
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.arrImages[0], 1)!, withName: "thumb", fileName: "image.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(movieData! as Data, withName: "file", fileName: "file.mp4", mimeType: "video/mp4")
            
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
                        self.navigationController?.popViewController(animated: true)
                        
                        
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
    
    
    // MARK :- Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath as IndexPath) as! UserCollectionViewCell
        
        cell.imageViewProfile.image = arrImages[indexPath.row] as! UIImage
        
       
        
        
        return cell
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
