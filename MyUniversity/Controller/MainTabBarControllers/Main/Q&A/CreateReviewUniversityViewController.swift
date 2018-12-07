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

class CreateReviewUniversityViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate{
    
    //since universities.txt is too long to load
    var fakeUniversities = [String]()
    var shownUniversities = [String]()
    var allUniversities = [String]()
    
    var shownMajors = [String]()
    var allMajors = [String]()
    //view
    var scrollView: UIScrollView!
    var createReviewUniversityView: CreateReviewUniversityView!
    let userDefault = UserDefaults.standard
    var tap : UITapGestureRecognizer!
    let log = XCGLogger.default
    
    //dropdown
    let dropdownUniv = DropDown()
    let dropdownMajor = DropDown()
    var selected = String()
    
    var protoCall : GRPCProtoCall?
    
    
    override func loadView() {
        super.loadView()
        createReviewUniversityView = CreateReviewUniversityView()
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.removeObserver(self)
        //protoCall?.finishWithError(nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //need to comment below statement when using scrollView
        self.edgesForExtendedLayout = []
        //tap setting
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        //tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:createReviewUniversityView.bounds.width, height:createReviewUniversityView.bounds.height + 350)
        scrollView.addSubview(createReviewUniversityView)
        self.view.addSubview(scrollView)
        createReviewUniversityView.expressRegisterButton.rx.tap.subscribe({ [weak self] x in
            self?.expressBtnTapped()
        }).disposed(by: App.disposeBag)
        
        //delegate
        createReviewUniversityView.universityTextField.delegate = self
        createReviewUniversityView.majorTextField.delegate = self
        createReviewUniversityView.expressShortSummaryTextField.delegate = self
        createReviewUniversityView.advantageTextView.delegate = self
        createReviewUniversityView.disadvantageTextView.delegate = self
        createReviewUniversityView.briefForTheMenteeTextView.delegate = self
        
        
        //set navigationBar.title
        self.title = userDefault.string(forKey: "tableName")
        
        //dropdown setting
        //dropdownUniv
        dropdownUniv.anchorView = createReviewUniversityView.majorTextField
        dropdownUniv.direction = .bottom
        //dropdownUniv.bottomOffset = CGPoint(x: 0, y:(dropdownUniv.anchorView?.plainView.bounds.height)!)
        dropdownUniv.backgroundColor = UIColor.white
        dropdownUniv.dataSource = fakeUniversities
        createReviewUniversityView.universityTextField
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
            self.createReviewUniversityView.universityTextField.text = item
            self.dropdownUniv.hide()
            self.view.endEditing(true)
        }
        
