//
//  TaskDetailViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/03/24.
//

import UIKit

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var taskTextField: UITextField!
    var taskTitle = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskTextField.text = taskTitle
    }
    
    @IBAction func cancelBarButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneBarButtonAction(_ sender: Any) {
        print(taskTitle)
    }
}
