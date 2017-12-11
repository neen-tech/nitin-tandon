//
//  PageContentViewController.swift
//  Glimpse
//
//  Created by Nitin on 10/6/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    var imageFileName: String!
    var pageIndex:Int!
    var pageControl = UIPageControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
     myImageView.image = UIImage(named:imageFileName)
        
      print("viewDidLoad imageView Frame : \(myImageView.frame) pageIndex : \(pageIndex)")
        
        self.configurePageControl()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
      
        
        print("viewWillAppear imageView Frame : \(myImageView.frame) pageIndex : \(pageIndex)")
        
        self.pageControl.currentPage = self.pageIndex
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        
         print("viewDidAppear imageView Frame : \(myImageView.frame) pageIndex : \(pageIndex)")
    }
    
    
    //MARK: - configurePageControl
    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        pageControl = UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - 180,width: UIScreen.main.bounds.width,height: 50))
        self.pageControl.numberOfPages = 4
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.gray
        self.pageControl.pageIndicatorTintColor = UIColor.white
        self.pageControl.currentPageIndicatorTintColor = UIColor.gray
        self.view.addSubview(pageControl)
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
