//
//  QandADetailViewController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 29..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import Material
import XCGLogger
import Then
import SnapKit
import PKHUD


class QandADetailViewController: UIViewController,UIScrollViewDelegate,UITextViewDelegate{
    
    
    var scrollView: UIScrollView!
    var qandaDetailView: QandADetailView!
    let userDefault = UserDefaults.standard
    var object : BoardObject?
    var comments = [CommentObject]()
    let log = XCGLogger.default
    var commentLabelGestureRecognizer : UITapGestureRecognizer!
    //this is for when the board is about Universities Review not Common Board and Q&A
    var longString : String!
    var advantageRange : NSRange!
    var disadvantageRange : NSRange!
    var briefRange : NSRange!
    var longAttributedStr :NSMutableAttributedString!
    
    var getNumberOfComments_protoCall : GRPCProtoCall?
    
    override func loadView() {
        super.loadView()
        qandaDetailView = QandADetailView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //place QandADetailView under navigation bar
        self.edgesForExtendedLayout = []
        self.navigationItem.title = "Q&A"
        self.view.isUserInteractionEnabled = true
        commentLabelGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(self.commentLabelTapped(sender:)))
        qandaDetailView.seeOrReadCommentsLabel.addGestureRecognizer(commentLabelGestureRecognizer)
        //set scrollview
        scrollView = UIScrollView()
        scrollView.delegate = self

        //to make view to be scrollable, scrollView.contentSize should be smaller than registerView's size
        scrollView.contentSize = CGSize(width:qandaDetailView.bounds.width, height:qandaDetailView.bounds.height)
        scrollView.addSubview(qandaDetailView)
        self.view.addSubview(scrollView)
        qandaDetailView.detailTextView.delegate = self
        
        loadBoard()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //when it goes back to Q&A VC, remove userDefault "board"
        if (self.isMovingFromParentViewController) {
            self.log.debug()
            userDefault.removeObject(forKey: "board")
        }

    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = self.view.bounds
        qandaDetailView.frame = CGRect(x:0, y:0, width:scrollView.contentSize.width, height:scrollView.contentSize.height)
        
    }
}

extension QandADetailViewController{
    
    func loadBoard(){
        let decoded  = userDefault.object(forKey: "board") as! Data
        object = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? BoardObject
        //load comments count
        loadCommentsCount(board_id:Int64((object?.board_id)!))
        
        qandaDetailView.nickname.text = object?.user_nickname
        qandaDetailView.time.text = object?.board_created
        
        qandaDetailView.title.text = (object?.board_title)!
        
        qandaDetailView.visitCount.text = String(describing: (object?.touch_count)!)
        qandaDetailView.commentCount.text = String(describing: (object?.comment_count)!)
        
        if userDefault.string(forKey: "tableName") == "Universities Review"{
            longString = object?.board_content
            
            advantageRange = (longString! as NSString).range(of: "Advantage:")
            disadvantageRange = (longString! as NSString).range(of: "Disadvantage:")
            briefRange = (longString! as NSString).range(of: "Brief:")
            
            longAttributedStr = NSMutableAttributedString(string: longString!, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
            longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.red], range: advantageRange)
            longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17), NSAttributedStringKey.foregroundColor : UIColor.blue], range: disadvantageRange)
            longAttributedStr.setAttributes([NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 17)], range: briefRange)
            
            
            qandaDetailView.detailTextView.attributedText = longAttributedStr
        }else{
            qandaDetailView.detailTextView.text = object?.board_content
        }
    }
    
    func loadCommentsCount(board_id:Int64){
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetCommentsCountRequest()
            request.boardId = board_id
            
            GRPC.sharedInstance.authorizedUser.getCommentsCount(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.getNumberOfComments_protoCall?.finishWithError(nil)
                    self.qandaDetailView.seeOrReadCommentsLabel.text = "Tap Here to Read/Post \((res?.count)!) Comment(s)"
                }else{
                    self.log.debug("Get Comments Count Error:\(err)")
                    //self.getNumberOfComments_protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get Comments Count Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //getNumberOfComments_protoCall?.timeout = App.timeout
            //getNumberOfComments_protoCall?.start()
        }else{
            HUD.flash(.label("Check Your Network..."), delay: 1.0)
        }
    }
    
    @objc func commentLabelTapped(sender: UITapGestureRecognizer){
        let commentTableVC = CommentTableViewController()
        commentTableVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(commentTableVC, animated: true)
    }
}
