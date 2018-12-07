//
//  WannaBeMentorViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 2. 22..
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
import RxCocoa
import RxSwift
import PKHUD
import Kingfisher

class WannaBeMentorViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate,UIScrollViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
    var wannaBeMentorView: WannaBeMentorView!
    var tap : UITapGestureRecognizer!
    var selected:String!
    var log = XCGLogger.default
    var userDefault = UserDefaults.standard
    //image
    var imagePicker = UIImagePickerController()
    var backgroundimageURL = String()
    var profileimageURL = String()
    var backgroundImgData: Data?
    var profileImgData: Data?
    var protoCall:GRPCProtoCall?
    
    
    override func loadView() {
        super.loadView()
        wannaBeMentorView = WannaBeMentorView()
        
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
        self.title = "Register Mentor"
        //dropdown setting
        //dropdownUniv
        dropdownUniv.anchorView = wannaBeMentorView.nicknameTextField
        dropdownUniv.direction = .top
        dropdownUniv.frame.size.height = self.view.frame.size.width
        //dropdownUniv.bottomOffset = CGPoint(x: 0, y:(dropdownUniv.anchorView?.plainView.bounds.height)!)
        dropdownUniv.backgroundColor = UIColor.white
        dropdownUniv.dataSource = fakeUniversities
        wannaBeMentorView.univTextField
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
            self.wannaBeMentorView.univTextField.text = item
            self.dropdownUniv.hide()
            self.view.endEditing(true)
        }
        
        //dropdownMajor
        dropdownMajor.anchorView = wannaBeMentorView.univTextField
        dropdownMajor.frame.size.height = self.view.frame.size.width
        dropdownMajor.direction = .top
        //dropdownMajor.topOffset = CGPoint(x: 0, y:(dropdownMajor.anchorView?.plainView.bounds.height)!)
        //dropdownMajor.bottomOffset = CGPoint(x: 0, y:(dropdownMajor.anchorView?.plainView.bounds.height)!)
        dropdownMajor.backgroundColor = UIColor.white
        dropdownMajor.dataSource = allMajors
        wannaBeMentorView.majorTextField
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
            self.wannaBeMentorView.majorTextField.text = item
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
        scrollView.contentSize = CGSize(width:wannaBeMentorView.bounds.width, height:wannaBeMentorView.bounds.height+wannaBeMentorView.bounds.height)
        scrollView.addSubview(wannaBeMentorView)
        self.view.addSubview(scrollView)
        //imagePicker 도 역시 imagePicker를 쓰는 뷰컨트롤러에 delegate를 선언해줘야 imagePicker의 메소드들을 self(뷰컨트롤러)에서 사용 가능
        imagePicker.delegate = self
        
        //유저가 프로필 imageView를 탭하면 invoke되어짐
        let backgroundImagetapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(sender:)))
        wannaBeMentorView.backgroundImage.addGestureRecognizer(backgroundImagetapGestureRecognizer)
        //wannaBeMentorView.backgroundImageLabel.addGestureRecognizer(backgroundImagetapGestureRecognizer)
        
       let profileImagetapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.imageTapped(sender:)))
        wannaBeMentorView.profileImage.addGestureRecognizer(profileImagetapGestureRecognizer)
        //wannaBeMentorView.profileImageLabel.addGestureRecognizer(profileImagetapGestureRecognizer)
        //register other buttons into elementaryButton
        wannaBeMentorView.elementaryButton.otherButtons.append(wannaBeMentorView.middleSchoolButton)
        wannaBeMentorView.elementaryButton.otherButtons.append(wannaBeMentorView.highSchoolButton)
        wannaBeMentorView.elementaryButton.otherButtons.append(wannaBeMentorView.collegeButton)
        //add target for the "who can be menotored?" DLRadioButtons
        wannaBeMentorView.elementaryButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        wannaBeMentorView.middleSchoolButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        wannaBeMentorView.highSchoolButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        wannaBeMentorView.collegeButton.addTarget(self, action: #selector(MentoringAreaSelectedButton), for: .touchUpInside)
        
        //register other buttons into outsideActivityButton
        wannaBeMentorView.outsideActivityButton.otherButtons.append(wannaBeMentorView.collegeLifeButton)
        wannaBeMentorView.outsideActivityButton.otherButtons.append(wannaBeMentorView.friendAndRelationshipButton)
        wannaBeMentorView.outsideActivityButton.otherButtons.append(wannaBeMentorView.tripAndHobbyButton)
        wannaBeMentorView.outsideActivityButton.otherButtons.append(wannaBeMentorView.employmentButton)
        wannaBeMentorView.outsideActivityButton.otherButtons.append(wannaBeMentorView.tutoringButton)
        wannaBeMentorView.outsideActivityButton.otherButtons.append(wannaBeMentorView.fashionAndBeautyButton)
        wannaBeMentorView.outsideActivityButton.otherButtons.append(wannaBeMentorView.satAndApplicationButton)
        //add target for the "Mentoring Field" DLRadioButtons
        wannaBeMentorView.outsideActivityButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        wannaBeMentorView.collegeLifeButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        wannaBeMentorView.friendAndRelationshipButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        wannaBeMentorView.tripAndHobbyButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        wannaBeMentorView.employmentButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        wannaBeMentorView.tutoringButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        wannaBeMentorView.fashionAndBeautyButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        wannaBeMentorView.satAndApplicationButton.addTarget(self, action: #selector(MentoringFieldSelectedButton), for: .touchUpInside)
        //textfield delegate
        wannaBeMentorView.nicknameTextField.delegate = self
        wannaBeMentorView.univTextField.delegate = self
        wannaBeMentorView.majorTextField.delegate = self
        //textview delegate
        wannaBeMentorView.mentorIntroTextView.delegate = self
        wannaBeMentorView.mentoringInfoTextView.delegate = self

        //submit button target
        wannaBeMentorView.submitButton.addTarget(self, action: #selector(doRegister), for: .touchUpInside)

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        wannaBeMentorView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        checkPermission()
        self.updateCharacterCount()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        //protoCall?.finishWithError(nil)
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
                if (!aRect.contains(wannaBeMentorView.nicknameTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(wannaBeMentorView.nicknameTextField.frame, animated: true)
                }
            }else if selected == "2"{
                if (!aRect.contains(wannaBeMentorView.univTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(wannaBeMentorView.univTextField.frame, animated: true)
                }
            }else if selected == "3"{
                if (!aRect.contains(wannaBeMentorView.majorTextField.frame.origin)) {
                    self.scrollView.scrollRectToVisible(wannaBeMentorView.majorTextField.frame, animated: true)
                }
            }else if selected == "4"{//mentoringIntroTextView
                if (!aRect.contains(wannaBeMentorView.mentorIntroTextView.frame.origin)) {
                    self.scrollView.scrollRectToVisible(wannaBeMentorView.mentorIntroTextView.frame, animated: true)
                }
            }else if selected == "5"{//mentoringInfoTextView
                if (!aRect.contains(wannaBeMentorView.mentoringInfoTextView.frame.origin)) {
                    self.scrollView.scrollRectToVisible(wannaBeMentorView.mentoringInfoTextView.frame, animated: true)
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

            wannaBeMentorView.backgroundImage.image = UIImage(data:data!)
            //backgroundimageURL = "\(userDefault.integer(forKey: "user_id"))-\(dateString).jpeg"
            backgroundimageURL = "\(userDefault.integer(forKey: "user_id"))-\((URL.absoluteURL?.query)!).jpeg"
            //store image into cache
            ImageCache.default.store(UIImage(data:data!)!, forKey: backgroundimageURL)


        }else{//profile

            //compress profile image
            self.compressImage(image: UIImage(data: data!)!){ data in
                self.profileImgData = data
            }

            wannaBeMentorView.profileImage.image = UIImage(data:data!)
            //profileimageURL = "\(userDefault.integer(forKey: "user_id"))-\(dateString).jpeg"
            profileimageURL = "\(userDefault.integer(forKey: "user_id"))-\((URL.absoluteURL?.query)!).jpeg"
            //store image into cache
            ImageCache.default.store(UIImage(data:data!)!, forKey: profileimageURL)
            
        }
        //dismiss(animated: true, completion: nil)
    }

    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        picker.dismiss(animated: true, completion: { () -> Void in

        })
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
                    
                    _ = wannaBeMentorView.univTextField.becomeFirstResponder()
                    return false
                }else if textField.tag == 2{
                    _ = wannaBeMentorView.majorTextField.becomeFirstResponder()
                    return false
                }
            }else{//.done which is majorTextField
                textField.resignFirstResponder()
                return false
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
    
    //hide keyboard when user touches the screen
    @objc func handleTap(recognizer: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func doRegister(){
        //check all the fields has been filled
        
        self.view.endEditing(true)
        //backgroundIamgeURL
        if backgroundimageURL.isEmpty {
            backgroundimageURL = "defaultImage.jpeg"
//            self.view.window?.makeToast("Set your backgroud image!", duration: 1.0, position: CSToastPositionTop)
//            return
        }
        //profileImageURL
        //nameTextField
        if profileimageURL.isEmpty {
            backgroundimageURL = "defaultImage.jpeg"
//            self.view.window?.makeToast("Set your profile image!", duration: 1.0, position: CSToastPositionTop)
//            return
        }
        //university TextField
        if(wannaBeMentorView.univTextField.text?.isEmpty)!{
            self.view.window?.makeToast("Select your university!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //major TextField
        if(wannaBeMentorView.majorTextField.text?.isEmpty)!{
            self.view.window?.makeToast("Select your major!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //mentoring area buttons
        if(MentoringAreaSelectedButton(radioButton: wannaBeMentorView.elementaryButton).selectedButtons().count == 0){
            self.view.window?.makeToast("Select your mentoring area!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //mentoring field buttons
        if(MentoringFieldSelectedButton(radioButton: wannaBeMentorView.outsideActivityButton).selectedButtons().count == 0){
            self.view.window?.makeToast("Select your mentoring field!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //mentor Introduction TextView
        if(wannaBeMentorView.mentorIntroTextView.text?.isEmpty)!{
            self.view.window?.makeToast("Fill out mentor introduction!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        //Mentoring Information TextView
        if(wannaBeMentorView.mentoringInfoTextView.text?.isEmpty)!{
            self.view.window?.makeToast("Fill out mentoring information!", duration: 1.0, position: CSToastPositionTop)
            return
        }
        
        //check if image datas is nil
        if(backgroundImgData == nil && backgroundimageURL != "defaultImage.jpeg"){
            HUD.flash(.label("Compressing Image..May some times depending on the size…"), delay: 1.5) { _ in
            }
            return
        }
        
        if(profileImgData == nil && profileimageURL != "defaultImage.jpeg"){
            HUD.flash(.label("Compressing Image..May some times depending on the size…"), delay: 1.5) { _ in
            }
            return
        }
        
        //if user fills everything, create mentor
        self.log.debug()
        let request = MentorRegisterRequest()
        request.userId = Int64(userDefault.integer(forKey: "user_id"))
        request.mentorNickname = wannaBeMentorView.nicknameTextField.text?.trimmed
        request.mentorUniversity = wannaBeMentorView.univTextField.text?.trimmed
        request.mentorMajor = wannaBeMentorView.majorTextField.text?.trimmed
        request.mentorBackgroundurl = backgroundimageURL
        request.mentorProfileurl = profileimageURL
        request.mentorMentoringArea = convertArrayToString(buttons: MentoringAreaSelectedButton(radioButton: wannaBeMentorView.elementaryButton))
        request.mentorMentoringField = convertArrayToString(buttons: MentoringFieldSelectedButton(radioButton: wannaBeMentorView.outsideActivityButton))
        request.mentorIntroduction = wannaBeMentorView.mentorIntroTextView.text.trimmed
        request.mentorInformation = wannaBeMentorView.mentoringInfoTextView.text.trimmed
        request.backgroundImage = backgroundImgData
        request.profileImage = profileImgData
        
        //server call
        if CheckNetworkConnection.isConnectedToNetwork(){
            
            GRPC.sharedInstance.authorizedUser.mentorRegister(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    self.userDefault.set(Int((res?.mentorId)!), forKey: "mentor_id")
                    HUD.hide()
                    HUD.flash(.success, delay: 1.0)
                    //self.protoCall?.finishWithError(nil)
                    if self.userDefault.string(forKey: "mentor_option") != "Revision"{
                        //it is pushed from MentorViewVC
                        let option:[String:String] = ["option":self.userDefault.string(forKey: "mentor_option")!]//this is either Best or Latest
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mentorTable"), object: nil, userInfo: option)
                            self.navigationController?.popViewController(animated: true)
                        })
                    }else{
                        self.log.debug()
                        self.view.window?.makeToast("Successfully Created!", duration: 1.0, position: CSToastPositionBottom)
                        //it is pushed from RevisionProfileVC
                        self.navigationController?.popViewController(animated: true)
                    }
                    //insert mentor info into Realm
                    let realm = try! Realm()
                    try! realm.write {
                        let mentor = MentorInfo()
                        mentor.mentor_id = Int((res?.mentorId)!)
                        mentor.user_id = (realm.objects(UserInfo.self).first?.user_id)!
                        mentor.mentor_nickname = request.mentorNickname
                        mentor.mentor_university = request.mentorUniversity
                        mentor.mentor_major = request.mentorMajor
                        mentor.mentor_background_url = request.mentorBackgroundurl
                        mentor.mentor_profile_url = request.mentorProfileurl
                        mentor.mentor_mentoring_area = request.mentorMentoringArea
                        mentor.mentor_mentoring_field = request.mentorMentoringField
                        mentor.mentor_introduction = request.mentorIntroduction
                        mentor.mentor_information = request.mentorInformation
                        realm.create(MentorInfo.self, value: mentor, update: false)
                    }
                }else{
                    HUD.hide()
                    HUD.flash(.error, delay: 1.0)
                    self.log.debug()
                    //self.log.debug("Mentor Register Error:\(err)")
                    //self.protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Mentor Register Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
                //need to cancel request no matter succeeded or failed
                //GRPC.sharedInstance.rpcCall.cancel()
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
            
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
        
        
    }

    //textview delegate
    func updateCharacterCount() {
        let mentorIntroTextViewCount = wannaBeMentorView.mentorIntroTextView.text.count
        let mentoringInfoTextViewCount = wannaBeMentorView.mentoringInfoTextView.text.count
        
        wannaBeMentorView.maximumIntroSelf.text = "\((0) + mentorIntroTextViewCount)/250"
        
        wannaBeMentorView.maximumMentoringInfo.text = "\((0) + mentoringInfoTextViewCount)/250"
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.updateCharacterCount()
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        if(textView == wannaBeMentorView.mentorIntroTextView){
            return textView.text.count +  (text.count - range.length) <= 250
        }else if(textView == wannaBeMentorView.mentoringInfoTextView){
            return textView.text.count +  (text.count - range.length) <= 250
        }
        return true
    }
    
    //helper function for combining strings
    func convertArrayToString(buttons: DLRadioButton) -> String {
        var stringArray = [String]()
        var combinedStr = String()
        for button in buttons.selectedButtons() {
            //print(String(format: "%@ is selected.2\n", button.titleLabel!.text!));
            stringArray.append(button.titleLabel!.text!)
        }
        combinedStr = stringArray.joined(separator: ",")
        log.debug("combined string: \(combinedStr)")
        return combinedStr
    }
    //photo permission
    func checkPermission() {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        }
    }
}

extension WannaBeMentorViewController{
    
    //if image is set, compress it
    
    func compressImage(image: UIImage, completion: (Data?) -> Void) {
        self.log.debug("Compressing Image")
        var data : Data?
        data = image.highQualityJPEGNSData
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

extension UIImage {
    var uncompressedPNGData: Data?      { return UIImagePNGRepresentation(self)        }
    var highestQualityJPEGNSData: Data? { return UIImageJPEGRepresentation(self, 1.0)  }
    var highQualityJPEGNSData: Data?    { return UIImageJPEGRepresentation(self, 0.75) }
    var mediumQualityJPEGNSData: Data?  { return UIImageJPEGRepresentation(self, 0.5)  }
    var lowQualityJPEGNSData: Data?     { return UIImageJPEGRepresentation(self, 0.25) }
    var lowestQualityJPEGNSData:Data?   { return UIImageJPEGRepresentation(self, 0.0)  }
}

//extension
extension UIImage {
    
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

