//
//  CalendarDateViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/16/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import CVCalendar

class CalendarDateViewController: UIViewController,CVCalendarViewDelegate, CVCalendarMenuViewDelegate,CVCalendarViewAppearanceDelegate,UITableViewDelegate,UITableViewDataSource, WebServiceDelegate {
   
     var datesDictionary:[String:String] = ["5 December, 2017":"Service",
                                            "9 November, 2017":"Change Oil",
                                            "20 November, 2017":"Check brakes"]
    var arrMarkedDates : [String:String] = [:]
    
    // Calendar View Objects
    var dictDetails : NSDictionary!
    var backgroundImage = UIImageView()
    var profileImageView = UIImageView()
    var lblFirstName = UILabel()
    var buttonComment       = UIButton()
    var buttonLike          = UIButton()
    var buttonFavourite     = UIButton()
    var btnPhotos     = UIButton()
    var btnVideos     = UIButton()
    var upperView           = UIView()
    var viewBottomShadow    = UIView()
    var tableViewCalendar = UITableView()
    var viewHeader = UIView()
    var strSelectedDate : String!
    var menuView = CVCalendarMenuView()
    var calendarView =  CVCalendarView()
    var buttonAddOnCalendar     = UIButton()
    
    // Calender Objects
    fileprivate var randomNumberOfDotMarkersForDay = [Int]()
    
    var shouldShowDaysOut = true
    var animationFinished = true
    var arrList:NSMutableArray! = []
    var arrDates:NSMutableArray! = []

    var selectedDay:DayView!
    var monthLabel = UILabel()
    var currentCalendar: Calendar?
    
    override func viewDidLoad() {
        super.viewDidLoad()

     
        
        // Load Initial UI
        self.loadCustomNavBar()
        self.loadConfigView()
        self.edgesForExtendedLayout = UIRectEdge.init(rawValue: 0)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        let timeZoneBias = 400 // (UTC+08:00) //    var signUpUser : QBUUser!
        currentCalendar = Calendar.init(identifier: .gregorian)
        if let timeZone = TimeZone.init(secondsFromGMT: -timeZoneBias * 60) {
            currentCalendar?.timeZone = timeZone
        }
        
        self.getCalendarNotes()
        self.getProfileDetails()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Commit frames' updates
        self.menuView.commitMenuViewUpdate()
        self.calendarView.commitCalendarViewUpdate()
        
       
        
        strSelectedDate = Alert.dateToString(date: Date()) 
        
    }
    
