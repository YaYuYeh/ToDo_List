//
//  extensionUISearchResultsUpdating.swift
//  ToDo_List
//
//  Created by Ya Yu Yeh on 2022/10/17.
//

import UIKit
//遵從UISearchResultsUpdating
extension ListTableViewController:UISearchResultsUpdating{
    //產生UISearchController
    func createSearchController(){
        //建立實體
        let searchController = UISearchController()
        //顯示在navigationItem上
        navigationItem.searchController = searchController
        //表格捲動時，讓searchBar不跟著動，持續顯示在navigationBar上
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchResultsUpdater = self
        
        //打開app時會自動讀取儲存的陣列
        if let tasks = Task.loadTask(){
            //原本的陣列=儲存後讀取的陣列
            self.tasks = tasks
        }
    }
    
    
    
    //search bar輸入文字時，將觸發此function 因此可在實作中依據search bar的文字調整表格對應的陣列內容。
    func updateSearchResults(for searchController: UISearchController) {
        //輸入搜尋文字，使用高階函式filter篩選出符合的任務名稱
        if let searchText = searchController.searchBar.text,
           searchText.isEmpty == false{
            filterTasks = tasks
            filterTasks = tasks.filter({ task in
                task.taskTitle.localizedStandardContains(searchText)
            })
        }else{
            //若沒有使用搜尋，則filterTask內容為全部陣列？？
            filterTasks = tasks
        }
        tableView.reloadData()
    }
}
