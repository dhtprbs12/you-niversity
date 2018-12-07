//
//  CreateReviewUniversityViewController.swift
//  MyUniversity
//
//  Created by 오세균 on 7/13/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import DropDown
import XCGLogger
import RxCocoa
import RxSwift
import Material

class RevisionMyReviewViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate{
    
    //since universities.txt is too long to load
    var fakeUniversities = [String]()
    var shownUniversities = [String]()
    var allUniversities = [String]()
    
    var shownMajors = [String]()
    var allMajors = [String]()
    //view
    var scrollView: UIScrollView!
    var revisionMyReviewView: RevisionMyReviewView!
    let userDefault = UserDefaults.standard
    var tap : UITapGestureRecognizer!
    var object : BoardObject?
    let log = XCGLogger.default
    
    //dropdown
    let dropdownUniv = DropDown()
    let dropdownMajor = DropDown()
    var selected = String()
    
    var protoCall : GRPCProtoCall?
    
    
    override func loadView() {
        super.loadView()
        revisionMyReviewView = RevisionMyReviewView()
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let pathForFakeUniversities = Bundle.main.path(forResource: "fakeUniversities", ofType: "txt")
                let fileOfFakeUniversities = try String(contentsOfFile: pathForFakeUniversities!)
                self.fakeUniversities = fileOfFakeUniversities.components(separatedBy: "\n")
                
                let pathForUniversities = Bundle.main.path(forResource: "universities", ofType: "txt")
                let fileOfUniversities = try String(contentsOfFile: pathForUniversities!)
                self.allUniversities = fileOfUniversities.components(separatedBy: "\n")
                
                let pathForMajors = Bundle.main.path(forResource: "majors", ofType: "txt")
                let fileOfMajors = try String(contentsOfFile: pathForMajors!)
                self.allMajors = fileOfMajors.components(separatedBy: "\n")
                
            } catch {
                self.log.debug("Fatal Error: Couldn't read the contents!")
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = []
        self.userDefault.set(false, forKey: "Is_Review_Revised")
        //tap setting
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:revisionMyReviewView.bounds.width, height:revisionMyReviewView.bounds.height + 350)
        scrollView.addSubview(revisionMyReviewView)
        self.view.addSubview(scrollView)
        revisionMyReviewView.expressRegisterButton.rx.tap.subscribe({ [weak self] x in
            self?.reviseBtnTapped()
        }).disposed(by: App.disposeBag)
        
        //delegate
        revisionMyReviewView.universityTextField.delegate = self
        revisionMyReviewView.majorTextField.delegate = self
        revisionMyReviewView.expressShortSummaryTextField.delegate = self
        revisionMyReviewView.advantageTextView.delegate = self
        revisionMyReviewView.disadvantageTextView.delegate = self
        revisionMyReviewView.briefForTheMenteeTextView.delegate = self
        
        
        //set navigationBar.title
        self.title = "Edit My Review"
        
