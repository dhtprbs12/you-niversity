//
//  DonationViewController.swift
//  MyUniversity
//
//  Created by 오세균 on 7/12/18.
//  Copyright © 2018 SekyunOh. All rights reserved.
//

import Foundation
import UIKit
import XCGLogger
import Material
import StoreKit
import StoreKit
import XCGLogger
import RealmSwift

//even using sand box test, this does not work.
//To work this, the app should be submitted and reviewed

class DonationViewController: UITableViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver{
    
    
    var productIDs = Set(["50_Coins","150_Coins","300_Coins"])
    var productsArray : Array<SKProduct?> = []
    var selectedProductIndex: Int!
    var transactionInProgress = false
    let log = XCGLogger.default
    let realm = try! Realm()
    var selectedRow : Int? = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Donation"
        self.navigationController?.navigationBar.isTranslucent = false
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Products", style: .plain, target: nil, action: nil)
        // Replace the product IDs with your own values if needed.
  
        
        
        requestProductInfo()
        
        SKPaymentQueue.default().add(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.backgroundColor = UIColor.white
        self.tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //이걸 해주지 않으면 하나의 상품 구매후 다른상품을 또 구매할때 에러뜸
        //showActions()의 SKPaymentQueue.default().add(payment)
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: Custom method implementation
    
    func requestProductInfo() {
        if SKPaymentQueue.canMakePayments() {
            //log.debug(productIDs)
            //let productIdentifiers = NSSet(array: productIDs)
//            let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers as Set<NSObject> as! Set<String>)
            let productRequest = SKProductsRequest(productIdentifiers: self.productIDs as Set<NSObject> as! Set<String>)
            
            productRequest.delegate = self
            productRequest.start()
        }
        else {
            log.debug("Please, activate your In-App-Purchase in setting")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .value1, reuseIdentifier: "Cell")
        
        let product = productsArray[indexPath.row]
        cell.textLabel?.text = product?.localizedTitle
        cell.detailTextLabel?.text = product?.localizedDescription
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedRow = indexPath.row
        selectedProductIndex = indexPath.row
        showActions()
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func showActions() {
        if transactionInProgress {
            return
        }
        
        let actionSheetController = UIAlertController(title: "Notification", message: "Want to purchase?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let buyAction = UIAlertAction(title: "Purchase", style: UIAlertActionStyle.default) { (action) -> Void in
            let payment = SKPayment(product: self.productsArray[self.selectedProductIndex]! as SKProduct)
            self.log.debug(payment.productIdentifier)
            SKPaymentQueue.default().add(payment)
            self.transactionInProgress = true
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheetController.addAction(buyAction)
        actionSheetController.addAction(cancelAction)
        
        present(actionSheetController, animated: true, completion: nil)
    }
    
    // MARK: SKProductsRequestDelegate method implementation
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        
        if response.products.count != 0 {
            for product in response.products {
                log.debug("\(product.localizedTitle) -- \(product.localizedDescription)")
                productsArray.append(product)
            }
            
            self.tableView.reloadData()
        }
        else {
            log.debug("There are no products.")
        }
        
        if response.invalidProductIdentifiers.count != 0 {
            log.debug(response.invalidProductIdentifiers.description)
        }
    }
    
    
    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
//        let user_id = realm.objects(UserInfo.self).first?.user_id
//        var berry = realm.objects(UserInfo.self).first?.berry
//
//        if selectedRow == 0{
//            berry = berry! + 30
//        }else if selectedRow == 1{
//            berry = berry! + 100
//        }
//        else if selectedRow == 2{
//            berry = berry! + 200
//        }
//        else if selectedRow == 3{
//            berry = berry! + 400
//        }
//        else if selectedRow == 4{
//            berry = berry! + 1000
//        }
        
        for transaction in transactions {
            switch transaction.transactionState {
            case SKPaymentTransactionState.purchased:
                log.debug("Transaction completed successfully.")
                let alertController = UIAlertController(
                    title: "Complete",
                    message: "Purchased Successfully",
                    preferredStyle: .alert
                )
                let okay = UIAlertAction(title: "Confirm", style: .default)
                alertController.addAction(okay)
                self.present(alertController, animated: true, completion: nil)
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                break
                //validateReceipt()
                
            case SKPaymentTransactionState.failed:
                log.debug("Transaction Failed");
                SKPaymentQueue.default().finishTransaction(transaction)
                transactionInProgress = false
                let alertController = UIAlertController(
                    title: "Fail",
                    message: "Purchase Failed. Try Again",
                    preferredStyle: .alert
                )
                let okay = UIAlertAction(title: "Confirm", style: .default)
                alertController.addAction(okay)
                self.present(alertController, animated: true, completion: nil)
                break
            default:
                print(transaction.transactionState.rawValue)
            }
        }
    }
    
    func validateReceipt(){
        //here 'return' was just 'return' not 'return 1' before function became '-> Int'
        guard let receiptURL = Bundle.main.appStoreReceiptURL else { return }
        
        guard let receipt = NSData(contentsOf: receiptURL) else { return }
        
        var result = Int()
        
        if(receipt.length == 0){
            print("Receipt does not exist")
            result = 1
        }else{
            
            let receiptData = receipt.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let payload = ["receipt-data": receiptData]
            
            var receiptPayloadData: NSData?
            
            do {
                receiptPayloadData = try JSONSerialization.data(withJSONObject: payload, options: JSONSerialization.WritingOptions(rawValue: 0)) as NSData?
            }
            catch let error as NSError {
                print(error.localizedDescription)
                result = 1
                return
            }
            //else문은 guard문이 false일때만 실행이 됩니다
            guard let payloadData = receiptPayloadData else { return }
            guard let requestURL = NSURL(string: "https://sandbox.itunes.apple.com/verifyReceipt") else { return }
            
            let request = NSMutableURLRequest(url: requestURL as URL)
            request.httpMethod = "POST"
            request.httpBody = payloadData as Data
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                    result = 1
                    return
                }
                guard let data = data else { return }
                
                do {
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary
                    
                    guard let json = jsonData else { return }
                    
                    // Correct ?
                    guard let status = json["status"] as? Int, status == 0 else { return }
                    
                    // Unlock product here?
                    // Other checks needed?
                    
                    //its printing works great
                    //print("data: \(jsonData)--\(jsonData?["status"])")
                    
                    //result = Int(status["status"])
                    
                }
                    
                catch let error as NSError {
                    print(error.localizedDescription)
                    
                    return
                }
            }
            //you must start it by calling its resume() method.
            task.resume()
            //return result
        }
    }
}

