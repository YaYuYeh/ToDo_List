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
    
    @IBOutlet weak var label: UILabel!
    var task:Task?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateReivsion()
        //datePicker樣式設定
        deadlinePicker.minimumDate = Date()
        deadlinePicker.datePickerMode = .date
        deadlinePicker.contentHorizontalAlignment = .leading
        
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
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if taskTitleTextField.text?.isEmpty == false{
            return true
        }else{
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
