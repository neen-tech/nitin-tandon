//
//  PostUploadViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 12/1/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import AVFoundation
import Alamofire

class PostUploadViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {

    @IBOutlet var img : UIImageView!
    @IBOutlet var txt : UITextView!

    @IBOutlet var btnUpload : UIButton!

    var type : String!
    var videoURL : NSURL?
    var movieData: NSData?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationController?.isNavigationBarHidden = false

        // Do any additional setup after loading the view.
    }
    
    

    @IBAction func photoClick(_ sender: UIButton) {
        
        self.showActionSheet()
        type = "2"
    }
    @IBAction func videoClick(_ sender: UIButton) {
        
        self.showActionSheet()
        type = "3"
    }
    @IBAction func uploadClick(_ sender: UIButton) {

        if(type == "2")
        {
            self.uploadImageOnServer()
        }
        else
        {
            self.uploadVideo()
        }
        
    }
    
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true

        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        if(type == "2")
        {
            myPickerController.mediaTypes = ["public.image"]

        }
        else
        {
            myPickerController.mediaTypes = ["public.movie"]
 
        }
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func photoLibrary()
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.allowsEditing = true
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        if(type == "2")
        {
            myPickerController.mediaTypes = ["public.image"]
            
        }
        else
        {
            myPickerController.mediaTypes = ["public.movie"]
            
        }
        self.present(myPickerController, animated: true, completion: nil)
        
    }
    
    //MARK: UIImagepicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if(type == "2")
        {
        img.image = info[UIImagePickerControllerEditedImage] as? UIImage
            btnUpload.isHidden = false
        }
        else
        {
           videoURL = info[UIImagePickerControllerMediaURL] as? NSURL

            img.image = self.thumbnailForVideoAtURL(url: videoURL!)

            btnUpload.isHidden = false

            
        }
        self.dismiss(animated: true, completion: nil)

        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    private func thumbnailForVideoAtURL(url: NSURL) -> UIImage? {
        
        do {
            let asset = AVURLAsset(url: videoURL! as URL , options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            
            return thumbnail;
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
        }
        return nil
    }
    func uploadImageOnServer() {
        
        HUD.addHudWithWithGif()
        
        let url =  URL(string:SERVER.kBASE_URL)!
        
        //Parameter
        let parameters = [ACTION.kAPI_ACTION:APIMETHOD.kAPI_CREATE_POST ,
                          USER.kUSERID:(UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String,
                          "type" : type,
                          "content" : txt.text
            ] as [String : Any]
        
        print("Parameter:\(parameters)")
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.img.image!, 1)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
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
                       
                        self.btnUpload.isHidden = true
                        self.txt.text = ""
                        self.img.image = UIImage()
                        
                        self.tabBarController?.selectedIndex = 0
                        //self.navigationController?.popViewController(animated: true)
                        
                        
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
        let parameters = [ACTION.kAPI_ACTION:APIMETHOD.kAPI_CREATE_POST ,
                          USER.kUSERID:(UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String,
                          "type" : type,
                          "content" : txt.text] as [String : Any]
        
        print("Parameter:\(parameters)")
        
        do {
            movieData = try NSData(contentsOfFile: (videoURL?.relativePath)!, options: NSData.ReadingOptions.dataReadingMapped)
        } catch _ {
            movieData = nil
            return
        }
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(UIImageJPEGRepresentation(self.img.image!, 1)!, withName: "image", fileName: "image.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(self.movieData! as Data, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
            
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
                        self.btnUpload.isHidden = true
                        self.txt.text = ""
                        self.img.image = UIImage()
                        
                        
                        self.tabBarController?.selectedIndex = 0
                        
                        
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
