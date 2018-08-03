//
//  NavigationHelpers.swift
//  LiveStoc
//
//  Created by Rajanikant Hole on 3/21/18.
//  Copyright © 2018 Harjit Singh. All rights reserved.
//

import  UIKit

class NavigationHelpers:NSObject{
    
    
  @objc   static func navigateToTab(){

        
        if UserDefaults.standard.bool(forKey: "LOGGEDIN")
        {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let tabViewController = mainStoryBoard.instantiateViewController(withIdentifier: "tabBar")
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = tabViewController
        }
        
        
    }
}
