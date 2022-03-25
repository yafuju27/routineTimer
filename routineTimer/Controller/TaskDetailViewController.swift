//
//  TaskDetailViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/03/24.
//

import UIKit
import RealmSwift

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var taskTextField: UITextField!
    var selectedRoutineID = ""
    var selectedTaskID = ""
    let realm = try! Realm()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedRoutineID).first
        let task = target?.task.filter("taskID == %@", selectedTaskID).first
        taskTextField.text = task?.taskTitle
    }
    
    @IBAction func cancelBarButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneBarButtonAction(_ sender: Any) {
    }
}
