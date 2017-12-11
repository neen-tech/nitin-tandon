//
//  GlimpseViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/4/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class GlimpseViewController: UIViewController ,UIPageViewControllerDataSource,UIPageViewControllerDelegate,UIScrollViewDelegate {
    
    
    //MARk: -  Variables and DataTypes Declaration
    var pageControl = UIPageControl()
    var pageImages:NSArray!
    var pageViewController:UIPageViewController!
    @IBOutlet weak var buttonGetStarted:UIButton!
    
    fileprivate var currentIndex = 0
    fileprivate var lastPosition: CGFloat = 0
    
    
    //
    
    
   
    // MARK: - View Base Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // CONFIG VIEW
        
        self.config()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Hide Navigation Bar
        self.navigationController?.isNavigationBarHidden  = true
       
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    //MARK: - Config ViewController
    func config()  {
        
      
        // Page Array.....
        pageImages = NSArray(objects:"1242","bg4","bg3","bg2")
        
        // Get Page View ContollerScreen
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController
        
        // Data Source and Delegate
        self.pageViewController.dataSource = self
        self.pageViewController.delegate = self
        let initialContenViewController = self.pageTutorialAtIndex(0) as PageContentViewController
        
        // Set Direction for Paging
        self.pageViewController.setViewControllers([initialContenViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        
        // Set Page of Page Controller
        self.pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        // Add Paging and Content on Welcome Screen
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.buttonGetStated()
        self .buttonLogin()
     //   self.configurePageControl()
        self.view.backgroundColor = .black
        
        for view in self.pageViewController.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
                
                break
            }
        }
        
    }
    
    
    //MARK: - configurePageControl
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 180,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = pageImages.count
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray
        self.view.addSubview(pageControl)
    }
    
     //MARK: - buttonLogin
    func buttonLogin() {
        
        let button = UIButton(frame: CGRect(x: Alert.kSCREEN_WIDTH()/2-60, y: Alert.kSCREEN_HEIGHT()-56, width: 120, height: 30))
        button.backgroundColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.setTitle("LOGIN", for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size:16)
        button.addTarget(self, action: #selector(buttonLoginClick), for: .touchUpInside)
        self.view.addSubview(button)
    }
    
    //MARK: - buttonGetStated
    func buttonGetStated() {
        
        let button = UIButton(frame: CGRect(x: 71, y: Alert.kSCREEN_HEIGHT()-(64+51), width: Alert.kSCREEN_WIDTH() - (71*2), height: 51))
        button.backgroundColor = .clear
        button.setTitleColor(.black, for: .normal)
        button.setTitle("GET STARTED", for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size:16)
        button.addTarget(self, action: #selector(buttonGetStartedClick), for: .touchUpInside)
        
        button.roundCorners(corners: [.allCorners], radius: 51/2)
        
        self.view.addSubview(button)
        
     
    }

    @objc func buttonLoginClick(sender: UIButton!) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            sender.transform = CGAffineTransform.identity
            
            
        }, completion: {(finished) in
           
            DispatchQueue.main.async(){
                
                let loginVC = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_LOGIN_VC as NSString) as! LoginViewController
                
                self.MOVE(vc: loginVC, animated: true)
            }
            
           
           
            })
        
       /*
        Alert.CALL_DELAY_INSEC(delay: 1.0) {
            
            let loginVC = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_LOGIN_VC as NSString) as! LoginViewController
            
            self.MOVE(vc: loginVC, animated: true)
        }
        
      */
        
    }
    
    @objc func buttonGetStartedClick(sender: UIButton!) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 6, initialSpringVelocity: 4, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0.6, usingSpringWithDamping: 2, initialSpringVelocity: 10, options: [], animations: {
            sender.transform = CGAffineTransform.identity
        }, completion: {(finished) in
            
            DispatchQueue.main.async(){
                
                let genderVC = Alert.GET_VIEW_CONTROLLER(identifier: SB_ID.SBI_GENDER_PICKING_VC as NSString) as! GenderViewController
                
                self.MOVE(vc: genderVC, animated: true)
            }
            
           
            
        })
        
        
    }
    
    
    //MARK: - PageTutorial
    func pageTutorialAtIndex(_ index: Int) ->PageContentViewController
    {
        // Get Page Content View
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        pageContentViewController.imageFileName = pageImages[index] as! String
        pageContentViewController.pageIndex = index
        
        
        return pageContentViewController
        
    }
    
    //MARK: - UIPageViewControllerDelegate
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        // Manage Indexing before
        let viewController = viewController as! PageContentViewController
        var index = viewController.pageIndex as Int
        
        if(index == 0 || index == NSNotFound)
        {
            return nil
        }
        
        index -= 1
        
        return self.pageTutorialAtIndex(index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        // Manage Indexing After
        let viewController = viewController as! PageContentViewController
        var index = viewController.pageIndex as Int
        
        if((index == NSNotFound))
        {
            return nil
        }
        
        index += 1
        
        if(index == pageImages.count)
        {
            return nil
        }
        
        return self.pageTutorialAtIndex(index)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        var percentComplete: CGFloat
        percentComplete = fabs(point.x - view.frame.size.width)/view.frame.size.width
        NSLog("percentComplete: %f", percentComplete)
        
    }
    
    
  
    

    
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let pageContentViewController = pageViewController.viewControllers![0]
        currentIndex = pageImages.index(of: pageContentViewController)
        self.pageControl.currentPage = currentIndex
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


