//
//  AppToolBarController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 12..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material

class AppToolbarController: ToolbarController {
    fileprivate var menuButton: IconButton!
    //fileprivate var switchControl: Switch!
    fileprivate var notificationButton: IconButton!
    fileprivate var searchButton: IconButton!
    
    override func prepare() {
        super.prepare()
        self.toolbar.title = "You-university"
        self.toolbar.detail = "Welcome"
        prepareMenuButton()
        //prepareSwitch()
        prepareNotificationButton()
        prepareSearchButton()
        prepareStatusBar()
        prepareToolbar()
        
    }
}

extension AppToolbarController {
    fileprivate func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
        menuButton.addTarget(self, action: #selector(handleMenuButton), for: .touchUpInside)
    }
    
//    fileprivate func prepareSwitch() {
//        switchControl = Switch(state: .off, style: .light, size: .small)
//    }
    
    fileprivate func prepareNotificationButton() {
        notificationButton = IconButton(image: Icon.cm.bell)
        notificationButton.addTarget(self, action: #selector(handleNotificationButton), for: .touchUpInside)
    }
    
    fileprivate func prepareSearchButton() {
        searchButton = IconButton(image: Icon.cm.search)
        searchButton.addTarget(self, action: #selector(handleSearchButton), for: .touchUpInside)
    }
    
    fileprivate func prepareStatusBar() {
        statusBarStyle = .lightContent
        
        // Access the statusBar.
        //        statusBar.backgroundColor = Color.green.base
    }
    
    fileprivate func prepareToolbar() {
        toolbar.leftViews = [menuButton]
        //toolbar.rightViews = [searchButton]
        toolbar.rightViews = [searchButton,notificationButton]
    }
}

extension AppToolbarController {
    @objc
    fileprivate func handleMenuButton() {
        navigationDrawerController?.toggleLeftView()
    }

    @objc
    fileprivate func handleNotificationButton() {
        navigationDrawerController?.toggleRightView()
    }
    
    @objc
    fileprivate func handleSearchButton() {
        navigationDrawerController?.toggleRightView()
    }
}
