//
//  VerificationViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2017. 12. 28..
//  Copyright © 2017년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger



class VerificationViewController: UIViewController, UITextFieldDelegate{
    
    //captchavalue from the server
    //will be compared to user input
    var captchaValue = String()
    let log = XCGLogger.default
    var protoCall : GRPCProtoCall?
    
    var verificationView: VerificationView{
        return self.view as! VerificationView
    }
    
    override func loadView() {
        super.loadView()
        self.view = VerificationView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        verificationView.textField.delegate = self
        verificationView.continueButton.addTarget(self, action: #selector(ctnBtnTapped), for: .touchUpInside)
        verificationView.refreshButton.addTarget(self, action: #selector(rfsBtnTapped), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestVerification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func requestVerification(){
        
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = CaptchaRequest()
            GRPC.sharedInstance.user.getCaptchaWith( request, handler: {
                (res,err) in

                if res != nil {
                    
                    self.captchaValue = (res?.key)!
                    self.verificationView.imageView.image = UIImage(data: (res?.captcha)!)
                    //self.protoCall?.finishWithError(nil)
                }else{
                    //not viewWillDisapper becuase "refresh Captcha value"
                    //self.protoCall?.finishWithError(err)
                    self.log.debug("Verification Error:\(err)")
                    if(err != nil){
                        self.view.window?.makeToast("Verification Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //protoCall?.timeout = App.timeout
            //protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionTop)
        }
        
    }
    
    @objc func ctnBtnTapped(){
        //인증코드와 유저가 입력한 코드가 맞으면 ProfileViewController로 넘어가고 틀리면 captcha 값 다시 가져옴
        
        //self.present(RegisterViewController(), animated: true, completion: nil)
        
        if(verificationView.textField.text?.trimmed == "" || (verificationView.textField.text?.trimmed.isEmpty)!){
            verificationView.textField.detail = "Enter the numbers above!"
            verificationView.textField.isErrorRevealed = true
            
        }else{
            
            if(captchaValue == verificationView.textField.text?.trimmed){
                
                self.present(RegisterViewController(), animated: true, completion: nil)
            }else{
                verificationView.textField.text = ""
                verificationView.textField.detail = "Try Again!"
                verificationView.textField.isErrorRevealed = true
                rfsBtnTapped()
            }
        }
    }
    
    @objc func rfsBtnTapped(){
        
        verificationView.textField.text = ""
        verificationView.textField.isErrorRevealed = false
        requestVerification()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches , with:event)
        self.view.endEditing(true)
    }
    
    
    // MARK: UITextViewDelegate methods
    //verificationView = self 하면 무조건 textfield의 관한 delegate 메소드들을 self(뷰컨트롤러에 선언해줘야 에러 안뜸)
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //verificationView.textField.isErrorRevealed = false
        return true;
    }
    
}