//class DonationViewController:UITableViewController{
//
//    var log = XCGLogger.default
//    var headerView : DonationViewControllerHeaderView!
//
//    override func loadView() {
//        super.loadView()
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//         headerView = DonationViewControllerHeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.frame.width / 3+30))
//        self.tableView.tableHeaderView  = headerView
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
//
//        cell.textLabel?.text = "Hello"
//        cell.detailTextLabel?.text = "My name is sekyunoh"
//
//        return cell
//
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 10
//    }
//}
//
//class DonationViewControllerHeaderView: UIView{
//
//    var univBackgroundImage: UIImageView!
//    var univLogoImage: UIImageView!
//    var univName: UILabel!
//
//    //UIView overrided methods
//    convenience init() {
//        self.init(frame: UIScreen.main.bounds)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        self.backgroundColor = UIColor.white
//
//        univBackgroundImage = UIImageView()
//        //univBackgroundImage.image = UIImage(named:"stanford")
//        univBackgroundImage.backgroundColor = App.mainColor
//        addSubview(univBackgroundImage)
//        univBackgroundImage.snp.makeConstraints{
//            $0.top.equalTo(self.snp.top)
//            $0.width.equalTo(self.snp.width)
//            $0.height.equalTo(self.frame.width / 3+20)
//        }
//
//        univLogoImage = UIImageView()
//        univLogoImage.backgroundColor = UIColor.gray
//        univLogoImage.layer.borderColor = UIColor.white.cgColor
//        univLogoImage.layer.borderWidth = 1.0
//        univLogoImage.layer.cornerRadius = 5.0
//        univLogoImage.image = UIImage(named:"sekyunoh")
//        addSubview(univLogoImage)
//        univLogoImage.snp.makeConstraints{
//            $0.bottom.equalTo(univBackgroundImage.snp.bottom).offset(-5)
//            $0.width.equalTo(50)
//            $0.height.equalTo(50)
//            $0.left.equalTo(self.snp.left).offset(10)
//        }
//
//        univName = UILabel()
//        univName.font = UIFont.boldSystemFont(ofSize: 15)
//        univName.textColor = UIColor.white
//        univName.text = "Donation to improve the app!"
//        univName.numberOfLines = 0
//        addSubview(univName)
//        univName.snp.makeConstraints{
//            $0.bottom.equalTo(univLogoImage.snp.bottom)
//            $0.left.equalTo(univLogoImage.snp.right).offset(10)
//            $0.width.equalTo(self.frame.size.width - 100)
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//
//}
