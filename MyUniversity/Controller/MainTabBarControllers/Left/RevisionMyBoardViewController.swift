//
//  RevisionMyBoardViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 6. 11..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import XCGLogger
import DropDown
import RxCocoa
import RxSwift
import Material

class RevisionMyBoardViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate{
    
    var selected:String!
    
    //since universities.txt is too long to load
    var fakeUniversities = [String]()
    var shownUniversities = [String]()
    var allUniversities = [String]()
    
    var shownMajors = [String]()
    var allMajors = [String]()
    
    var scrollView: UIScrollView!
    var revisionMyBoardView: RevisionMyBoardView!
    let userDefault = UserDefaults.standard
    var tap : UITapGestureRecognizer!
    var object : BoardObject?
    var log = XCGLogger.default
    var protoCall : GRPCProtoCall?
    
    //dropdown
    let dropdownUniv = DropDown()
    let dropdownMajor = DropDown()
    
    override func loadView() {
        super.loadView()
        
        revisionMyBoardView = RevisionMyBoardView()
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
        self.navigationController?.tabBarController?.tabBar.backgroundColor = UIColor.white
        loadBoard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        NotificationCenter.default.removeObserver(self)
        //protoCall?.finishWithError(nil)
    }
    
    func loadBoard(){
        let decoded  = userDefault.object(forKey: "board") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? BoardObject
        revisionMyBoardView.universityTextField.text = object?.board_university
        revisionMyBoardView.majorTextField.text = object?.board_major
        revisionMyBoardView.titleTextField.text = object?.board_title
        revisionMyBoardView.textView.text = object?.board_content
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userDefault.set(false, forKey: "Is_Post_Revised")
        self.edgesForExtendedLayout = []
        //tap setting
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:revisionMyBoardView.bounds.width, height:revisionMyBoardView.bounds.height)
        scrollView.addSubview(revisionMyBoardView)
        revisionMyBoardView.revisionButton.rx.tap.subscribe({ [weak self] x in
            self?.revisionBtnTapped()
        }).disposed(by: App.disposeBag)
        
        //delegate
        revisionMyBoardView.universityTextField.delegate = self
        revisionMyBoardView.majorTextField.delegate = self
        revisionMyBoardView.titleTextField.delegate = self
        revisionMyBoardView.textView.delegate = self
        
        self.view.addSubview(scrollView)
        //set navigationBar.title
        self.title = "Edit My Post"
        
        //dropdown setting
        //dropdownUniv
        dropdownUniv.anchorView = revisionMyBoardView.majorTextField
        dropdownUniv.direction = .bottom
        dropdownMajor.frame.size.height = self.view.frame.size.width
        //dropdownUniv.bottomOffset = CGPoint(x: 0, y:(dropdownUniv.anchorView?.plainView.bounds.height)!)
        dropdownUniv.backgroundColor = UIColor.white
        dropdownUniv.dataSource = fakeUniversities
        revisionMyBoardView.universityTextField
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
            self.revisionMyBoardView.universityTextField.text = item
            self.dropdownUniv.hide()
            self.view.endEditing(true)
        }
        
        //dropdownMajor
        dropdownMajor.anchorView = revisionMyBoardView.titleTextField
        dropdownMajor.frame.size.height = self.view.frame.size.width
        dropdownMajor.direction = .bottom
        //dropdownMajor.bottomOffset = CGPoint(x: 0, y:(dropdownMajor.anchorView?.plainView.bounds.height)!)
        dropdownMajor.backgroundColor = UIColor.white
        dropdownMajor.dataSource = allMajors
        revisionMyBoardView.majorTextField
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
            self.revisionMyBoardView.majorTextField.text = item
            self.dropdownMajor.hide()
            self.view.endEditing(true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        revisionMyBoardView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
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
            
            if selected == "4"{
                if (!aRect.contains(revisionMyBoardView.textView.frame.origin)) {
                    self.scrollView.scrollRectToVisible(revisionMyBoardView.textView.frame, animated: true)
                }
            }else if selected == "1"{
                if (!aRect.contains(revisionMyBoardView.universityTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(revisionMyBoardView.universityTextField.frame, animated: true)
                }
            }else if selected == "2"{
                if (!aRect.contains(revisionMyBoardView.majorTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(revisionMyBoardView.majorTextField.frame, animated: true)
                }
            }else{
                if (!aRect.contains(revisionMyBoardView.titleTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(revisionMyBoardView.titleTextField.frame, animated: true)
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
    
    func revisionBtnTapped(){
        
        if(revisionMyBoardView.universityTextField.text?.trimmed.isEmpty)!{
            self.view.window?.makeToast("Please, select the university", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        if(revisionMyBoardView.majorTextField.text?.trimmed.isEmpty)!{
            self.view.window?.makeToast("Please, select the major", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        if (revisionMyBoardView.titleTextField.text?.trimmed.isEmpty)!{
            self.view.window?.makeToast("Please, fill out the title", duration: 1.0, position: CSToastPositionTop)
            return
        }
        if (revisionMyBoardView.textView.text?.trimmed.isEmpty)!{
            self.view.window?.makeToast("Please, fill out the content", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //if both are filled, execute below
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = ReviseMyBoardRequest()
            request.boardId = Int64((object?.board_id)!)
            request.boardUniversity = revisionMyBoardView.universityTextField.text?.trimmed
            request.boardMajor = revisionMyBoardView.majorTextField.text?.trimmed
            request.boardTitle = revisionMyBoardView.titleTextField.text?.trimmed
            request.boardContent = revisionMyBoardView.textView.text.trimmed
            
            
            GRPC.sharedInstance.authorizedUser.reviseMyBoard(with:request, handler:{
                (res,err) in
                
                if res != nil{
                    //self.protoCall?.finishWithError(nil)
                    self.userDefault.set(true, forKey: "Is_Post_Revised")
                    self.navigationController?.popViewController(animated: true)
                    self.view.window?.makeToast("Successfully Revised The Board", duration: 1.0, position: CSToastPositionBottom)
                }else{
                    self.userDefault.set(false, forKey: "Is_Post_Revised")
                    self.log.debug("Revise Board Error:\(err)")
                    //self.protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Revise Board Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //need to cancel request no matter succeeded or failed
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
        }
    }
    
    //textfield delegate
    // return NO to disallow editing.
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
    
    //textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let textView = textView as? TextView{
            if textView.tag == 4{
                selected = "4"
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next{
            revisionMyBoardView.textView.becomeFirstResponder()
        }
        return false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
}
