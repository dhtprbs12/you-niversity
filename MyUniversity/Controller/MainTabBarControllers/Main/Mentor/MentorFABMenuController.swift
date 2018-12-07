//
//  MentorFABMenuController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 19..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import Material
import RealmSwift

class MentorFABMenuController: FABMenuController {
    fileprivate let fabMenuSize = CGSize(width: 56, height: 56)
    fileprivate let bottomInset: CGFloat = 60
    fileprivate let rightInset: CGFloat = 10
    
    fileprivate var fabButton: FABButton!
    fileprivate var bestMentorFABMenuItem: FABMenuItem!
    fileprivate var latestMentorFABMenuItem: FABMenuItem!
    fileprivate var wannabeMentorFABMenuItem: FABMenuItem!
    fileprivate var findMentorFABMenuItem: FABMenuItem!
    
    var selectedOption:[String:String] = ["option":"Best"]
    
    open override func prepare() {
        super.prepare()
        view.backgroundColor = .white

        prepareFABButton()
        prepareBestMentorFABMenuItem()
        prepareLatestMentorFABMenuItem()
        prepareWannabeMentorFABMenuItem()
        prepareFindMentorFABMenuItem()
        prepareFABMenu()
    }
}

extension MentorFABMenuController {
    fileprivate func prepareFABButton() {
        fabButton = FABButton(image: Icon.cm.add, tintColor: .white)
        fabButton.pulseColor = .white
        fabButton.backgroundColor = Color.orange.base
    }
    
    fileprivate func prepareBestMentorFABMenuItem() {
        bestMentorFABMenuItem = FABMenuItem()
        bestMentorFABMenuItem.title = "Best Mentor"
        //bestMentorFABMenuItem.titleLabel.layer.borderWidth = 1
        bestMentorFABMenuItem.fabButton.image = UIImage(named:"ic_thumb_up_white")
        bestMentorFABMenuItem.fabButton.tintColor = .white
        bestMentorFABMenuItem.fabButton.pulseColor = .white
        bestMentorFABMenuItem.fabButton.backgroundColor = Color.red.base
        bestMentorFABMenuItem.fabButton.addTarget(self, action: #selector(handleBestMentorFABMenuItem(button:)), for: .touchUpInside)
    }
    
    fileprivate func prepareLatestMentorFABMenuItem() {
        latestMentorFABMenuItem = FABMenuItem()
        latestMentorFABMenuItem.title = "Latest Mentor"
        //latestMentorFABMenuItem.titleLabel.layer.borderWidth = 1
        latestMentorFABMenuItem.fabButton.image = UIImage(named:"ic_hearing_white")
        latestMentorFABMenuItem.fabButton.tintColor = .white
        latestMentorFABMenuItem.fabButton.pulseColor = .white
        latestMentorFABMenuItem.fabButton.backgroundColor = Color.yellow.base
        latestMentorFABMenuItem.fabButton.addTarget(self, action: #selector(handleLatestMentorFABMenuItem(button:)), for: .touchUpInside)
    }
    
    fileprivate func prepareWannabeMentorFABMenuItem() {
        wannabeMentorFABMenuItem = FABMenuItem()
        let realm = try! Realm()
//        //if user has registered as a mentor, go to revision VC
//        //if not, go to register VC
//        if (realm.objects(MentorInfo.self).first == nil){
//            wannabeMentorFABMenuItem.title = "Wanna be a mentor?"
//        }else{
//            wannabeMentorFABMenuItem.title = "Revise My Mentor Info"
//        }
        wannabeMentorFABMenuItem.title = "Be a mentor"
        //wannabeMentorFABMenuItem.titleLabel.layer.borderWidth = 1
        wannabeMentorFABMenuItem.fabButton.image = Icon.cm.pen
        wannabeMentorFABMenuItem.fabButton.tintColor = .white
        wannabeMentorFABMenuItem.fabButton.pulseColor = .white
        wannabeMentorFABMenuItem.fabButton.backgroundColor = Color.green.base
        wannabeMentorFABMenuItem.fabButton.addTarget(self, action: #selector(handleWannabeMentorFABMenuItem(button:)), for: .touchUpInside)
    }
    
    fileprivate func prepareFindMentorFABMenuItem() {
        findMentorFABMenuItem = FABMenuItem()
        findMentorFABMenuItem.title = "Search Mentor By University"
        findMentorFABMenuItem.fabButton.image = Icon.cm.search
        findMentorFABMenuItem.fabButton.tintColor = .white
        findMentorFABMenuItem.fabButton.pulseColor = .white
        findMentorFABMenuItem.fabButton.backgroundColor = Color.blue.base
        findMentorFABMenuItem.fabButton.addTarget(self, action: #selector(handleFindMentorFABMenuItem(button:)), for: .touchUpInside)
    }
    
    fileprivate func prepareFABMenu() {
        fabMenu.fabButton = fabButton
        fabMenu.fabMenuItems = [findMentorFABMenuItem,bestMentorFABMenuItem,latestMentorFABMenuItem,wannabeMentorFABMenuItem]
        fabMenuBacking = .none
        
        view.layout(fabMenu)
            .bottom(bottomInset)
            .right(rightInset)
            .size(fabMenuSize)
    }
}

extension MentorFABMenuController {
    @objc
    fileprivate func handleBestMentorFABMenuItem(button: UIButton) {
        //transition(to: NotesViewController())
        selectedOption = ["option":"Best"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mentorTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
    
    @objc
    fileprivate func handleLatestMentorFABMenuItem(button: UIButton) {
        //transition(to: RemindersViewController())
        selectedOption = ["option":"Latest"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mentorTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
    
    @objc
    fileprivate func handleWannabeMentorFABMenuItem(button: UIButton) {
        //transition(to: RemindersViewController())
        selectedOption = ["option":"Wannabe"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mentorTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
    
    @objc
    fileprivate func handleFindMentorFABMenuItem(button: UIButton) {
        //transition(to: RemindersViewController())
        selectedOption = ["option":"Search"]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mentorTable"), object: nil, userInfo: selectedOption)
        fabMenu.close()
        fabMenu.fabButton?.animate(.rotate(0))
    }
}

extension MentorFABMenuController {
    @objc
    open func fabMenuWillOpen(fabMenu: FABMenu) {
        fabMenu.fabButton?.animate(.rotate(45))
        
        print("fabMenuWillOpen")
    }
    
    @objc
    open func fabMenuDidOpen(fabMenu: FABMenu) {
        print("fabMenuDidOpen")
    }
    
    @objc
    open func fabMenuWillClose(fabMenu: FABMenu) {
        fabMenu.fabButton?.animate(.rotate(0))
        
        print("fabMenuWillClose")
    }
    
    @objc
    open func fabMenuDidClose(fabMenu: FABMenu) {
        print("fabMenuDidClose")
    }
    
    @objc
    open func fabMenu(fabMenu: FABMenu, tappedAt point: CGPoint, isOutside: Bool) {
        print("fabMenuTappedAtPointIsOutside", point, isOutside)
        
        guard isOutside else {
            return
        }
        
        // Do something ...
    }
}
