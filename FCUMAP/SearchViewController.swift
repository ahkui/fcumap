//
//  SearchViewController.swift
//  FCUMAP
//
//  Created by RTC18 on 2016/12/9.
//  Copyright © 2016年 AhKui-D0562215. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    @IBOutlet var searchTableView:UITableView!
    var searchController = UISearchController()
    var pointFindList:Array<pointInfo> = []
    var searchList:[pointInfo]!
    var end:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "尋找地方"
        searchController.searchBar.tintColor = UIColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0)
        searchController.searchBar.barTintColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.6)
        self.navigationItem.titleView = searchController.searchBar
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return pointFindList.count
        }else{
            return searchList.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.searchTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchTableViewCell
        let _name = (searchController.isActive) ? pointFindList[indexPath.row] : searchList[indexPath.row]
        cell.name.text = _name.name!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = (searchController.isActive) ? pointFindList[indexPath.row] : searchList[indexPath.row]
        end = key.key!
        performSegue(withIdentifier: "unwindToMapView", sender: end)
    }
    public func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text{
            filterContentForSearchText(searchText)
            searchTableView.reloadData()
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
        if searchText==""{
            pointFindList = searchList
        }
        else{
            pointFindList = searchList.filter({(point) -> Bool in
                if point.key!.localizedCaseInsensitiveContains(searchText) || point.name!.localizedCaseInsensitiveContains(searchText) {
                    return true
                }
                return false
            })
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
