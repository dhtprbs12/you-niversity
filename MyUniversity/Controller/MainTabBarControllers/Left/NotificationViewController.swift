//
//  NotificationViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 3. 20..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import XCGLogger

class NotificationViewController:UITableViewController{
    //UISwitch
    let pushSwitch = UISwitch()
    let userDefault = UserDefaults.standard
    let log = XCGLogger.default
    var protoCall:GRPCProtoCall?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Notification"
        //addTarget on uiswitches
        pushSwitch.addTarget(self, action: #selector(pushSwitchChanged(_:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let realm = try! Realm()
        if let obj = realm.objects(UserInfo.self).first{
            if obj.push == 1{//1 = true, 0 = false
                pushSwitch.setOn(true, animated: true)
            }else{
                pushSwitch.setOn(false, animated: true)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //protoCall?.finishWithError(nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //value1 => detailTextLabel 오른쪽으로 보내줌
        let cell : UITableViewCell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        
        cell.textLabel?.text = "Push"
        cell.detailTextLabel?.text = "Turn on to get notification"
        cell.accessoryView = pushSwitch
        
        
        return cell
    }
    
    //when user taps push switch
    @objc func pushSwitchChanged(_ mySwitch: UISwitch){
        
        let pushRealm = try! Realm()
        
        if mySwitch.isOn {
            // handle on
            self.pushSwitch.setOn(true, animated: true)
            if let user = pushRealm.objects(UserInfo.self).first{
                
                try! pushRealm.write {
                    user.push = 1
                }
            }
            serverCall(value: 1)
            
        } else {
            // handle off
            self.pushSwitch.setOn(false, animated: true)
            if let user = pushRealm.objects(UserInfo.self).first{
                
                try! pushRealm.write {
                    user.push = 0
                }
            }
            serverCall(value: 0)
        }
    }
    
    func serverCall(value:Int){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = PushUpdateRequest()
            request.value = Int64(value)
            request.userId = Int64(userDefault.integer(forKey: "user_id"))
            
            GRPC.sharedInstance.authorizedUser.pushUpdate(with:request,handler:{
                (res,err) in
                if res != nil{
                    //self.protoCall?.finishWithError(nil)
                }else{
                    self.log.debug("Push Update Error:\(err)")
                    //self.protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Push Update Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //GRPC.sharedInstance.rpcCall.cancel()
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
        }
    }
}

