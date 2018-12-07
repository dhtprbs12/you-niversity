//
//  MentorRevisionViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 6. 3..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import DLRadioButton
import Material
import RealmSwift
import DropDown
import Photos
import Kingfisher
import RxSwift
import RxCocoa
import PKHUD

class MentorRevisionViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //since universities.txt is too long to load
    var fakeUniversities = [String]()
    var shownUniversities = [String]()
    var allUniversities = [String]()
    
    var shownMajors = [String]()
    var allMajors = [String]()
    
    //dropdown
    let dropdownUniv = DropDown()
    let dropdownMajor = DropDown()
    
    var scrollView: UIScrollView!
    var mentorRevisionView: MentorRevisionView!
    var tap : UITapGestureRecognizer!
    var selected:String!
    var log = XCGLogger.default
    let userDefault = UserDefaults.standard
    //image
    var imagePicker = UIImagePickerController()
    var backgroundimageURL = String()
    var profileimageURL = String()
    var backgroundImgData: Data?
    var profileImgData: Data?
    let processor = RoundCornerImageProcessor(cornerRadius: 20)
    var protoCall:GRPCProtoCall?
    //var delete_protoCall : GRPCProtoCall?
    
    override func loadView() {
        super.loadView()
        mentorRevisionView = MentorRevisionView()
        
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
        //need to comment below statement when using scrollView
        self.edgesForExtendedLayout = []
        self.title = "Revision Mentor"
        //dropdown setting
        //dropdownUniv
        dropdownUniv.anchorView = mentorRevisionView.nicknameTextField
        dropdownUniv.direction = .top
        //dropdownUniv.bottomOffset = CGPoint(x: 0, y:(dropdownUniv.anchorView?.plainView.bounds.height)!)
        dropdownUniv.backgroundColor = UIColor.white
        dropdownUniv.dataSource = fakeUniversities
        mentorRevisionView.univTextField
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
            self.mentorRevisionView.univTextField.text = item
            self.dropdownUniv.hide()
            self.view.endEditing(true)
        }
        
        //dropdownMajor
        dropdownMajor.anchorView = mentorRevisionView.univTextField
        dropdownMajor.frame.size.height = self.view.frame.size.width
        dropdownMajor.direction = .top
        //dropdownMajor.bottomOffset = CGPoint(x: 0, y:(dropdownMajor.anchorView?.plainView.bounds.height)!)
        dropdownMajor.backgroundColor = UIColor.white
        dropdownMajor.dataSource = allMajors
        mentorRevisionView.majorTextField
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
            self.mentorRevisionView.majorTextField.text = item
            self.dropdownMajor.hide()
            self.view.endEditing(true)
        }
        //place UniversityDetailView under navigation bar
        //self.edgesForExtendedLayout = []
        tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.view.addGestureRecognizer(tap)
        self.view.isUserInteractionEnabled = true
        scrollView = UIScrollView()
        scrollView.delegate = self
        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:mentorRevisionView.bounds.width, height:mentorRevisionView.bounds.height+mentorRevisionView.bounds.height)
        scrollView.addSubview(mentorRevisionView)
        self.view.addSubview(scrollView)
        //imagePicker 도 역시 imagePicker를 쓰는 뷰컨트롤러에 delegate를 선언해줘야 imagePicker의 메소드들을 self(뷰컨트롤러)에서 사용 가능
        imagePicker.delegate = self
        
        //if user taps imageView, invoked
        let backgroundImagetapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(sender:)))
        mentorRevisionView.backgroundImage.addGestureRecognizer(backgroundImagetapGestureRecognizer)
        //mentorRevisionView.backgroundImageLabel.addGestureRecognizer(backgroundImagetapGestureRecognizer)
        
        let profileImagetapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(sender:)))
        mentorRevisionView.profileImage.addGestureRecognizer(profileImagetapGestureRecognizer)
        //mentorRevisionView.profileImageLabel.addGestureRecognizer(profileImagetapGestureRecognizer)
        
        //register other buttons into elementaryButton
        mentorRevisionView.elementaryButton.otherButtons.append(mentorRevisionView.middleSchoolButton)
        mentorRevisionView.elementaryButton.otherButtons.append(mentorRevisionView.highSchoolButton)
        mentorRevisionView.elementaryButton.otherButtons.append(mentorRevisionView.collegeButton)
        //add target for the "who can be menotored?" DLRadioButtons
        mentorRevisionView.elementaryButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        mentorRevisionView.middleSchoolButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        mentorRevisionView.highSchoolButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        mentorRevisionView.collegeButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        
        //register other buttons into outsideActivityButton
        mentorRevisionView.outsideActivityButton.otherButtons.append(mentorRevisionView.collegeLifeButton)
        mentorRevisionView.outsideActivityButton.otherButtons.append(mentorRevisionView.friendAndRelationshipButton)
        mentorRevisionView.outsideActivityButton.otherButtons.append(mentorRevisionView.tripAndHobbyButton)
        mentorRevisionView.outsideActivityButton.otherButtons.append(mentorRevisionView.employmentButton)
        mentorRevisionView.outsideActivityButton.otherButtons.append(mentorRevisionView.tutoringButton)
        mentorRevisionView.outsideActivityButton.otherButtons.append(mentorRevisionView.fashionAndBeautyButton)
        mentorRevisionView.outsideActivityButton.otherButtons.append(mentorRevisionView.satAndApplicationButton)
        //add target for the "Mentoring Field" DLRadioButtons
        mentorRevisionView.outsideActivityButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        mentorRevisionView.collegeLifeButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        mentorRevisionView.friendAndRelationshipButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        mentorRevisionView.tripAndHobbyButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        mentorRevisionView.employmentButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        mentorRevisionView.tutoringButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        mentorRevisionView.fashionAndBeautyButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        mentorRevisionView.satAndApplicationButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        //textfield delegate
        mentorRevisionView.nicknameTextField.delegate = self
        mentorRevisionView.univTextField.delegate = self
        mentorRevisionView.majorTextField.delegate = self
        //textview delegate
        mentorRevisionView.mentorIntroTextView.delegate = self
        mentorRevisionView.mentoringInfoTextView.delegate = self
        //delete button target
        mentorRevisionView.deleteButton.rx.tap.subscribe({ [weak self] x in
            self?.doDelete()
        }).disposed(by: App.disposeBag)
        //save button target
        mentorRevisionView.saveButton.rx.tap.subscribe({ [weak self] x in
            self?.doSave()
        }).disposed(by: App.disposeBag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        mentorRevisionView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadMentorInfo()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.updateCharacterCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        //protoCall?.finishWithError(nil)
        //delete_protoCall?.finishWithError(nil)
    }
    
    
    //load mentor info before view shown
    func loadMentorInfo(){
        let realm = try! Realm()
        
        if let mentor = realm.objects(MentorInfo.self).first{
            //load image from the server
            self.mentorRevisionView.backgroundImage.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(mentor.mentor_background_url)"),options:[.processor(processor)],completionHandler:{
                (image, error, cacheType, imageUrl) in
                if(image == nil){
                    self.mentorRevisionView.backgroundImage.backgroundColor = UIColor.lightGray
                }else{
                    self.mentorRevisionView.backgroundImage.image = image
                }
                //if fails image == nil
                
            })
            self.mentorRevisionView.profileImage.kf.setImage(with: URL(string:"http://\(GRPC.sharedInstance.image_endpoint)/download/images/\(mentor.mentor_profile_url)"),options:[.processor(processor)],completionHandler:{
                (image, error, cacheType, imageUrl) in
                //if fails image == nil
                if(image == nil){
                    self.mentorRevisionView.profileImage.image = UIImage(named: "defaultImage")
                }else{
                    self.mentorRevisionView.profileImage.image = image
                }
                
            })
            
            //load others' info
            self.mentorRevisionView.nicknameTextField.text = mentor.mentor_nickname
            self.mentorRevisionView.univTextField.text = mentor.mentor_university
            self.mentorRevisionView.majorTextField.text = mentor.mentor_major
            //buttons
            self.findSelectedButtons(string: mentor.mentor_mentoring_area)
            self.findSelectedButtons(string: mentor.mentor_mentoring_field)
            //textViews
            self.mentorRevisionView.mentorIntroTextView.text = mentor.mentor_introduction
            self.mentorRevisionView.mentoringInfoTextView.text = mentor.mentor_information
        }else{
            //mentor info not exist in realm database
        }
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
                if (!aRect.contains(mentorRevisionView.nicknameTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(mentorRevisionView.nicknameTextField.frame, animated: true)
                }
            }else if selected == "2"{
                if (!aRect.contains(mentorRevisionView.univTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(mentorRevisionView.univTextField.frame, animated: true)
                }
            }else if selected == "3"{
                if (!aRect.contains(mentorRevisionView.majorTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(mentorRevisionView.majorTextField.frame, animated: true)
                }
            }else if selected == "4"{//mentoringIntroTextView
                if (!aRect.contains(mentorRevisionView.mentorIntroTextView.frame.origin)) {
                    self.scrollView.scrollRectToVisible(mentorRevisionView.mentorIntroTextView.frame, animated: true)
                }
            }else if selected == "5"{//mentoringInfoTextView
                if (!aRect.contains(mentorRevisionView.mentoringInfoTextView.frame.origin)) {
                    self.scrollView.scrollRectToVisible(mentorRevisionView.mentoringInfoTextView.frame, animated: true)
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
    
    @objc private func MentoringAreaSelectedButton(radioButton : DLRadioButton) -> DLRadioButton{
        
        return radioButton
    }
    
    @objc private func MentoringFieldSelectedButton(radioButton : DLRadioButton) -> DLRadioButton {
        
        return radioButton
    }
    
    //textfield delegate
    // return NO to disallow editing.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let textField = textField as? ErrorTextField{
            
            if textField.tag == 1{
                selected = "1"
                return true
            }else if textField.tag == 2{
                selected = "2"
                if(textField.text?.isEmpty)!{
                    dropdownUniv.dataSource = fakeUniversities
                }
                dropdownUniv.show()
                return true
                
            }else{
                selected = "3"
                if(textField.text?.isEmpty)!{
                    dropdownMajor.dataSource = allMajors
                }
                dropdownMajor.show()
                return true
            }
        }
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let textField = textField as? ErrorTextField{
            if textField.returnKeyType == .next{
                if textField.tag == 1{
                    _ = mentorRevisionView.univTextField.becomeFirstResponder()
                }else if textField.tag == 2{
                    _ = mentorRevisionView.majorTextField.becomeFirstResponder()
                }
            }else{//.done which is majorTextField
                textField.resignFirstResponder()
            }
        }
        return false
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
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        var data : Data?
        var resizedImg : UIImage?
        let URL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let image = info[UIImagePickerControllerOriginalImage]as! UIImage
        //resize를 해주지 않으면 용량이 큰 사진같은경우 서버로 보내지지 않음
        if(image.size.width >= 500.0 || image.size.height >= 500.0){
            resizedImg = image.resizeImage(image: image, newWidth: 700.0)
            data = UIImageJPEGRepresentation(resizedImg!,1)
        }else{
            data = UIImageJPEGRepresentation(image,1)
        }
        
        //check if image is for the profile or background
        if picker.view.tag == 1{//background
            //compress background image
            self.compressImage(image: UIImage(data: data!)!){ data in
                self.backgroundImgData = data
            }
            mentorRevisionView.backgroundImage.image = UIImage(data:data!)
            backgroundimageURL = "\(userDefault.integer(forKey: "user_id"))-\((URL.absoluteURL?.query)!).jpeg"
            //store image into cache
            ImageCache.default.store(UIImage(data:data!)!, forKey: backgroundimageURL)
        }else{//profile
            //compress profile image
            self.compressImage(image: UIImage(data: data!)!){ data in
                self.profileImgData = data
            }
            mentorRevisionView.profileImage.image = UIImage(data:data!)
            profileimageURL = "\(userDefault.integer(forKey: "user_id"))-\((URL.absoluteURL?.query)!).jpeg"
            //store image into cache
            ImageCache.default.store(UIImage(data:data!)!, forKey: profileimageURL)
        }
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: { () -> Void in
            
        })
    }
    
    //when user clicks image
    @objc func imageTapped(sender: UITapGestureRecognizer){
        
        //let picker = UIImagePickerController()
        //picker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        //must set this property to dismiss only pickerVC
        imagePicker.modalPresentationStyle = .overCurrentContext
        
        if let tag = sender.view?.tag{
            if tag == 1{
                imagePicker.view.tag = 1
            }else{
                imagePicker.view.tag = 2
            }
        }
        
        self.present(imagePicker, animated: true, completion:nil)
    }
    //about to delete mentor
    func doDelete(){
        let alertController = UIAlertController(title: "Caution", message: "You sure to delete?", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Delete", style: .default) { (_) in //confirm button clicked
            
            if CheckNetworkConnection.isConnectedToNetwork(){
                let realm = try! Realm()
                let mentor = realm.objects(MentorInfo.self)
                let request = DeleteMentorRequest()
                request.mentorId = Int64(self.userDefault.integer(forKey: "mentor_id"))
                
                GRPC.sharedInstance.authorizedUser.deleteMentor(with: request, handler: {
                    (res,err) in
                    
                    if res != nil{
                        //self.unregister_protoCall?.finishWithError(nil)
                        // Delete all objects from the realm
                        try! realm.write {
                            realm.delete(mentor)
                        }
                        
                        self.navigationController?.popViewController(animated: true)
                        
                    }else{
                        self.log.debug("Delete Mentor Error:\(err)")
                        //self.unregister_protoCall?.finishWithError(err)
                        if(err != nil){
                            self.view.window?.makeToast("Delete Mentor Error", duration: 1.0, position: CSToastPositionBottom)
                        }
                    }
                    //need to cancel request no matter succeeded or failed
                    //GRPC.sharedInstance.rpcCall.cancel()
                })
                //self.unregister_protoCall?.timeout = App.timeout
                //self.unregister_protoCall?.start()
            }else{
                
                self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func doSave(){
        self.view.endEditing(true)
        let imageRealm = try! Realm()
        //backgroundIamgeURL
        if backgroundimageURL.isEmpty {
            if let mentor = imageRealm.objects(MentorInfo.self).first{
                backgroundimageURL = mentor.mentor_background_url
            }
            
        }
        //profileImageURL
        if profileimageURL.isEmpty {
            if let mentor = imageRealm.objects(MentorInfo.self).first{
                profileimageURL = mentor.mentor_profile_url
            }
        }
        //university TextField
        if(mentorRevisionView.univTextField.text?.isEmpty)!{
            self.view.window?.makeToast("Select your university!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //major TextField
        if(mentorRevisionView.majorTextField.text?.isEmpty)!{
            self.view.window?.makeToast("Select your major!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //mentoring area buttons
        if(MentoringAreaSelectedButton(radioButton: mentorRevisionView.elementaryButton).selectedButtons().count == 0){
            self.view.window?.makeToast("Select your mentoring area!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //mentoring field buttons
        if(MentoringFieldSelectedButton(radioButton: mentorRevisionView.outsideActivityButton).selectedButtons().count == 0){
            self.view.window?.makeToast("Select your mentoring field!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //mentor Introduction TextView
        if(mentorRevisionView.mentorIntroTextView.text?.isEmpty)!{
            self.view.window?.makeToast("Fill out mentor introduction!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //Mentoring Information TextView
        if(mentorRevisionView.mentoringInfoTextView.text?.isEmpty)!{
            self.view.window?.makeToast("Fill out mentoring information!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        
        //if user fills everything, create mentor
        
        
        let request = UpdateMentorInfoRequest()
        request.mentorId = Int64(userDefault.integer(forKey: "mentor_id"))
        request.mentorNickname = mentorRevisionView.nicknameTextField.text?.trimmed
        request.mentorUniversity = mentorRevisionView.univTextField.text?.trimmed
        request.mentorMajor = mentorRevisionView.majorTextField.text?.trimmed
        request.mentorBackgroundurl = backgroundimageURL
        request.mentorProfileurl = profileimageURL
        request.mentorMentoringArea = convertArrayToString(buttons: MentoringAreaSelectedButton(radioButton: mentorRevisionView.elementaryButton))
        request.mentorMentoringField = convertArrayToString(buttons: MentoringFieldSelectedButton(radioButton: mentorRevisionView.outsideActivityButton))
        request.mentorIntroduction = mentorRevisionView.mentorIntroTextView.text.trimmed
        request.mentorInformation = mentorRevisionView.mentoringInfoTextView.text.trimmed
        request.backgroundImage = backgroundImgData
        request.profileImage = profileImgData
        request.userId = Int64(userDefault.integer(forKey: "user_id"))
        
        //server call
        if CheckNetworkConnection.isConnectedToNetwork(){
            HUD.show(.progress)
            GRPC.sharedInstance.authorizedUser.updateMentorInfo(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    
                    //self.protoCall?.finishWithError(nil)
                    if self.userDefault.string(forKey: "mentor_option") != "Revision"{
                        //it is pushed from MentorVC
                        self.navigationController?.popViewController(animated: true)
                        let option:[String:String] = ["option":self.userDefault.string(forKey: "mentor_option")!]//this is either Best or Latest
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            HUD.hide()
                            HUD.flash(.success, delay: 1.5)
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mentorTable"), object: nil, userInfo: option)
                        })
                    }else{
                        //it is pushed from RevisionProfileVC
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                    //insert mentor info into Realm
                    let realm = try! Realm()
                    try! realm.write {
                        let mentor = MentorInfo()
                        //can't update mentor without mentor_id
                        //without it, another mentor row created with mentor_id = 0
                        mentor.mentor_id = Int(request.mentorId)
                        mentor.user_id = Int(self.userDefault.integer(forKey: "user_id"))
                        mentor.mentor_nickname = request.mentorNickname
                        mentor.mentor_university = request.mentorUniversity
                        mentor.mentor_major = request.mentorMajor
                        mentor.mentor_background_url = request.mentorBackgroundurl
                        mentor.mentor_profile_url = request.mentorProfileurl
                        mentor.mentor_mentoring_area = request.mentorMentoringArea
                        mentor.mentor_mentoring_field = request.mentorMentoringField
                        mentor.mentor_introduction = request.mentorIntroduction
                        mentor.mentor_information = request.mentorInformation
                        realm.create(MentorInfo.self, value: mentor, update: true)
                    }
                    
                }else{
                    HUD.hide()
                    HUD.flash(.error, delay: 1.0)
                    self.log.debug("Mentor Revision Error:\(err)")
                    //self.protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Mentor Revision Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //need to cancel request no matter succeeded or failed
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
            
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
        
        
        
    }
}

extension MentorRevisionViewController{
    
    //helper function for determining selected buttons
    func findSelectedButtons(string:String){
        
        let arr : [String] = string.components(separatedBy: ",")
        for val in arr{
            if val == "Primary"{
                mentorRevisionView.elementaryButton.isSelected = true
            }else if val == "Middle"{
                mentorRevisionView.middleSchoolButton.isSelected = true
            }else if val == "High"{
                mentorRevisionView.highSchoolButton.isSelected = true
            }else if val == "College"{
                mentorRevisionView.collegeButton.isSelected = true
            }else if val == "Outside Activity"{
                mentorRevisionView.outsideActivityButton.isSelected = true
            }else if val == "College Life"{
                mentorRevisionView.collegeLifeButton.isSelected = true
            }else if val == "Friend/Relationship"{
                mentorRevisionView.friendAndRelationshipButton.isSelected = true
            }else if val == "Trip/Hobby"{
                mentorRevisionView.tripAndHobbyButton.isSelected = true
            }else if val == "Employment"{
                mentorRevisionView.employmentButton.isSelected = true
            }else if val == "Tutoring"{
                mentorRevisionView.tutoringButton.isSelected = true
            }else if val == "Fahion/Beauty"{
                mentorRevisionView.fashionAndBeautyButton.isSelected = true
            }else if val == "SAT/Application"{
                mentorRevisionView.satAndApplicationButton.isSelected = true
            }
        }
    }
    
    //textview delegate
    func updateCharacterCount() {
        let mentorIntroTextViewCount = mentorRevisionView.mentorIntroTextView.text.count
        let mentoringInfoTextViewCount = mentorRevisionView.mentoringInfoTextView.text.count
        
        mentorRevisionView.maximumIntroSelf.text = "\((0) + mentorIntroTextViewCount)/250"
        
        mentorRevisionView.maximumMentoringInfo.text = "\((0) + mentoringInfoTextViewCount)/250"
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == mentorRevisionView.mentorIntroTextView){
            return textView.text.count +  (text.count - range.length) <= 250
        }else if(textView == mentorRevisionView.mentoringInfoTextView){
            return textView.text.count +  (text.count - range.length) <= 250
        }
        //if this is false, can't write on career textview
        return true
    }
    //helper function for combining strings
    func convertArrayToString(buttons: DLRadioButton) -> String {
        var stringArray = [String]()
        var combinedStr = String()
        for button in buttons.selectedButtons() {
            
            stringArray.append(button.titleLabel!.text!)
        }
        combinedStr = stringArray.joined(separator: ",")
        log.debug("combined string: \(combinedStr)")
        return combinedStr
    }
}

extension MentorRevisionViewController{
    func compressImage(image: UIImage, completion: (Data?) -> Void) {
        self.log.debug("Compressing Image")
        var data : Data?
        data = image.highQualityJPEGNSData
        HUD.flash(.label("Compressing Images..May some times depending on the size…"), delay: 2.0) { _ in
        }
        completion(data)
        self.log.debug("Compressing Done")
        /*
         Hide
         let label = UILabel()
         label.text = "Compressing Image..May some times depending on the size"
         HUD.flash(.progress, onView: label)
         */
        HUD.hide()
    }
}
