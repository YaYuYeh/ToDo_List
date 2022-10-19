//
//  Task.swift
//  ToDo_List
//
//  Created by Ya Yu Yeh on 2022/10/16.
//

import Foundation

struct Task:Codable{
    var taskTitle:String
    var deadline:Date
    var isDone:Bool
    var remark:String
    
    //存在struct宣告為型別屬性，可透過型別呼叫
    //將Drink編碼變成Data後，儲存到UserDefaults
    static func saveTask(_ tasks:[Task]){
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(tasks) else {return}
        let userdefaults = UserDefaults.standard
        userdefaults.set(data, forKey: "tasks")
    }
    
    //從UserDefault讀出Data後，將它解碼變回Drink陣列，並回傳該資料
    //[Drink]? 選擇值是因為當沒存東西時就回傳nil
    static func loadTask() -> [Task]?{
        guard let data = UserDefaults.standard.data(forKey: "tasks") else {return nil}
        let decoder = JSONDecoder()
        return try? decoder.decode([Task].self, from: data)
    }
}
