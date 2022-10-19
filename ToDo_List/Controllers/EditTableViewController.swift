//
//  TaskTableViewController.swift
//  ToDo_List
//
//  Created by Ya Yu Yeh on 2022/10/16.
//

import UIKit

class EditTableViewController: UITableViewController {

    @IBOutlet weak var taskTitleTextField: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    @IBOutlet weak var doneSwitch: UISwitch!
    @IBOutlet weak var remarkTextView: UITextView!
    
    //新增時為空值，修改則有值
    var task:Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateReivsion()
        setDatePicker()
    }
    
    func updateReivsion(){
        //建立新的task時，由列表傳過來的資料為空
        if let task{
            doneSwitch.isOn = false
            taskTitleTextField.text = task.taskTitle
            deadlinePicker.date = task.deadline
            doneSwitch.isOn = task.isDone
            remarkTextView.text = task.remark
        }
    }
    //datePicker設定
    func setDatePicker(){
        //最小值為當天
        deadlinePicker.minimumDate = Date()
        //只顯示日期，不顯示時間
        deadlinePicker.datePickerMode = .date
        //水平靠左
        deadlinePicker.contentHorizontalAlignment = .leading
    }
    
    //header高度
       override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 0
       }
    
    //判斷segue是否達成條件，可觸發unwind回到上一頁
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        //若編輯的textfield皆有值，則完成編輯回傳到上一頁
        if taskTitleTextField.text?.isEmpty == false{
            return true
        }else{
            //未完成編輯，跳出警告視窗
            let alert = UIAlertController(title:"資料不完整", message: "請輸入任務名稱", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "確認", style: .default)
            alert.addAction(okAction)
            present(alert, animated: true)
            
            return false
        }
    }


    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let taskTitle = taskTitleTextField.text ?? ""
        let deadline = deadlinePicker.date
        let isdone = doneSwitch.isOn
        let remark = remarkTextView.text ?? ""
        
        task = Task(taskTitle: taskTitle, deadline: deadline, isDone: isdone, remark: remark)
    }
}
