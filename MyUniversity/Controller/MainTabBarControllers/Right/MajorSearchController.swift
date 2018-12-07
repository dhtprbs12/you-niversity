//
//  MajorSearchController.swift
//  MyUniversity
//
//  Created by SekyunOh on 2018. 1. 15..
//  Copyright © 2018년 SekyunOh. All rights reserved.
//

import Foundation
import Foundation
import XCGLogger
import RxSwift
import RxCocoa
import Then
import SnapKit
import Material

class MajorSearchController: UITableViewController, UISearchResultsUpdating{
    let unfilteredNFLTeams = ["Bengals", "Ravens", "Browns", "Steelers", "Bears", "Lions", "Packers", "Vikings",
                              "Texans", "Colts", "Jaguars", "Titans", "Falcons", "Panthers", "Saints", "Buccaneers",
                              "Bills", "Dolphins", "Patriots", "Jets", "Cowboys", "Giants", "Eagles", "Redskins",
                              "Broncos", "Chiefs", "Raiders", "Chargers", "Cardinals", "Rams", "49ers", "Seahawks"].sorted()
    var filteredNFLTeams: [String]?
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabItem.title = "Major"
        filteredNFLTeams = unfilteredNFLTeams
        searchController.searchResultsUpdater = self
        //searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.showsCancelButton = false
        //searchController.dimsBackgroundDuringPresentation = false
        //when touch screen, able to disappear search bar
        definesPresentationContext = true
        //make it have same color to tableview
        searchController.searchBar.barTintColor = UIColor.white
        tableView.tableHeaderView = searchController.searchBar
    }
    
    //set full size of view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let nflTeams = filteredNFLTeams else {
            return 0
        }
        return nflTeams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        
        if let nflTeams = filteredNFLTeams {
            let team = nflTeams[indexPath.row]
            cell.textLabel!.text = team
        }
        
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            filteredNFLTeams = unfilteredNFLTeams.filter { team in
                return team.lowercased().contains(searchText.lowercased())
            }
            
        } else {
            filteredNFLTeams = unfilteredNFLTeams
        }
        tableView.reloadData()
    }
}
