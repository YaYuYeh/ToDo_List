//
//  ListTableViewController.swift
//  ToDo_List
//
//  Created by Ya Yu Yeh on 2022/10/16.
//

import UIKit

class ListTableViewController: UITableViewController, UIGestureRecognizerDelegate, UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        <#code#>
    }
    
    var tasks = [Task](){
        //在陣列的計算屬性應用prperty observer:每次陣列變動時，會觸發儲存陣列的動作
        didSet{
            Task.saveTask(tasks)
        }
    }
    var longPress:UILongPressGestureRecognizer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let searchController = UISearchController()
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        
        
        
        
        //打開app時會自動讀取儲存的陣列
        if let tasks = Task.loadTask(){
            //原本的陣列=儲存後讀取的陣列
            self.tasks = tasks
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        let task = tasks[indexPath.row]
        cell.textLabel?.text = task.taskTitle
        cell.textLabel?.font = .systemFont(ofSize: 18)
        
        //設定datePicker選擇的日期格式，並轉為字串
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let deadlineStr = dateFormatter.string(from: task.deadline)
        cell.detailTextLabel?.text = deadlineStr
        cell.detailTextLabel?.textColor = .darkGray
        
        
        //利用attributedString設定文字樣式->刪除線
        var attributedTaskTitle = AttributedString(task.taskTitle)
        var container = AttributeContainer()
        //任務為完成狀態，右側會打勾並顯示刪除線，反之則無
        if task.isDone{
            container.inlinePresentationIntent = .strikethrough
            attributedTaskTitle.setAttributes(container)
            //attributedText型別為NSAttributedString
            cell.textLabel?.attributedText = NSAttributedString(attributedTaskTitle)
            
            
            
            cell.accessoryType = .checkmark
            
        }else{
            container.inlinePresentationIntent = .none
            attributedTaskTitle.setAttributes(container)
            cell.textLabel?.attributedText = NSAttributedString(attributedTaskTitle)
            cell.accessoryType = .none
        }
        
        //產生一個長按手勢:表格會重複呼叫重新顯示的表格，因此在產生手勢前需要先清空
        cell.gestureRecognizers?.removeAll()
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(handlerLongPress(recognier:  )))
        if let longPress{
            longPress.delegate = self
            cell.addGestureRecognizer(longPress)
        }

       return cell
    }
    //左滑刪除
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //將選取的資料，從陣列中移除
        tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    //MARK: - Table view delegate
    //點擊儲存格後切換是否完成的開關：改變陣列該項變數的值，並更新表格顯示的內容
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tasks[indexPath.row].isDone = !tasks[indexPath.row].isDone
        tableView.reloadData()
    }
    
    // MARK: - Taget action
    //長按進入編輯頁面，修改已存在的資料
    @objc func handlerLongPress(recognier:UILongPressGestureRecognizer){
        if recognier.state == .ended{
            if let cell = recognier.view as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell){
                performSegue(withIdentifier: "Revise", sender: indexPath)
            }
        }
    }
    //透過segue轉型為編輯頁面，將要修改的資料傳遞至他的儲存屬性
    @IBSegueAction func passRevisedVC(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> EditTableViewController? {
        let revisedVC = EditTableViewController(coder: coder)
        if let indexPath = sender as? IndexPath{
            revisedVC?.task = tasks[indexPath.row]
            return revisedVC
        }else{
            print("long press failed")
            return nil
        }
    }
    
    
    // MARK: - Navigation
    @IBAction func unwindToListTVC(_ unwindSegue: UIStoryboardSegue) {
        //透過unwindSegue轉型為編輯頁面，來存取他儲存的資料task
        if let source = unwindSegue.source as? EditTableViewController,
           let task = source.task{
            if let cell = longPress?.view as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell){
                print("revise:\(indexPath)")
                tasks[indexPath.row] = task
                tableView.reloadData()
            }
            else{
                //取到新建立的task資料，新增到task陣列中
                tasks.insert(task, at: 0)
                tableView.reloadData()
                print("insert at 0")
            }
        }
    }


    /*

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

