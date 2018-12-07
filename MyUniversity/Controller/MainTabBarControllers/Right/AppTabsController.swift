//
//  AppTabsController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 14..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material

class AppTabsController: TabsController {
    open override func prepare() {
        super.prepare()
        tabBar.setLineColor(Color.orange.base, for: .selected) // or tabBar.lineColor = Color.orange.base
        
        tabBar.setTabItemsColor(Color.grey.base, for: .normal)
        tabBar.setTabItemsColor(Color.purple.base, for: .selected)
        tabBar.setTabItemsColor(Color.green.base, for: .highlighted)
        
        
        //        tabBarAlignment = .top
        //        tabBar.tabBarStyle = .auto
        //        tabBar.dividerColor = nil
        //        tabBar.lineHeight = 5.0
        //        tabBar.lineAlignment = .bottom
        //        tabBar.backgroundColor = Color.blue.darken2
    }
}
