//
//  UnivSearchController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 12..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import XCGLogger
import RxSwift
import RxCocoa
import Then
import SnapKit
import Material

class UnivSearchController: UITableViewController, UISearchControllerDelegate{

    
    var shownUniversities = [String]()
    var allUniversities = [String]()
    let log = XCGLogger.default
    let userDefault = UserDefaults.standard
    var protoCall : GRPCProtoCall?

    let searchController = UISearchController(searchResultsController: nil)
    
    override func loadView() {
        super.loadView()
        do {
            let path = Bundle.main.path(forResource: "universities", ofType: "txt")
            let file = try String(contentsOfFile: path!)
            allUniversities = file.components(separatedBy: "\n")
            
        } catch {
            Swift.print("Fatal Error: Couldn't read the contents!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem.title = "University"
        searchController.searchBar.placeholder = "Search"
        //when touch screen, able to disappear search bar
        definesPresentationContext = true
        
        //make it have same color to tableview
        searchController.searchBar.barTintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.searchBar
            .rx.text // RxCocoa의 Observable 속성
            .orEmpty // 옵셔널이 아니도록 만듭니다.
            .debounce(0.5, scheduler: MainScheduler.instance) // Wait 0.5 for changes.
            .distinctUntilChanged() // 새로운 값이 이전의 값과 같은지 확인합니다.
            .filter { !$0.isEmpty } // 새로운 값이 정말 새롭다면, 비어있지 않은 쿼리를 위해 필터링합니다.
            .subscribe(onNext: { [unowned self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                self.shownUniversities = self.allUniversities.filter { $0.uppercased().contains(query.uppercased()) } // 도시를 찾기 위한 “API 요청” 작업을 합니다.
                self.tableView.reloadData() // 테이블 뷰를 다시 불러옵니다.
            })
            .disposed(by: App.disposeBag)
    }
    
    //set full size of view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (self.isMovingToParentViewController) {
            protoCall?.finishWithError(nil)
        }
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shownUniversities.count == 0{
            return allUniversities.count
        }else{
            return shownUniversities.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        if shownUniversities.count == 0{
            cell.textLabel?.text = allUniversities[indexPath.row]
        }else{
            cell.textLabel?.text = shownUniversities[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var name = String()
        if shownUniversities.count != 0{
            name = shownUniversities[indexPath.row]
        }else{
            name = allUniversities[indexPath.row]
        }
        
        if CheckNetworkConnection.isConnectedToNetwork(){
            let request = GetUniversityByNameRequest()
            request.name = name
            
            GRPC.sharedInstance.authorizedUser.getUniversityByName(with: request, handler: {
                (res,err) in
                
                if res != nil{
                    //self.protoCall?.finishWithError(nil)
                    let res = (res?.university)!
                    let university = UniversityObject(university_id: Int(res.universityId), name: res.name, ranking: res.ranking, website: res.website, address: res.address, num_of_students: res.numOfStudents, tuition_fee: res.tuitionFee, sat: res.sat, act: res.act, application_fee: res.applicationFee, sat_act: res.satAct, high_school_gpa: res.highSchoolGpa, acceptance_rate: res.acceptanceRate,crawling_url:res.crawlingURL)
                    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: university)
                    self.userDefault.set(encodedData, forKey: "university")
                    //Whenever you’ve changed the user defaults you need to synchronize them, to make the changes persist on the disk.
                    self.userDefault.synchronize()
                    self.navigationController?.pushViewController(UniversityDetailViewController(), animated: true)
                }else{
                    
                    self.log.debug("Get UniversityError:\(err)")
                    //self.protoCall?.finishWithError(err)
                    if(err != nil){
                        self.view.window?.makeToast("Get University Error", duration: 1.0, position: CSToastPositionBottom)
                    }
                }
            })
            //self.protoCall?.timeout = App.timeout
            //self.protoCall?.start()
        }else{
            self.view.window?.makeToast("Check your network", duration: 1.0, position: CSToastPositionBottom)
            
        }
        
        
    }
 
}

extension String{
    func contains(_ find: String) -> Bool{
        return self.range(of: find) != nil
    }
}
