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

class MentorSearchController: UITableViewController, UISearchControllerDelegate{
    
    
    var shownUniversities = [String]()
    var allUniversities = [String]()
    let log = XCGLogger.default
    let userDefaults = UserDefaults.standard
    
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
        tabItem.titleLabel?.numberOfLines = 0
        tabItem.title = "Mentor By University"
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
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
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
        
        let selectedOption:[String:String] = ["option":name]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mentorTable"), object: nil, userInfo: selectedOption)
        self.navigationController?.popViewController(animated: true)
    }
    
}

