//
//  CreateExpressViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 3. 15..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import DropDown
import XCGLogger
import RxCocoa
import RxSwift
import Material

class CreateExpressViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate{
    
    var selected:String!
    
    //since universities.txt is too long to load
    var fakeUniversities = [String]()
    var shownUniversities = [String]()
    var allUniversities = [String]()
    
    var shownMajors = [String]()
    var allMajors = [String]()
    //view
    var scrollView: UIScrollView!
    var createExpressView: CreateExpressView!
    let userDefault = UserDefaults.standard
    var tap : UITapGestureRecognizer!
    let log = XCGLogger.default
    
    //dropdown
    let dropdownUniv = DropDown()
    let dropdownMajor = DropDown()
    var protoCall : GRPCProtoCall?

    
    override func loadView() {
        super.loadView()
        createExpressView = CreateExpressView()
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
        scrollView.contentSize = CGSize(width:createExpressView.bounds.width, height:createExpressView.bounds.height + 100)
        scrollView.addSubview(createExpressView)
        self.view.addSubview(scrollView)
        createExpressView.expressRegisterButton.rx.tap.subscribe({ [weak self] x in
            self?.expressBtnTapped()
        }).disposed(by: App.disposeBag)
        
        //delegate
        createExpressView.universityTextField.delegate = self
        createExpressView.majorTextField.delegate = self
        createExpressView.expressTitleTextField.delegate = self
        createExpressView.expressTextView.delegate = self
        
        
        //set navigationBar.title
        self.title = userDefault.string(forKey: "tableName")
        
        //dropdown setting
        //dropdownUniv
        dropdownUniv.anchorView = createExpressView.majorTextField
        dropdownUniv.direction = .bottom
        dropdownMajor.frame.size.height = self.view.frame.size.width
        //dropdownUniv.bottomOffset = CGPoint(x: 0, y:(dropdownUniv.anchorView?.plainView.bounds.height)!)
        dropdownUniv.backgroundColor = UIColor.white
        dropdownUniv.dataSource = fakeUniversities
        createExpressView.universityTextField
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
            self.createExpressView.universityTextField.text = item
            self.dropdownUniv.hide()
            self.view.endEditing(true)
        }
        
        //dropdownMajor
        dropdownMajor.anchorView = createExpressView.expressTitleTextField
        dropdownMajor.frame.size.height = self.view.frame.size.width
        dropdownMajor.direction = .bottom
        //dropdownMajor.bottomOffset = CGPoint(x: 0, y:(dropdownMajor.anchorView?.plainView.bounds.height)!)
        dropdownMajor.backgroundColor = UIColor.white
        dropdownMajor.dataSource = allMajors
        createExpressView.majorTextField
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
            self.createExpressView.majorTextField.text = item
            self.dropdownMajor.hide()
            self.view.endEditing(true)
        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        createExpressView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    func expressBtnTapped(){
        self.view.endEditing(true)
        var isAllFilled : Bool = true
        
        if(createExpressView.universityTextField.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
        }
        
        if(createExpressView.majorTextField.text?.trimmed.isEmpty)!{
            isAllFilled = false
        }
        
        if (createExpressView.expressTitleTextField.text?.trimmed.isEmpty)!{
            
            isAllFilled = false
            
        }
        if (createExpressView.expressTextView.text?.trimmed.isEmpty)!{

            isAllFilled = false
            
        }
        
        if isAllFilled{
            if((createExpressView.expressTitleTextField.text?.count)! > 30){
                self.view.window?.makeToast("Please, write the title within 30 characters.", duration: 2.5, position: CSToastPositionBottom)
                return
            }
            //if both are filled, execute below
            //let realm = try! Realm()
            if CheckNetworkConnection.isConnectedToNetwork(){
                let request = CreateBoardRequest()
                request.userId = Int64(self.userDefault.integer(forKey: "user_id"))
                request.boardType = self.title
                request.boardUniversity = createExpressView.universityTextField.text?.trimmed
                request.boardMajor = createExpressView.majorTextField.text?.trimmed
                request.boardTitle = createExpressView.expressTitleTextField.text?.trimmed
                request.boardContent = createExpressView.expressTextView.text.trimmed
                
                
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
                            self.view.window?.makeToast("Create Board Error", duration: 1.0, position: CSToastPositionBottom)
                        }
                    }
                })
                //protoCall?.timeout = App.timeout
                //protoCall?.start()
            }else{
                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
            }
        }else{
            self.view.window?.makeToast("Please, fill out every field", duration: 1.0, position: CSToastPositionTop)
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
        if let textField = textField as? TextField{
            if textField.tag == 1{
                
                _ = createExpressView.majorTextField.becomeFirstResponder()
                return false
            }else if textField.tag == 2{
                _ = createExpressView.expressTitleTextField.becomeFirstResponder()
                return false
            }else{
                textField.resignFirstResponder()
                return false
            }
        }
        return false
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
                if (!aRect.contains(createExpressView.universityTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(createExpressView.universityTextField.frame, animated: true)
                }
            }else if selected == "2"{
                if (!aRect.contains(createExpressView.majorTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(createExpressView.majorTextField.frame, animated: true)
                }
            }else if selected == "3"{
                if (!aRect.contains(createExpressView.expressTitleTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(createExpressView.expressTitleTextField.frame, animated: true)
                }
            }else{
                if (!aRect.contains(createExpressView.expressTextView.frame.origin)) {
                    self.scrollView.scrollRectToVisible(createExpressView.expressTextView.frame, animated: true)
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
