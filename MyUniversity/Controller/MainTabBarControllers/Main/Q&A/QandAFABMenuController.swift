//
//  AppFABMenuController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 17..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import Material

class QandAFABMenuController: FABMenuController {
    fileprivate let fabMenuSize = CGSize(width: 56, height: 56)
    fileprivate let bottomInset: CGFloat = 60
    fileprivate let rightInset: CGFloat = 10
    
    fileprivate var fabButton: FABButton!
    fileprivate var commonBoardFABMenuItem: FABMenuItem!
    fileprivate var reviewFABMenuItem: FABMenuItem!
    fileprivate var qandaFABMenuItem: FABMenuItem!
    fileprivate var createBoardMenuItem: FABMenuItem!
    
    var selectedOption:[String:String] = ["option":"Common Board"]
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = .white

        prepareFABButton()
        prepareCreateBoardABMenuItem()
        prepareCommonBoardFABMenuItem()
        prepareReviewFABMenuItem()
        prepareUniversityQandAFABMenuItem()
        prepareFABMenu()
    }
}

extension QandAFABMenuController {
    fileprivate func prepareFABButton() {
        fabButton = FABButton(image: Icon.cm.add, tintColor: .white)
        fabButton.pulseColor = .white
        fabButton.backgroundColor = Color.orange.base
    }
    
    fileprivate func prepareCreateBoardABMenuItem() {
        createBoardMenuItem = FABMenuItem()
        createBoardMenuItem.title = "Create Board"
        createBoardMenuItem.fabButton.image = UIImage(named:"ic_create_white")
        createBoardMenuItem.fabButton.tintColor = .white
        createBoardMenuItem.fabButton.pulseColor = .white
        createBoardMenuItem.fabButton.backgroundColor = Color.blue.base
        createBoardMenuItem.fabButton.addTarget(self, action: #selector(handleCreateBoardFABMenuItem(button:)), for: .touchUpInside)
    }
    
    fileprivate func prepareCommonBoardFABMenuItem() {
        commonBoardFABMenuItem = FABMenuItem()
        commonBoardFABMenuItem.title = "Common Board"
        commonBoardFABMenuItem.fabButton.image = UIImage(named:"ic_dashboard_white")
        commonBoardFABMenuItem.fabButton.tintColor = .white
        commonBoardFABMenuItem.fabButton.pulseColor = .white
        
        commonBoardFABMenuItem.fabButton.backgroundColor = Color.red.base
        commonBoardFABMenuItem.fabButton.addTarget(self, action: #selector(handleCommonBoardFABMenuItem(button:)), for: .touchUpInside)
    }
    
    fileprivate func prepareReviewFABMenuItem() {
        reviewFABMenuItem = FABMenuItem()
        reviewFABMenuItem.title = "Universities Review"
        
        reviewFABMenuItem.fabButton.image = Icon.cm.share
        reviewFABMenuItem.fabButton.tintColor = .white
        reviewFABMenuItem.fabButton.pulseColor = .white
        reviewFABMenuItem.fabButton.backgroundColor = Color.yellow.base
        reviewFABMenuItem.fabButton.addTarget(self, action: #selector(handleReviewFABMenuItem(button:)), for: .touchUpInside)
    }
    
    fileprivate func prepareUniversityQandAFABMenuItem() {
        qandaFABMenuItem = FABMenuItem()
        qandaFABMenuItem.title = "Q&A On Universities"
        qandaFABMenuItem.fabButton.image = UIImage(named:"ic_live_help_white")
        qandaFABMenuItem.fabButton.tintColor = .white
        qandaFABMenuItem.fabButton.pulseColor = .white
        qandaFABMenuItem.fabButton.backgroundColor = Color.green.base
        qandaFABMenuItem.fabButton.addTarget(self, action: #selector(handleUniversityQandAFABMenuItem(button:)), for: .touchUpInside)
    }
    
    
    
    fileprivate func prepareFABMenu() {
        fabMenu.fabButton = fabButton
        fabMenu.fabMenuItems = [createBoardMenuItem,commonBoardFABMenuItem,reviewFABMenuItem,qandaFABMenuItem]
        fabMenuBacking = .none
        
        view.layout(fabMenu)
            .bottom(bottomInset)
            .right(rightInset)
            .size(fabMenuSize)
    }
}

extension QandAFABMenuController {
    
    @objc
    fileprivate func handleCreateBoardFABMenuItem(button: UIButton){
        selectedOption = ["option":"Create Board"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qandaTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
    
    @objc
    fileprivate func handleCommonBoardFABMenuItem(button: UIButton) {
        //transition(to: NotesViewController())
        selectedOption = ["option":"Common Board"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qandaTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
    
    @objc
    fileprivate func handleReviewFABMenuItem(button: UIButton) {
        //transition(to: RemindersViewController())
        selectedOption = ["option":"Universities Review"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qandaTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
    
    @objc
    fileprivate func handleUniversityQandAFABMenuItem(button: UIButton) {
        //transition(to: RemindersViewController())
        selectedOption = ["option":"Q&A On Universities"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qandaTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
    
}

extension QandAFABMenuController {
    @objc
    open func fabMenuWillOpen(fabMenu: FABMenu) {
        fabMenu.fabButton?.animate(.rotate(45))
        
        //print("fabMenuWillOpen")
    }
    
    @objc
    open func fabMenuDidOpen(fabMenu: FABMenu) {
        //print("fabMenuDidOpen")
    }
    
    @objc
    open func fabMenuWillClose(fabMenu: FABMenu) {
        fabMenu.fabButton?.animate(.rotate(0))
        
        //print("fabMenuWillClose")
    }
    
    @objc
    open func fabMenuDidClose(fabMenu: FABMenu) {
        //print("fabMenuDidClose")
    }
    
    @objc
    open func fabMenu(fabMenu: FABMenu, tappedAt point: CGPoint, isOutside: Bool) {
        //print("fabMenuTappedAtPointIsOutside", point, isOutside)
        
        guard isOutside else {
            return
        }
        
        // Do something ...
    }
}