        //dropdown setting
        //dropdownUniv
        dropdownUniv.anchorView = revisionMyReviewView.majorTextField
        dropdownUniv.direction = .bottom
        //dropdownUniv.bottomOffset = CGPoint(x: 0, y:(dropdownUniv.anchorView?.plainView.bounds.height)!)
        dropdownUniv.backgroundColor = UIColor.white
        dropdownUniv.dataSource = fakeUniversities
        revisionMyReviewView.universityTextField
            .rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{!$0.isEmpty}
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.shownUniversities = self.allUniversities.filter { $0.uppercased().contains(query.uppercased()) } // 도시를 찾기 위한 “API 요청” 작업을 합니다.
                self.dropdownUniv.dataSource = self.shownUniversities
                self.dropdownUniv.reloadAllComponents()
                // 테이블 뷰를 다시 불러옵니다.
            })
            .disposed(by: App.disposeBag)
        
        // Action triggered on selection
        dropdownUniv.selectionAction = { [unowned self] (index, item) in
            self.revisionMyReviewView.universityTextField.text = item
            self.dropdownUniv.hide()
            self.view.endEditing(true)
        }
        
        //dropdownMajor
        dropdownMajor.anchorView = revisionMyReviewView.expressShortSummaryLabel
        dropdownMajor.frame.size.height = self.view.frame.size.width
        dropdownMajor.direction = .bottom
        //dropdownMajor.bottomOffset = CGPoint(x: 0, y:(dropdownMajor.anchorView?.plainView.bounds.height)!)
        dropdownMajor.backgroundColor = UIColor.white
        dropdownMajor.dataSource = allMajors
        revisionMyReviewView.majorTextField
            .rx.text
            .orEmpty
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter{!$0.isEmpty}
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.shownMajors = self.allMajors.filter { $0.uppercased().contains(query.uppercased()) } // 도시를 찾기 위한 “API 요청” 작업을 합니다.
                self.dropdownMajor.dataSource = self.shownMajors
                self.dropdownMajor.reloadAllComponents()
                // 테이블 뷰를 다시 불러옵니다.
            })
            .disposed(by: App.disposeBag)
        
        // Action triggered on selection
        dropdownMajor.selectionAction = { [unowned self] (index, item) in
            self.revisionMyReviewView.majorTextField.text = item
            self.dropdownMajor.hide()
            self.view.endEditing(true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.backgroundColor = UIColor.white
        loadMyReview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        //protoCall?.finishWithError(nil)
    }
    
    func loadMyReview(){
        let decoded  = userDefault.object(forKey: "board") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? BoardObject
        
        
        
        revisionMyReviewView.universityTextField.text = object?.board_university
        
        revisionMyReviewView.majorTextField.text = object?.board_major
        
        revisionMyReviewView.expressShortSummaryTextField.text = object?.board_title
        revisionMyReviewView.maximumCharForExpressField.text = "\(50-(revisionMyReviewView.expressShortSummaryTextField.text?.count)!)/50"
        
        
        if let advantageRange = object?.board_content.range(of: "\nDisadvantage:") {
            let substring = object?.board_content[..<advantageRange.lowerBound] // or str[str.startIndex..<range.lowerBound]
            let advantage = substring?.components(separatedBy: "Advantage:\n")[1]
            revisionMyReviewView.advantageTextView.text = advantage
            revisionMyReviewView.maximumCharForAdvantage.text = "\(1000-(revisionMyReviewView.advantageTextView.text.count))/1000"
            self.log.debug(advantage)
        }

        if let disadvantageRange = object?.board_content.range(of: "\nBrief:") {
            let substring = object?.board_content[..<disadvantageRange.lowerBound] // or str[str.startIndex..<range.lowerBound]
            let disadvantage = substring?.components(separatedBy: "Disadvantage:\n")[1]
            revisionMyReviewView.disadvantageTextView.text = disadvantage
            revisionMyReviewView.maximumCharForDisadvantage.text = "\(1000-(revisionMyReviewView.disadvantageTextView.text.count))/1000"
            self.log.debug(disadvantage)
        }
        let brief = object?.board_content.components(separatedBy: "Brief:\n")[1]
        revisionMyReviewView.briefForTheMenteeTextView.text = brief
        revisionMyReviewView.maximumCharForBrief.text = "\(1000-(revisionMyReviewView.briefForTheMenteeTextView.text.count))/1000"
        self.log.debug(brief)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        revisionMyReviewView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = textField.text?.count
        if textField == revisionMyReviewView.expressShortSummaryTextField{
            revisionMyReviewView.maximumCharForExpressField.text = "\((0) + count!)/50"
            return textField.text!.count +  (string.count - range.length) <= 50
        }
        
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? TextField{
            if textField.tag == 1{
                selected = "1"
                if(textField.text?.isEmpty)!{
                    dropdownUniv.dataSource = fakeUniversities
                }
                dropdownUniv.show()
                return true
            }else if textField.tag == 2{
                selected = "2"
                if(textField.text?.isEmpty)!{
                    dropdownMajor.dataSource = allMajors
                }
                dropdownMajor.show()
                return true
            }else{
                selected = "3"
                return true
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = textField as? TextField{
            if textField.tag == 1{
                _ = revisionMyReviewView.majorTextField.becomeFirstResponder()
                return false
            }else if textField.tag == 2{
                _ = revisionMyReviewView.expressShortSummaryTextField.becomeFirstResponder()
                return false
            }else{
                textField.resignFirstResponder()
                return false
            }
        }
        return false
    }
    
    
    //textview delegate
    func updateCharacterCount() {
        let countForAdvantage = revisionMyReviewView.advantageTextView.text.count
        let countForDisadvantage = revisionMyReviewView.disadvantageTextView.text.count
        let countForBrief = revisionMyReviewView.briefForTheMenteeTextView.text.count
        
        revisionMyReviewView.maximumCharForAdvantage.text = "\((0) + countForAdvantage)/1000"
        
        revisionMyReviewView.maximumCharForDisadvantage.text = "\((0) + countForDisadvantage)/1000"
        revisionMyReviewView.maximumCharForBrief.text = "\((0) + countForBrief)/1000"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == revisionMyReviewView.advantageTextView){
            return textView.text.count +  (text.count - range.length) <= 1000
        }else if(textView == revisionMyReviewView.disadvantageTextView){
            return textView.text.count +  (text.count - range.length) <= 1000
        }
        else{
            return textView.text.count +  (text.count - range.length) <= 1000
        }
        //return true
    }
    
    //textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let textView = textView as? TextView{
            if textView.tag == 4{
                selected = "4"
            }else if textView.tag == 5{
                selected = "5"
            }else{
                selected = "6"
            }
        }
    }
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //키보드 보여질때와 없어질때 실행되는 notification을 탐지해서 그에 해당하는 메소드를 실행
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name:NSNotification.Name.UIKeyboardDidShow, object: nil)
        //UIKeyboardWillShow 보다 UIKeyboardDidShow가 그 구간을 클릭해서 키보드를 보여줄때 적절함
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide), name:NSNotification.Name.UIKeyboardDidHide, object: nil)
        
    }
    
    //keyboard appear
    @objc func keyboardDidShow(notification:NSNotification){
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var aRect = self.view.frame
            aRect.size.height -= keyboardSize.size.height
            
            if selected == "1"{
                if (!aRect.contains(revisionMyReviewView.universityTextField.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(revisionMyReviewView.universityTextField.frame, animated: true)
                }
            }else if selected == "2"{
                if (!aRect.contains(revisionMyReviewView.majorTextField.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(revisionMyReviewView.majorTextField.frame, animated: true)
                }
            }else if selected == "3"{
                if (!aRect.contains(revisionMyReviewView.expressShortSummaryTextField.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(revisionMyReviewView.expressShortSummaryTextField.frame, animated: true)
                }
            }else if selected == "4"{
                if (!aRect.contains(revisionMyReviewView.advantageTextView.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(revisionMyReviewView.advantageTextView.frame, animated: true)
                }
            }else if selected == "5"{
                if (!aRect.contains(revisionMyReviewView.disadvantageTextView.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(revisionMyReviewView.disadvantageTextView.frame, animated: true)
                }
            }else{//mentorPrimaryCareerTextView
                if (!aRect.contains(revisionMyReviewView.briefForTheMenteeTextView.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(revisionMyReviewView.briefForTheMenteeTextView.frame, animated: true)
                }
            }
        }
        
    }
    
    //keyboard disappear
    @objc func keyboardDidHide(notification:NSNotification){
        let contentInsets : UIEdgeInsets = .zero
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
    }
}

extension RevisionMyReviewViewController{
    func reviseBtnTapped(){
        
        var isAllFilled : Bool = true
        
        if(revisionMyReviewView.universityTextField.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
        }
        
        if(revisionMyReviewView.majorTextField.text?.trimmed.isEmpty)!{
            isAllFilled = false
        }
        
        if (revisionMyReviewView.expressShortSummaryTextField.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        if (revisionMyReviewView.advantageTextView.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        
        if (revisionMyReviewView.disadvantageTextView.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        
        if (revisionMyReviewView.briefForTheMenteeTextView.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        
        if isAllFilled{
            
            //if both are filled, execute below
            //let realm = try! Realm()
            if CheckNetworkConnection.isConnectedToNetwork(){
                let request = ReviseMyReviewRequest()
                request.boardId = Int64((object?.board_id)!)
                request.boardUniversity = revisionMyReviewView.universityTextField.text?.trimmed
                request.boardMajor = revisionMyReviewView.majorTextField.text?.trimmed
                request.boardTitle = revisionMyReviewView.expressShortSummaryTextField.text?.trimmed
                request.boardContent = "Advantage:\n\(revisionMyReviewView.advantageTextView.text!.trimmed)\nDisadvantage:\n\(revisionMyReviewView.disadvantageTextView.text!.trimmed)\nBrief:\n\(revisionMyReviewView.briefForTheMenteeTextView.text!.trimmed)"
                
                
                GRPC.sharedInstance.authorizedUser.reviseMyReview(with:request, handler:{
                    (res,err) in
                    
                    if res != nil{
                        //self.protoCall?.finishWithError(nil)
                        
                        //fix here
                        self.view.window?.makeToast("Successfully Revised My Review", duration: 1.0, position: CSToastPositionBottom)
                        self.userDefault.set(true, forKey: "Is_Review_Revised")
                        self.navigationController?.popViewController(animated: true)

                        
                        
                    }else{
                        self.userDefault.set(false, forKey: "Is_Review_Revised")
                        self.log.debug("Revised My Review Error: \(err)")
                        //self.protoCall?.finishWithError(err)
                        if(err != nil){
                            self.view.window?.makeToast("Revised My Review Error, Try Again", duration: 1.0, position: CSToastPositionBottom)
                        }
                    }
                    //need to cancel request no matter succeeded or failed
                    //GRPC.sharedInstance.rpcCall.cancel()
                })
                //protoCall?.timeout = App.timeout
                //protoCall?.start()
            }else{
                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
            }
        }else{
            self.view.window?.makeToast("Please, fill out every fields!", duration: 1.0, position: CSToastPositionBottom)
        }
    }
}