        //dropdownMajor
        dropdownMajor.anchorView = createReviewUniversityView.expressShortSummaryLabel
        dropdownMajor.frame.size.height = self.view.frame.size.width
        dropdownMajor.direction = .bottom
        //dropdownMajor.bottomOffset = CGPoint(x: 0, y:(dropdownMajor.anchorView?.plainView.bounds.height)!)
        dropdownMajor.backgroundColor = UIColor.white
        dropdownMajor.dataSource = allMajors
        createReviewUniversityView.majorTextField
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
            self.createReviewUniversityView.majorTextField.text = item
            self.dropdownMajor.hide()
            self.view.endEditing(true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        createReviewUniversityView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = textField.text?.count
        if textField == createReviewUniversityView.expressShortSummaryTextField{
            createReviewUniversityView.maximumCharForExpressField.text = "\((0) + count!)/50"
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
                _ = createReviewUniversityView.majorTextField.becomeFirstResponder()
                return false
            }else if textField.tag == 2{
                _ = createReviewUniversityView.expressShortSummaryTextField.becomeFirstResponder()
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
        let countForAdvantage = createReviewUniversityView.advantageTextView.text.count
        let countForDisadvantage = createReviewUniversityView.disadvantageTextView.text.count
        let countForBrief = createReviewUniversityView.briefForTheMenteeTextView.text.count
        
        createReviewUniversityView.maximumCharForAdvantage.text = "\((0) + countForAdvantage)/1000"
        
        createReviewUniversityView.maximumCharForDisadvantage.text = "\((0) + countForDisadvantage)/1000"
        createReviewUniversityView.maximumCharForBrief.text = "\((0) + countForBrief)/1000"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == createReviewUniversityView.advantageTextView){
            return textView.text.count +  (text.count - range.length) <= 1000
        }else if(textView == createReviewUniversityView.disadvantageTextView){
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
                if (!aRect.contains(createReviewUniversityView.universityTextField.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(createReviewUniversityView.universityTextField.frame, animated: true)
                }
            }else if selected == "2"{
                if (!aRect.contains(createReviewUniversityView.majorTextField.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(createReviewUniversityView.majorTextField.frame, animated: true)
                }
            }else if selected == "3"{
                if (!aRect.contains(createReviewUniversityView.expressShortSummaryTextField.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(createReviewUniversityView.expressShortSummaryTextField.frame, animated: true)
                }
            }else if selected == "4"{
                if (!aRect.contains(createReviewUniversityView.advantageTextView.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(createReviewUniversityView.advantageTextView.frame, animated: true)
                }
            }else if selected == "5"{
                if (!aRect.contains(createReviewUniversityView.disadvantageTextView.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(createReviewUniversityView.disadvantageTextView.frame, animated: true)
                }
            }else{//mentorPrimaryCareerTextView
                if (!aRect.contains(createReviewUniversityView.briefForTheMenteeTextView.frame.origin)) {
                    self.log.debug()
                    self.scrollView.scrollRectToVisible(createReviewUniversityView.briefForTheMenteeTextView.frame, animated: true)
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

extension CreateReviewUniversityViewController{
    func expressBtnTapped(){
        self.view.endEditing(true)
        var isAllFilled : Bool = true
        
        if(createReviewUniversityView.universityTextField.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
        }
        
        if(createReviewUniversityView.majorTextField.text?.trimmed.isEmpty)!{
            isAllFilled = false
        }
        
        if (createReviewUniversityView.expressShortSummaryTextField.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        if (createReviewUniversityView.advantageTextView.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        
        if (createReviewUniversityView.disadvantageTextView.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        
        if (createReviewUniversityView.briefForTheMenteeTextView.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        
        if isAllFilled{
            
            //if both are filled, execute below
            //let realm = try! Realm()
            if CheckNetworkConnection.isConnectedToNetwork(){
                let request = CreateBoardRequest()
                request.userId = Int64(self.userDefault.integer(forKey: "user_id"))
                request.boardType = self.title
                request.boardUniversity = createReviewUniversityView.universityTextField.text?.trimmed
                request.boardMajor = createReviewUniversityView.majorTextField.text?.trimmed
                request.boardTitle = createReviewUniversityView.expressShortSummaryTextField.text?.trimmed
                request.boardContent = "Advantage:\n\(createReviewUniversityView.advantageTextView.text!.trimmed)\nDisadvantage:\n\(createReviewUniversityView.disadvantageTextView.text!.trimmed)\nBrief:\n\(createReviewUniversityView.briefForTheMenteeTextView.text!.trimmed)"
                
                
                GRPC.sharedInstance.authorizedUser.createBoard(with:request, handler:{
                    (res,err) in
                    
                    if res != nil{
                        //self.protoCall?.finishWithError(nil)
                        if let success = res?.success{
                            
                            if (success == "true"){
                                //fix here
                                self.view.window?.makeToast("Successfully Created The Board", duration: 1.0, position: CSToastPositionBottom)
                                self.navigationController?.popViewController(animated: true)
                                //call notification to update UI of QandATableView as it goes back
                                let option:[String:String] = ["option":self.title!]
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "qandaTable"), object: nil, userInfo: option)
                                })
                                
                                
                            }
                        }else{
                            self.view.window?.makeToast("Fail to create the board. Try Again", duration: 2.0, position: CSToastPositionBottom)
                        }
                        
                        
                    }else{
                        self.log.debug("Create Board Error: \(err)")
                        //self.protoCall?.finishWithError(err)
                        if(err != nil){
                            self.view.window?.makeToast("Create Board Error, Try Again", duration: 1.0, position: CSToastPositionBottom)
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
