//
//  WebService.swift
//  ServiceDispatchPro
//
//  Created by Infoicon on 17/08/16.
//  Copyright © 2016 InfoiconTechnologies. All rights reserved.
//

import UIKit


// Webservice delegate (Protocal)
protocol WebServiceDelegate:class
{
    func getDataFormWebService(jsonResult:NSDictionary, methodName:NSString)
    func webServiceFail(error:NSError)
    func webServiceFailWithApplicationServerMSG(msg:String)
}

class WebService: NSObject {

   weak var delegate               :   WebServiceDelegate?
    var msg:String? = nil
  
    // MARK:- SERVICE USING POST METHOD
    func servicePOSTMethod(postStr:NSString, urlStr:NSString, methodName:NSString)
    {
        print("urlStr:\(urlStr)")
        print("postStr:\(postStr)")
        
        let postData:NSData! = postStr.data(using: String.Encoding.utf8.rawValue, allowLossyConversion: true)! as NSData
        let postLength:NSString = String( postData.length ) as NSString
        let url:NSURL! = NSURL(string:urlStr as String)
        //print(url);
        let request:NSMutableURLRequest! = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue(postLength as String, forHTTPHeaderField:"Content-Length")
        request.setValue("application/json", forHTTPHeaderField:"Content-Type")
        request.httpBody = postData! as Data
        request.timeoutInterval = 30.0
        
        let session = URLSession( configuration: URLSessionConfiguration.ephemeral);
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
           
            if (error == nil && (data?.count)!>0)
            {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        
                        print(jsonResult)
                        
                        
                        let status:NSString = jsonResult.value(forKey: EXTRA.kAPI_STATUS) as! NSString
                        
                        if status.isEqual(to: EXTRA.kAPI_STATUS_SUCCESS)
                        {
                            DispatchQueue.main.async(){
                            
                            
                            
                             self.delegate?.getDataFormWebService(jsonResult: jsonResult, methodName: methodName)
                            }
                        }
                        
                        else
                        {
                            DispatchQueue.main.async(){
                                
                        
                                 self.msg = jsonResult.value(forKey: EXTRA.kAPI_MSG) as? String
                                
                                if self.msg == nil
                                {
                                    self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                                }
                                else
                                {
                            
                                    self.delegate?.webServiceFailWithApplicationServerMSG(msg: self.msg!)
                                }
                            }
                        
                        }
                       
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    
                    DispatchQueue.main.async()
                        {

                    
                    self.delegate?.webServiceFail(error: error);
                    }
                    
                }
            }
            else if (error == nil && data?.count==0)
            {
               
                DispatchQueue.main.async()
                {
                    //let msg:NSString =
                    
                  self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                }
                
            }
            else if (error != nil)
            {
                DispatchQueue.main.async() {
                   
                    self.delegate?.webServiceFail(error: error! as NSError);
                }
            }
        })
        
        task.resume()
    }

    // MARK:- SERVICE USING GET METHOD
    func serviceGETMethod(urlStr:NSString,methodName:NSString)
    {
        let urlEncode : String! = urlStr.addingPercentEncoding( withAllowedCharacters: NSCharacterSet.urlQueryAllowed) 
        let url:URL! = URL(string:(urlEncode)!)
   

        let request:NSMutableURLRequest! = NSMutableURLRequest(url: url as URL)
        request.timeoutInterval = 30.0
        
        let session = URLSession( configuration: URLSessionConfiguration.ephemeral);
        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
            
            
            if (error == nil && (data?.count)!>0)
            {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        print(jsonResult)
                        
                        self.delegate?.getDataFormWebService(jsonResult: jsonResult, methodName:methodName)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
            else if (error == nil && data?.count==0)
            {
                
                DispatchQueue.main.async()
                {
                    //let msg:NSString =
                    
                    self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                }
                
            }
            else if (error != nil)
            {
                DispatchQueue.main.async() {
                    
                    self.delegate?.webServiceFail(error: error! as NSError);
                }
            }
        })
        
        task.resume()
    }
    
    
    
    // MARK:- SERVICE USING POST METHOD
    func serviceUploadImagePOSTMethod(urlStr:NSString, methodName:NSString,parameter:NSMutableDictionary,filePathKey:String,image:UIImage)
    {
     
        let concurrentQueue = DispatchQueue(label: "queuename", attributes: .concurrent)
        concurrentQueue.sync {
            
            let url:NSURL! = NSURL(string:urlStr as String)
            //print(url);
            let request:NSMutableURLRequest! = NSMutableURLRequest(url: url as URL)
            
            // request cache policy
            request.cachePolicy =  NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData
            
            // Handle Cookies
            request.httpShouldHandleCookies = false
            // Method Type
            request.httpMethod = "POST"
            
            // request Body
            request.httpBody = Alert.createRequestBodyWith(parameters: parameter as! [String : NSObject], filePathKey: filePathKey, boundary: Alert.generateBoundaryString(), fileName: "image", image: image) as Data
            
            // Request Time out
            request.timeoutInterval = 30.0
            
            

            /*
            request.httpMethod = "POST"
            request.setValue(postLength as String, forHTTPHeaderField:"Content-Length")
            request.setValue("application/json", forHTTPHeaderField:"Content-Type")
            request.httpBody = postData! as Data
            request.timeoutInterval = 30.0
            
 
            */
            
            
            
            let session = URLSession( configuration: URLSessionConfiguration.ephemeral);
            
            let task = session.dataTask(with: request as URLRequest, completionHandler: {(data, response, error) in
                
                
                if (error == nil && (data?.count)!>0)
                {
                    do {
                        if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                            print(jsonResult)
                            
                            
                            let status:NSString = jsonResult.value(forKey: EXTRA.kAPI_STATUS) as! NSString
                            
                            if status.isEqual(to: EXTRA.kAPI_STATUS_SUCCESS)
                            {
                                DispatchQueue.main.async(){
                                    
                                    
                                    
                                    self.delegate?.getDataFormWebService(jsonResult: jsonResult, methodName: methodName)
                                }
                            }
                            else
                            {
                                DispatchQueue.main.async(){
                                    
                                    self.msg = jsonResult.value(forKey: EXTRA.kAPI_MSG) as? String
                                    
                                    if self.msg == nil
                                    {
                                        self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                                    }
                                    else
                                    {
                                        
                                        self.delegate?.webServiceFailWithApplicationServerMSG(msg: self.msg!)
                                    }
                                }
                                
                            }
                            
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                        
                        DispatchQueue.main.async()
                            {
                                
                                
                                self.delegate?.webServiceFail(error: error);
                        }
                        
                    }
                }
                else if (error == nil && data?.count==0)
                {
                    
                    DispatchQueue.main.async()
                        {
                            //let msg:NSString =
                            
                            self.delegate?.webServiceFailWithApplicationServerMSG(msg: "Opps! Server connection failed.\n Please try later.")
                    }
                    
                }
                else if (error != nil)
                {
                    DispatchQueue.main.async() {
                        
                        self.delegate?.webServiceFail(error: error! as NSError);
                    }
                }
            })
            
            task.resume()

            
        }
    }
    
    
    /*
 
     
     
     #pragma mark - Image Upload method or Change image webservice
     -(void)uploadImageUsingRamLogic:(NSDictionary *)dict imageData:(NSData *)imageData
     {
     
     //    dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
     //    dispatch_async(myQueue, ^{
     NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
     _params                      = [dict mutableCopy];
     
     NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
     NSString* FileParamConstant = @"image";
     NSURL* requestURL = [NSURL URLWithString:kURL_BASE];
     
     
     // create request
     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
     [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
     [request setHTTPShouldHandleCookies:NO];
     //[request setTimeoutInterval:30];
     [request setHTTPMethod:@"POST"];
     NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
     [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
     
     // post body
     NSMutableData *body = [NSMutableData data];
     
     // add params (all params are strings)
     for (NSString *param in _params)
     {
     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
     }
     
     // add image data
     
     if (imageData) {
     [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
     [body appendData:imageData];
     [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
     }
     
     [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
     
     // setting the body of the post to the reqeust
     [request setHTTPBody:body];
     
     // set the content-length
     NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
     [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
     // set URL
     [request setURL:requestURL];
     
     
     NSURLSession *session = [NSURLSession sharedSession];
     NSURLSessionDataTask *task = [session dataTaskWithRequest:request
     completionHandler:
     ^(NSData *data, NSURLResponse *response, NSError *error) {
     
     dispatch_async(dispatch_get_main_queue(), ^{
     
     
     if ([data length] >0 && error == nil)
     {
     NSDictionary * result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
     NSLog(@"result =%@",result );
     
     if ([result isKindOfClass:[NSNull class]] || result == nil)
     {
     
     
     [BMBGLOBAL alertControllerTitle:kAPPICATION_TITLE msg:kSERVER_ISSUE ok:kOK controller:self.navigationController];
     
     
     }
     else
     {
     
     NSDictionary * dictResponse =[result objectForKey:kRESPONSE_KEY];
     
     NSString * isSuccess =[result valueForKey:@"status"];
     if ([isSuccess isEqualToString:@"Success"]) {
     
     
     
     [self displayeData:dictResponse];
     
     
     
     
     
     }
     else
     {
     
     
     [BMBGLOBAL alertControllerTitle:kAPPICATION_TITLE msg:kSERVICE_MSG ok:kOK controller:self.navigationController];
     
     
     
     }
     }
     }
     else if ([data length] == 0 && error == nil)
     {
     
     [BMBGLOBAL alertControllerTitle:kAPPICATION_TITLE msg:kSERVER_ISSUE ok:kOK controller:self.navigationController];
     
     
     }
     else if (error != nil)
     {
     
     [BMBGLOBAL alertControllerTitle:kAPPICATION_TITLE msg:kSERVER_ISSUE ok:kOK controller:self.navigationController];
     
     
     }
     
     });
     }];
     [task resume];
     }

     
 */
    
    
    
}
