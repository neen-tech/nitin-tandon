//
//  DiscoverViewController.swift
//  Glimpse
//
//  Created by Rameshwar on 10/11/17.
//  Copyright © 2017 Nitin. All rights reserved.
//

import UIKit
import GoogleMaps


class DiscoverViewController: UIViewController, GMSMapViewDelegate {

   var searchBarMap = UISearchBar()
    var mapView = GMSMapView()
    override func viewDidLoad() {
        super.viewDidLoad()

        loadCustomiseNavBar()
        loadCustomiseSearchBar()
        
      

            self.loadMapView()
            
       
        
      
    }
    
    //MARK: - load customise searchbar...
    func loadCustomiseSearchBar()
    {
        self.searchBarMap                   = UISearchBar.init(frame: CGRect(x:0, y:0, width:Alert.kSCREEN_WIDTH(),height: 56))
       self.searchBarMap.placeholder = "Nearby Users"
        self.searchBarMap.backgroundColor   = .clear
        searchBarMap.barStyle = .default
        searchBarMap.searchBarStyle = .minimal
        let textFieldInsideSearchBar = self.searchBarMap.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.placeholder = "Nearby Users"
        textFieldInsideSearchBar?.textColor = UIColor.white
        textFieldInsideSearchBar?.textAlignment = .center
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar!.value(forKey: "placeholderLabel") as? UILabel
        textFieldInsideSearchBarLabel?.textColor = UIColor.white
        textFieldInsideSearchBarLabel?.textAlignment = .center
        self.view.addSubview(self.searchBarMap)
    }

    func loadCustomiseNavBar() -> Void {
        
          self.view.backgroundColor = Alert.colorFromHexString(hexCode: COLOR_CODE.DASHBOARD_BG_COLOR)
        self.edgesForExtendedLayout = .init(rawValue: 0)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationBar.barTintColor = Alert.colorFromHexString(hexCode: COLOR_CODE.NAVCOLOR)
        
        self.navigationController?.navigationBar.tintColor = .white
        
        // Nav Button Cancel
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(goBack))
        
        
        // Nav Button Logout
        
        navigationItem.rightBarButtonItems = [Alert.LOGOUT_BUTTON()]
        
        // Nav Image
        let imageView = UIImageView(image: #imageLiteral(resourceName: "logo"))
        
        imageView.frame = CGRect(x: Alert.kSCREEN_WIDTH()/2-50, y: 0, width: 100, height: 45)
        self.navigationController?.navigationBar.addSubview(imageView)
        
    }
    
    //MARK: LoadMapView
    
    func loadMapView() -> Void {
        
        DispatchQueue.main.async(execute: {
 
        
            let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 6.0)
            
            self.mapView = GMSMapView.map(withFrame:CGRect(x:0, y: self.searchBarMap.frame.origin.y+self.searchBarMap.frame.size.height,width:Alert.kSCREEN_WIDTH(),height:Alert.kSCREEN_HEIGHT() - 110) , camera: camera)
            self.mapView.delegate = self
            self.mapView.isMyLocationEnabled = true
            self.mapView.settings.myLocationButton = true
            self.view.addSubview(self.mapView)
        
        
       
        
        // Create Marker Pin Static
        
        
        let markerPin = UIView(frame:CGRect(x:0, y:0, width: 100, height: 100))
        markerPin.backgroundColor = .clear
        
        let imgMarkerPin = UIImageView(image:#imageLiteral(resourceName: "pin"))
        imgMarkerPin.frame = CGRect(x:0 , y:0   , width: 80 , height: 80)
        markerPin.addSubview(imgMarkerPin)
        
        let userImage = UIImageView(image:#imageLiteral(resourceName: "ana"))
        userImage.frame = CGRect(x:15 , y:0   , width: 50 , height: 50)
        userImage.layer.cornerRadius = 25;
        userImage.clipsToBounds = true
        imgMarkerPin.addSubview(userImage)
        
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.iconView = markerPin
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.userData = "Noida, India"
        marker.map = self.mapView
       
        })
    }
    
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool
//    {
////        let moveController = UserProfileViewController()
////        self.navigationController?.pushViewController(moveController, animated: true)
//
//        return true
//    }
    
    // MARK: hitLogout
    
    @objc func hitLogout(sender: UIBarButtonItem!) {
        
        
        
    }
    
    // MARK: goBack
    
    @objc func goBack(sender: UIBarButtonItem!){
        self.navigationController?.popViewController(animated: true)
        
    }

}
