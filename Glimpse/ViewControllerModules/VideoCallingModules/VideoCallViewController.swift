//
//  VideoCallViewController.swift
//  Glimpse
//
//  Created by Nitin on 11/22/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import Quickblox
import QuickbloxWebRTC

class VideoCallViewController: UIViewController,QBRTCClientDelegate {
    var dictCell = Dictionary<String, Any>()
    
    @IBOutlet weak var localVideoView:UIView!
    @IBOutlet weak var opponentVideoView:QBRTCRemoteVideoView!
    
    
    var myUserId :UInt!
    var userQB:QBUUser!
    var videoCapture: QBRTCCameraCapture?
    var session: QBRTCSession?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadCustomNavBar()

        myUserId =    ServicesManager.instance().currentUser.id
       // self class must conform to QBRTCClientDelegate protocol
        // 2123, 2123, 3122 - opponent's
        let opponentsIDs = [userQB.id]
        let newSession = QBRTCClient.instance().createNewSession(withOpponents: opponentsIDs as[NSNumber], with: QBRTCConferenceType.video)
        // userInfo - the custom user information dictionary for the call. May be nil.
        self.session = newSession
        let userInfo :[String:String] = ["key":"value"]
        newSession.startCall(userInfo)
        let videoFormat = QBRTCVideoFormat.init()
        videoFormat.frameRate = 30
        videoFormat.pixelFormat = QBRTCPixelFormat.format420f
        videoFormat.width = 640
        videoFormat.height = 480
        
        // QBRTCCameraCapture class used to capture frames using AVFoundation APIs
        self.videoCapture = QBRTCCameraCapture.init(videoFormat: videoFormat, position: AVCaptureDevicePosition.front)
        
        // add video capture to session's local media stream
        // from version 2.3 you no longer need to wait for 'initializedLocalMediaStream:' delegate to do it
        self.session?.localMediaStream.videoTrack.videoCapture = self.videoCapture
        
        self.videoCapture!.previewLayer.frame = self.localVideoView.bounds
        
        self.videoCapture!.startSession()
         QBRTCClient.instance().add(self) 
    self.localVideoView.layer.insertSublayer(self.videoCapture!.previewLayer, at: 0)
        // to change some time after, for example, at the moment of call
        let position = self.videoCapture?.position
        let newPosition = position == AVCaptureDevicePosition.front ? AVCaptureDevicePosition.back : AVCaptureDevicePosition.front
        
        // check whether videoCapture has or has not camera position
        // for example, some iPods do not have front camera
        if self.videoCapture!.hasCamera(for: newPosition) {
            self.videoCapture!.position = newPosition
        }

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Navigation Bar
    func loadCustomNavBar(){
        
        self.navigationController?.isNavigationBarHidden = false
        
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = Alert.colorFromHexString(hexCode: COLOR_CODE.NAVCOLOR)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        // Nav Button Logout
        
        self.navigationItem.rightBarButtonItems = [Alert.LOGOUT_BUTTON()]
        // Nav Image
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        imageView.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2-50, y: 0, width: 100, height: 45)
        self.navigationController?.navigationBar.addSubview(imageView)
        
        // Stop Button X
        let stopButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "error"), style: .plain, target: self, action: #selector(self.stopButtonClick))
        self.navigationItem.leftBarButtonItem = stopButton
    }
    
    
    //MARK: - STOP BUTTON CLICK
    func stopButtonClick()  {
       BACK(animated: true)
    }
    
    private func didReceiveNewSession(session: QBRTCSession!, userInfo: [NSObject : AnyObject]!) {
        
        if self.session != nil {
            // we already have a video/audio call session, so we reject another one
            // userInfo - the custom user information dictionary for the call from caller. May be nil.
            let userInfo :[String:String] = ["key":"value"]
            session.rejectCall(userInfo)
        }
        else {
            self.session = session
        }
    }
    
    // MARK: QBRTCClientDelegate
    
   @nonobjc func session(_ session: QBRTCSession, acceptedByUser userID: NSNumber, userInfo: [String : String]? = nil) {
        
    }
    
    @nonobjc func session(session: QBRTCSession!, rejectedByUser userID: NSNumber!, userInfo: [NSObject : AnyObject]!) {
        print("Rejected by user \(userID)")
    }
    
    // MARK: QBRTCClientDelegate
    
    @nonobjc func session(session: QBRTCSession!, startedConnectingToUser userID: NSNumber!) {
        print("Started connecting to user \(userID)")
    }
    
    // MARK: QBRTCClientDelegate
    
    @nonobjc func session(session: QBRTCSession!, connectionClosedForUser userID: NSNumber!) {
        print("Connection is closed for user \(userID)")
    }
    
    @nonobjc func session(session: QBRTCSession!, connectedToUser userID: NSNumber!) {
        print("Connection is established with user \(userID)")
    }
    
    // MARK: QBRTCClientDelegate
    
    @nonobjc func session(session: QBRTCSession!, disconnectedFromUser userID: NSNumber!) {
        print("Disconnected from user \(userID)");
    }
    
    @nonobjc func session(session: QBRTCSession!, userDidNotRespond userID: NSNumber!) {
        print("User \(userID) did not respond to your call within timeout")
    }
    
    // MARK: QBRTCClientDelegate
    @nonobjc func session(session: QBRTCSession!, connectionFailedForUser userID: NSNumber!) {
        print("Connection has failed with user \(userID)")
    }
    
    // MARK: QBRTCClientDelegate
    @nonobjc func session(session: QBRTCSession!, didChangeState state: QBRTCSessionState!) {
        print("Session did change state to \(state)")
    }
    // MARK: QBRTCClientDelegate
    @nonobjc func session(session: QBRTCSession!, didChangeConnectionState state: QBRTCConnectionState!, forUser userID: NSNumber!) {
        print("Session did change state to \(state) for userID \(userID)")
    }
    //Called in case when receive remote video track from opponent
    @nonobjc func session(session: QBRTCSession!, receivedRemoteVideoTrack videoTrack: QBRTCVideoTrack!, fromUser userID: NSNumber!) {
       
        self.opponentVideoView.setVideoTrack(videoTrack)
        
    }
    
    //Called in case when receive remote video track from opponent
    @nonobjc func session(session: QBRTCSession!, receivedRemoteAudioTrack audioTrack: QBRTCAudioTrack!, fromUser userID: NSNumber!) {
        // mute specific user audio track here (for example)
        // you can also always do it later by using '[QBRTCSession remoteAudioTrackWithUserID:]' method
        audioTrack.isEnabled = false
    }
    
    
    @nonobjc func sessionDidClose(session: QBRTCSession!) {
        
        // release session instance
        self.session = nil;
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
