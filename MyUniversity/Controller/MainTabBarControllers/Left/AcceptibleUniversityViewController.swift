//
//  AcceptibleUniversityViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 6. 14..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import RealmSwift

extension String {
    var isNumeric : Bool {
        get {
            return Double(self) != nil
        }
    }
}

class AcceptibleUniversityViewController:UIViewController, UIScrollViewDelegate, UITextFieldDelegate{
    
    var scrollView: UIScrollView!
    var acceptibleUnivView: AcceptibleUniversityView!
    var tap : UITapGestureRecognizer!
    let log = XCGLogger.default
    var satOrAct : String = "SAT"
    let userDefault = UserDefaults.standard
    
    override func loadView() {
        super.loadView()
        acceptibleUnivView = AcceptibleUniversityView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.title = "Find Your University"
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:acceptibleUnivView.bounds.width, height:acceptibleUnivView.bounds.height+100)
        scrollView.addSubview(acceptibleUnivView)
        acceptibleUnivView.findBtn.rx.tap.subscribe({ [weak self] x in
            self?.findBtnTapped()
        }).disposed(by: App.disposeBag)
        self.view.addSubview(scrollView)
        
        //delegate
        acceptibleUnivView.actOrSatScoreTextField.delegate = self
        acceptibleUnivView.gpaTextField.delegate = self
        
        //button add targets
        //UISegmentControl
        acceptibleUnivView.actOrSatSegment.addTarget(self, action: #selector(actOrSatSegmentTapped), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //키보드 보여질때와 없어질때 실행되는 notification을 탐지해서 그에 해당하는 메소드를 실행
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    //keyboard appear
    @objc func keyboardWillShow(notification:NSNotification){
        
        if let activeField = acceptibleUnivView.gpaTextField, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            if (!aRect.contains(activeField.frame.origin)) {
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    //keyboard disappear
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInsets : UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        acceptibleUnivView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    func findBtnTapped(){
        
        //check if fields are filled
        if (acceptibleUnivView.actOrSatScoreTextField.text?.trimmed.isEmpty)!{
            self.view.window?.makeToast("Type your SAT/ACT score", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        if (acceptibleUnivView.gpaTextField.text?.trimmed.isEmpty)!{
            self.view.window?.makeToast("Type your GPA score", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        if acceptibleUnivView.actOrSatScoreTextField.text?.isNumeric == false{
            self.view.window?.makeToast("Type number for your SAT or ACT score", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        if acceptibleUnivView.gpaTextField.text?.isNumeric == false{
            self.view.window?.makeToast("Type number for your GPA score", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        //if all fields are filled, go to MyUniversityViewController with values
        userDefault.set(satOrAct, forKey: "sat_act")
        userDefault.set(acceptibleUnivView.actOrSatScoreTextField.text?.trimmed, forKey: "score")
        userDefault.set(acceptibleUnivView.gpaTextField.text?.trimmed, forKey: "gpa")
        userDefault.synchronize()
        navigationController?.pushViewController(MyUniversityViewController(), animated: true)
        
    }
    
    @objc func actOrSatSegmentTapped(sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            satOrAct = "SAT"
        default:
            satOrAct = "ACT"
            
        }
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }

}
