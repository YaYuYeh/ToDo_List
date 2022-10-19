//
//  ListTableViewController.swift
//  ToDo_List
//
//  Created by Ya Yu Yeh on 2022/10/16.
//

import UIKit

class ListTableViewController: UITableViewController, UIGestureRecognizerDelegate{
    
    var tasks = [Task](){
        //在陣列的計算屬性應用prperty observer:每次陣列變動時，會觸發儲存陣列的動作
        didSet{
            Task.saveTask(tasks)
        }
    }
    var longPress:UILongPressGestureRecognizer?
    //宣告惰性儲存屬性，來儲存表格顯示的陣列，未使用search時，顯示的內容會是全部的tasks，直到第一次存取時，才會設定filterTasks的內容，可讓程式更有效率。
    lazy var filterTasks = tasks

    override func viewDidLoad() {
        super.viewDidLoad()
        createSearchController()
    }
    
    //點擊Add新增Task：清理手勢，並切換到下一頁
    @IBAction func toEdit(_ sender: Any) {
        longPress = nil
        print("清理手勢")
        //切換頁面到下一頁(編輯頁面)
        guard let controller = storyboard?.instantiateViewController(withIdentifier: "EditTableViewController") else { return }
        navigationController?.pushViewController(controller, animated: true)
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
        cell.textLabel?.font = UIFont(name: "MuktaMahee Regular", size: 18)
        
        //設定datePicker選擇的日期格式，並轉為字串
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let deadlineStr = dateFormatter.string(from: task.deadline)
        cell.detailTextLabel?.text = deadlineStr
        cell.detailTextLabel?.textColor = .darkGray
        cell.detailTextLabel?.font = UIFont(name: "DIN Alternate", size: 13)
        
        
        
        
        
        //利用attributedString設定文字樣式->刪除線
        var attributedTaskTitle = AttributedString(task.taskTitle)
        var container = AttributeContainer()
        //任務為完成狀態，右側會打勾並顯示刪除線，反之則無
        if task.isDone{
            container.inlinePresentationIntent = .strikethrough
            cell.accessoryType = .checkmark
            print("任務完成")
        }else{
            container.inlinePresentationIntent?.remove(.strikethrough)
            //container.inlinePresentationIntent = .none
            cell.accessoryType = .none
            print("任務未完成")
        }
        attributedTaskTitle.setAttributes(container)
        //attributedText型別為NSAttributedString
        cell.textLabel?.attributedText = NSAttributedString(attributedTaskTitle)
        
        
        
        
        
        //產生一個長按手勢:表格會重複呼叫重新顯示的表格，因此在產生手勢前需要先清空
        cell.gestureRecognizers?.removeAll()
        longPress = UILongPressGestureRecognizer(target: self, action: #selector(handlerLongPress(recognizer:  )))
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
        print("轉換完成狀態")
    }
    
    // MARK: - Taget action
    //長按進入編輯頁面，修改已存在的資料
    @objc func handlerLongPress(recognizer:UILongPressGestureRecognizer){
        if recognizer.state == .ended{
            if let cell = recognizer.view as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell){
                performSegue(withIdentifier: "Revise", sender: indexPath)
                //長按時儲存手勢
                longPress = recognizer
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
            //longPress有值，代表長按修改
            if let cell = longPress?.view as? UITableViewCell,
               let indexPath = tableView.indexPath(for: cell){
                print("revise:\(indexPath)\n\n array:\(tasks)")
                tasks[indexPath.row] = task
                tableView.reloadData()
            }else{
                //longPress為空值，代表點擊add新增
                //取到新建立的task資料，新增到task陣列中
                tasks.insert(task, at: 0)
                tableView.reloadData()
                print("insert at 0\n\n array:\(tasks)")
            }
        }
    }
}

