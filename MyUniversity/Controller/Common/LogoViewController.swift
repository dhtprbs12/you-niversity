//
//  LogoViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material

class LogoViewController: UIViewController{
    
    var logoView : LogoView{
        return self.view as! LogoView
        
    }
    
    override func loadView() {
        super.loadView()
        self.view = LogoView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //animate MyUniversity label for 2 seconds
        UIView.animate(withDuration: 2.0, animations: {
            self.logoView.logoLabel.center.y += self.view.bounds.width
        }, completion: { _ -> Void in
            self.present(VerificationViewController(), animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        print("LogoViewController deinit()")
    }
    
}