    // MARK: Navigation Bar
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
        
    }
    
    
    // MARK: loadConfigView
    
    func loadConfigView(){
        
        self.view.backgroundColor = .white
        
        self.loadUpperView()
       self.loadBottomView()
        
        
    //
        
        
       
    }
    
   
    
    
    
    
    
    // MARK : loadUpperView
    func loadUpperView() -> Void{
        
        // Add Upper View For user image and background blur image
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: Alert.kSCREEN_WIDTH(), height: 220))
        upperView.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_UPPER_HEADER)
        self.view.addSubview(upperView)
        
        // Blur User image
        backgroundImage = UIImageView(image:#imageLiteral(resourceName: "girl"))
        backgroundImage.frame = CGRect(x:0 , y:0, width:Alert.kSCREEN_WIDTH(), height:180)
        upperView.addSubview(backgroundImage)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(backgroundImage.frame.width)), UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(backgroundImage.frame.height))]
        
        backgroundImage.addSubview(blurEffectView)
        
        // Profile Pic
        
        
        let borderImageView = UIImageView(image:#imageLiteral(resourceName: "profileborderbold"))
        borderImageView.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2-80, y:10, width:160, height:160)
        borderImageView.layer.cornerRadius = 80;
        borderImageView.clipsToBounds = true
        borderImageView.backgroundColor = .white
        upperView.addSubview(borderImageView)
        
        profileImageView = UIImageView(image: #imageLiteral(resourceName: "girl"))
        profileImageView.frame = CGRect(x:15, y:15, width:130, height:130)
        profileImageView.layer.cornerRadius = 65;
        profileImageView.clipsToBounds = true
        profileImageView.backgroundColor = .red
        borderImageView.addSubview(profileImageView)
        
        
        // Show Name
        lblFirstName = UILabel(frame: CGRect(x: Alert.kSCREEN_WIDTH()-130, y: 10, width: 120, height: 30))
        lblFirstName.textColor = .black
        lblFirstName.textAlignment = .right
        lblFirstName.text = "Keyosha"
        lblFirstName.font = UIFont(name: "HelveticaNeue", size: 20)
        upperView.addSubview(lblFirstName)
        
        
        // Buttons Like, Comment & Favourite
        buttonComment =  UIButton(frame: CGRect(x:30, y:upperView.frame.size.height-35, width:Alert.kSCREEN_WIDTH()/3 , height:30))
        buttonComment.setTitle("1,212", for: .normal)
        buttonComment.setTitleColor(.white, for: .normal)
        buttonComment.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        buttonComment.setImage(#imageLiteral(resourceName: "chat"), for: .normal)
        buttonComment.titleLabel?.font = UIFont(name:"HelveticaNeue" , size:15)
        upperView.addSubview(buttonComment)
        
        
        buttonLike =  UIButton(frame: CGRect(x:Alert.kSCREEN_WIDTH()/3+20, y:upperView.frame.size.height-35, width:Alert.kSCREEN_WIDTH()/3 , height:30))
        buttonLike.setTitle("4,212", for: .normal)
        buttonLike.setTitleColor(.white, for: .normal)
        buttonLike.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        buttonLike.setImage(#imageLiteral(resourceName: "like"), for: .normal)
        buttonLike.titleLabel?.font = UIFont(name:"HelveticaNeue" , size:15)
        upperView.addSubview(buttonLike)
        
        
        buttonFavourite =  UIButton(frame: CGRect(x:2*Alert.kSCREEN_WIDTH()/3, y:upperView.frame.size.height-35, width:Alert.kSCREEN_WIDTH()/3 , height:30))
        buttonFavourite.setTitle("4,212", for: .normal)
        buttonFavourite.setTitleColor(.white, for: .normal)
        buttonFavourite.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0)
        buttonFavourite.setImage(#imageLiteral(resourceName: "fav"), for: .normal)
        buttonFavourite.titleLabel?.font = UIFont(name:"HelveticaNeue" , size:15)
        upperView.addSubview(buttonFavourite)
        
    }
    
    
    //MARK: - loadBottomView
    func loadBottomView() {
      
        // TABLEVIEW HEADER
        self.viewHeader = UIView.init(frame: CGRect(x: 0, y:0, width:Alert.kSCREEN_WIDTH(), height: Alert.kSCREEN_WIDTH()+50))
        self.viewHeader.backgroundColor = .clear
        
        // IMAGE VIEW BACKGROUND
        let imageBG  = UIImageView.init(frame: CGRect(x: 0, y:0, width:Alert.kSCREEN_WIDTH(), height: Alert.kSCREEN_WIDTH()))
        imageBG.image = #imageLiteral(resourceName: "calenderbg")
        imageBG.contentMode = .scaleToFill
        self.viewHeader.insertSubview(imageBG, at: 0)
        
       
         // monthLabel initialization with frame
        self.monthLabel = UILabel.init(frame: CGRect(x:0, y:0, width:Alert.kSCREEN_WIDTH(), height:32))
        self.monthLabel.textColor = Alert.colorFromHexString(hexCode: "#E6EFF5")
        self.monthLabel.font = UIFont.init(name: FONT.kFONT_BOLD, size: 15)
        self.monthLabel.textAlignment = .center
        self.viewHeader.addSubview(self.monthLabel)
        
         // CVCalendarMenuView initialization with frame
        self.menuView = CVCalendarMenuView.init(frame: CGRect(x:0, y:32, width:Alert.kSCREEN_WIDTH(), height:20))
        
        self.menuView.backgroundColor = .clear
        
        // CVCalendarView initialization with frame
        self.calendarView = CVCalendarView(frame: CGRect(x:0, y:56, width:Alert.kSCREEN_WIDTH(), height: imageBG.frame.size.height - 50))
        
        
       // self.calendarView.backgroundColor = .red
        
        // Appearance delegate [Unnecessary]
        self.calendarView.calendarAppearanceDelegate = self
        
        // Animator delegate [Unnecessary]
        self.calendarView.animatorDelegate = self
        
        // Menu delegate [Required]
        self.menuView.menuViewDelegate = self
        
        // Calendar delegate [Required]
        self.calendarView.calendarDelegate = self
        
        
        self.viewHeader.addSubview(self.menuView)
        self.viewHeader.addSubview(self.calendarView)
        
        // BUTTON ON BACKGROUND
        self.buttonAddOnCalendar = UIButton.init(type: .custom)
        self.buttonAddOnCalendar.frame = CGRect(x: Alert.kSCREEN_WIDTH() - 106, y:(imageBG.frame.origin.y+imageBG.frame.size.height ) - 45 , width:90, height: 90)
        self.buttonAddOnCalendar.backgroundColor = Alert.colorFromHexString(hexCode: "#71C8E1")
        Alert.SHADOW_ON_UIVIEW(view: self.buttonAddOnCalendar, shadowColor: .black, shadowRadius: 0.2, masksToBounds: true, radius: 45, shadowOpacity: 1.0)
        self.buttonAddOnCalendar.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        self.buttonAddOnCalendar.addTarget(self, action: #selector(buttonAddOnCalendarClick), for: .touchUpInside)
         self.viewHeader.addSubview(self.buttonAddOnCalendar)
        
        // TABLEVIEW CALENDAR
        
        self.tableViewCalendar = UITableView.init(frame: CGRect(x:0,y:upperView.frame.origin.y+upperView.frame.size.height, width: Alert.kSCREEN_WIDTH(),height:(Alert.kSCREEN_HEIGHT() - (upperView.frame.size.height+(24+65)))))
        self.tableViewCalendar.tableHeaderView = self.viewHeader
        self.tableViewCalendar.backgroundColor = .white
        self.tableViewCalendar.delegate = self
        self.tableViewCalendar.dataSource = self
        
        self.tableViewCalendar.register(UITableViewCell.self, forCellReuseIdentifier: "CalendarCell")
        
        
        // SHADOW VIEW
        
        self.viewBottomShadow = UIView.init(frame: CGRect(x: 0, y:Alert.kSCREEN_HEIGHT() - (24+65) , width:Alert.kSCREEN_WIDTH(), height: 25))
         self.viewBottomShadow.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_BOTTOM_SHADOW)
        
        
        let buttonCross = UIButton.init(type: .custom)
        buttonCross.frame = CGRect(x: Alert.kSCREEN_WIDTH() - 28, y: 4, width: 24, height: 24)
        buttonCross.setImage(#imageLiteral(resourceName: "error"), for: .normal)
        buttonCross.backgroundColor = .clear
        buttonCross.addTarget(self, action: #selector(self.stopButtonClick), for:.touchUpInside)
        buttonCross.bringSubview(toFront: self.tableViewCalendar)
        self.tableViewCalendar.addSubview(buttonCross)
        
        self.view.addSubview( self.viewBottomShadow)
        self.view.addSubview( self.tableViewCalendar)

    }
    
    //MARK: -  Get Profile Details
    func getProfileDetails()
    {
        
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_PROFILE_DETAILS, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kOTHER_USERID as NSCopying)

        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_PROFILE_DETAILS as NSString)
    }
    
    //MARK: Get Notes
    func getCalendarNotes()
    {
        //Web Service Delegate
        let webservice = WebService.init()
        webservice.delegate = self
        
        let dict = NSMutableDictionary.init()
        dict.setObject(APIMETHOD.kAPI_GET_CALENDAR, forKey: ACTION.kAPI_ACTION as NSCopying)
        dict.setObject((UserDefaults.standard.value(forKey:EXTRA.kAPI_LOGIN_DATA ) as! NSDictionary).value(forKey: "id") as! String, forKey: USER.kUSERID as NSCopying)
        
        
        
        webservice.servicePOSTMethod(postStr: Alert.jsonStringWithJSONObject(dictionary: dict), urlStr: SERVER.kBASE_URL as NSString, methodName: APIMETHOD.kAPI_GET_CALENDAR as NSString)
    }
    
    //MARK: - WEBSERVICE DELEGATE
    
    func getDataFormWebService(jsonResult: NSDictionary, methodName: NSString) {
        
        HUD.closeHUD()
        
        if methodName.isEqual(to: APIMETHOD.kAPI_PROFILE_DETAILS) {
            
            DispatchQueue.main.async() {
                
                self.dictDetails = NSDictionary.init()
                
                self.dictDetails = jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSDictionary
                
                
                self.buttonLike.setTitle(self.dictDetails.value(forKey: "totalLikes") as? String, for: UIControlState.normal)
                self.buttonComment.setTitle(self.dictDetails.value(forKey: "totalComments") as? String, for: UIControlState.normal)
                self.buttonFavourite.setTitle(self.dictDetails.value(forKey: "totalFavourite") as? String, for: UIControlState.normal)
                
                self.lblFirstName.text = self.dictDetails.value(forKey: "firstName") as? String
                self.profileImageView.af_setImage(withURL: URL(string: (self.dictDetails.value(forKey: "image") as? String)!)!)
                
             
                
                
                
                
                
            }
            
            
        }
        if methodName.isEqual(to: APIMETHOD.kAPI_GET_CALENDAR) {
            
           arrDates = (jsonResult.object(forKey: EXTRA.kAPI_RESPONSE as NSString) as? NSArray)?.mutableCopy() as! NSMutableArray
          
            for i in 0 ..< arrDates.count
            {
                let dict : NSDictionary! = arrDates.object(at: i) as! NSDictionary
                
                
                let date : Date! = Alert.stringToDate(strDate: dict.value(forKey: "date") as! String)
                
                let strDate : String! = Alert.dateToString(date: date, format: "dd MMMM, YYYY")
                
                
                arrMarkedDates.updateValue(dict.value(forKey: "title") as! String, forKey: strDate )

            }
            calendarView.contentController.refreshPresentedMonth()

            var dotArray = arrMarkedDates {
                didSet{
                    self.calendarView.contentController.refreshPresentedMonth()
                }
            }
        }
    }
    
    func webServiceFailWithApplicationServerMSG(msg: String) {
        HUD.closeHUD()
        Alert.showTostMessage(message:msg as String, delay: 3.0, controller: self)
        
    }
    
    func webServiceFail(error: NSError) {
        HUD.closeHUD()
        Alert.showTostMessage(message:error.localizedDescription as String, delay: 3.0, controller: self)
        
    }
    
    
    //MARK: - buttonAddOnCalendarClick
      @objc func buttonAddOnCalendarClick(sender: UIButton!){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            self.buttonAddOnCalendar.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            self.buttonAddOnCalendar.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
               
                let storyBoard : UIStoryboard! = UIStoryboard(name: "Main", bundle: nil)
                
                
                let glimpleViewController : AddCalendarNoteViewController = storyBoard.instantiateViewController(withIdentifier: "AddCalendarNoteViewController") as! AddCalendarNoteViewController
                
                glimpleViewController.strDate = self.strSelectedDate
                self.navigationController?.pushViewController(glimpleViewController, animated: true)
                
            }
        })
      }
    
    //MARK: - STOP BUTTON CLICK
      @objc func stopButtonClick(sender: UIButton!)
      {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            sender.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                 self.DISMISS_VC_NAV(animated: true)
            }
        })
    }
    
   
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    //MARK: - CVCalendarViewDelegate, CVCalendarMenuViewDelegate
    
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .monthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .sunday
    }
    
    // MARK: Optional methods
    
    func calendar() -> Calendar? {
        return currentCalendar
    }
    
    func dayOfWeekTextColor(by weekday: Weekday) -> UIColor {
       // return weekday == .sunday ? UIColor(red: 1.0, green: 0, blue: 0, alpha: 1.0) : UIColor.white
        
        return UIColor.white
    }
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    private func shouldSelectDayView(dayView: DayView) -> Bool {
        return arc4random_uniform(3) == 0 ? true : false
    }
    
    func shouldAutoSelectDayOnMonthChange() -> Bool {
        return false
    }
    
    func didSelectDayView(_ dayView: CVCalendarDayView, animationDidFinish: Bool) {
        arrList.removeAllObjects()
        selectedDay = dayView

        print(selectedDay.date.convertedDate()!)
        
        strSelectedDate = Alert.dateToString(date: selectedDay.date.convertedDate()!)
        arrList.removeAllObjects()
        tableViewCalendar.reloadData()
        
        for i in 0 ..< arrDates.count
        {
            let dict : NSDictionary! = arrDates.object(at: i) as! NSDictionary
            
            if(dict.value(forKey: "date") as! String == strSelectedDate)
            {
                arrList.add(dict)
                
            }
            
        }
        tableViewCalendar.reloadData()
        
        
    }
    
    func shouldSelectRange() -> Bool {
        return false
    }
    
    func presentedDateUpdated(_ date: CVDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(self.monthLabel.frame.origin.y)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.monthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.monthLabel.frame = updatedMonthLabel.frame
                self.monthLabel.text = updatedMonthLabel.text
                self.monthLabel.transform = CGAffineTransform.identity
                self.monthLabel.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    func topMarker(shouldDisplayOnDayView dayView: CVCalendarDayView) -> Bool {
        return true
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .short
    }
    
    func selectionViewPath() -> ((CGRect) -> (UIBezierPath)) {
        return { UIBezierPath(rect: CGRect(x: 0, y: 0, width: $0.width, height: $0.height)) }
    }
    
    func shouldShowCustomSingleSelection() -> Bool {
        return true
    }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.frame, shape: CVShape.circle)
        dayView.dayLabel.textColor = .white
        circleView.fillColor = .colorFromCode(0xCCCCCC)
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if (dayView.isCurrentDay) {
            return true
        }
        return false
    }
   
    /*
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        
        dayView.setNeedsLayout()
        dayView.layoutIfNeeded()
        
        let π = Double.pi
        
        let ringLayer = CAShapeLayer()
        let ringLineWidth: CGFloat = 4.0
        let ringLineColour = UIColor.blue
        
        let newView = UIView(frame: dayView.frame)
        
        let diameter = (min(newView.bounds.width, newView.bounds.height))
        let radius = diameter / 2.0 - ringLineWidth
        
        newView.layer.addSublayer(ringLayer)
        
        ringLayer.fillColor = nil
        ringLayer.lineWidth = ringLineWidth
        ringLayer.strokeColor = ringLineColour.cgColor
        
        let centrePoint = CGPoint(x: newView.bounds.width/2.0, y: newView.bounds.height/2.0)
        let startAngle = CGFloat(-π/2.0)
        let endAngle = CGFloat(π * 2.0) + startAngle
        let ringPath = UIBezierPath(arcCenter: centrePoint,
                                    radius: radius,
                                    startAngle: startAngle,
                                    endAngle: endAngle,
                                    clockwise: true)
        
        ringLayer.path = ringPath.cgPath
        ringLayer.frame = newView.layer.bounds
        
        return newView
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        
        guard let currentCalendar = currentCalendar else {
            return false
        }
        var components = Manager.componentsForDate(Foundation.Date(), calendar: currentCalendar)
        
        /* For consistency, always show supplementaryView on the 3rd, 13th and 23rd of the current month/year.  This is to check that these expected calendar days are "circled". There was a bug that was circling the wrong dates. A fix was put in for #408 #411.
         
         Other month and years show random days being circled as was done previously in the Demo code.
         */
        
        if dayView.date.year == components.year &&
            dayView.date.month == components.month {
            
            if (dayView.date.day == 3 || dayView.date.day == 13 || dayView.date.day == 23)  {
                print("Circle should appear on " + dayView.date.commonDescription)
                return true
            }
            return false
        } else {
            
            if (Int(arc4random_uniform(3)) == 1) {
                return true
            }
            
            return false
        }
        
    }
 */
    
    func dayOfWeekTextColor() -> UIColor {
        return UIColor.white
    }
    
    func dayOfWeekBackGroundColor() -> UIColor {
        return UIColor.clear
    }
    
    func disableScrollingBeforeDate() -> Date {
        return Date()
    }
    
    func maxSelectableRange() -> Int {
        return 1
    }
    
    func earliestSelectableDate() -> Date {
        return Date()
    }
    
    func latestSelectableDate() -> Date {
        var dayComponents = DateComponents()
        dayComponents.day = 70
        let calendar = Calendar(identifier: .gregorian)
        if let lastDate = calendar.date(byAdding: dayComponents, to: Date()) {
            return lastDate
        } else {
            return Date()
        }
    }
    
    
    
    //MARK: - CVCalendarViewAppearanceDelegate
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor
    {
        return Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_APPICON)
    }
    
    func dayLabelWeekdayDisabledColor() -> UIColor {
        return UIColor.lightGray
    }
    
    func dayLabelWeekdayInTextColor() -> UIColor
    {
        return UIColor.white
    }
    
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 0
    }
    
    func dayLabelFont(by weekDay: Weekday, status: CVStatus, present: CVPresent) -> UIFont {
        return UIFont.init(name: FONT.kFONT_REGULAR, size: 14)!
        
    }
    
    
    func dotMarkerColor() -> UIColor {
        
        return UIColor.white
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        
        return 15.0
        
    }
    
    
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool{
        // Look up date in dictionary
      




        if(arrMarkedDates[dayView.date.commonDescription] != nil){
            return true // date is in the array so draw a dot
        }
        return false
    }
    
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]{
        return [UIColor.white]
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool
    {
    return false
    }
    
    
    
    //MARK: - TableView DataSources & Delegate
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell", for: indexPath as IndexPath)
       
        for subview in cell.subviews {
            
            if subview.isKind(of: UITableViewCell.self)
            {
                subview.removeFromSuperview()
            }
        }
         
         
 
        let dict : NSDictionary! = arrList.object(at: indexPath.row) as! NSDictionary
        
        // Label Desc
        let labelDesc = UILabel.init(frame: CGRect(x: 16,y:10, width: Alert.kSCREEN_WIDTH() - 150, height: 40))
        labelDesc.textAlignment = .left
        labelDesc.text = dict.value(forKey: "title") as! String
        labelDesc.textColor = UIColor.black
        labelDesc.font = UIFont.init(name: FONT.kFONT_MEDIUM, size: 18)
        labelDesc.numberOfLines = 0
        
        
        let time = (dict.value(forKey: "time") as! String).components(separatedBy: ":")

        let AmPm : String!
        let intHour : Int!
        if(Int(time[0])! > 12)
        {
           AmPm = "PM"
            intHour = Int(time[0])! - 12
        }
        else
        {
            AmPm = "AM"
            intHour = Int(time[0])
        }
        
        
        // Label Hrs
        
        let labelHrs = UILabel.init(frame: CGRect(x: Alert.kSCREEN_WIDTH() - 100,y:4, width:47, height: 52))
        
        labelHrs.textAlignment = .center
        labelHrs.text = String(format:"%d",intHour)
        labelHrs.textColor = Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_HRS)
        labelHrs.font = UIFont.init(name: FONT.kFONT_ULTRA_LIGHT, size: 48)
        
        // Lable AM/PM
        
        let labelMin = UILabel.init(frame: CGRect(x:labelHrs.frame.size.width + labelHrs.frame.origin.x+20 ,y:14, width:36, height: 20))
        
        labelMin.textAlignment = .left
        labelMin.text = time[1]
        labelMin.textColor = Alert.colorFromHexString(hexCode: COLOR_CODE.COLOR_HRS)
        labelMin.font = UIFont.init(name: FONT.kFONT_LIGHT, size: 20)
        
       let labelAmPm = UILabel.init(frame: CGRect(x:labelHrs.frame.size.width + labelHrs.frame.origin.x+20 ,y:labelMin.frame.origin.y+labelMin.frame.size.height-4, width:36, height: 20))
        
        labelAmPm.text = AmPm
        labelAmPm.textAlignment = .left
        labelAmPm.textColor = UIColor.gray
        labelAmPm.font = UIFont.init(name: FONT.kFONT_LIGHT, size: 16)
        
        
        cell.addSubview(labelDesc)
        cell.addSubview(labelHrs)
        cell.addSubview(labelMin)
        cell.addSubview(labelAmPm)
        cell.selectionStyle = .none
        return cell
        
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
