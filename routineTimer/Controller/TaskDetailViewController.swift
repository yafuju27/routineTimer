//
//  TaskDetailViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/03/24.
//「分」「秒」を追加


import UIKit
import RealmSwift

class TaskDetailViewController: UIViewController {
    @IBOutlet weak var taskTitleView: UIView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTimeTextView: UITextView!
    @IBOutlet weak var taskTimePickerView: UIPickerView!
    private let routineModel = Routine()
    
    private var timer:Timer = Timer()
    let timeList = [[Int](0...60), [Int](0...60)]
    var minCount:Int = 0
    var secCount:Int = 0
    
    var selectedRoutineID = ""
    var selectedTaskID = ""
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //ScondViewControllerの値を反映
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedRoutineID).first
        let task = target?.task.filter("taskID == %@", selectedTaskID).first
        taskTextField.text = task?.taskTitle
        taskTimeTextView.text = task?.taskTime
        
        createPickerLabels()
        createShape()
        getTimeCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getTimeCount() {
        minCount = timeList[0][taskTimePickerView.selectedRow(inComponent: 0)]
        secCount = timeList[0][taskTimePickerView.selectedRow(inComponent: 1)]
        taskTimeTextView.text = " \(minCount) 分 \(secCount) 秒"
    }
    
    func createShape() {
        taskTitleView.layer.cornerRadius = 5.0
        taskTimeTextView.layer.masksToBounds = true
        taskTextField.layer.cornerRadius = 5.0
        taskTextField.layer.masksToBounds = true
        taskTimeTextView.layer.cornerRadius = 5.0
        taskTimeTextView.layer.masksToBounds = true
    }
    
    @IBAction func cancelBarButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneBarButtonAction(_ sender: Any) {
        let title = taskTextField.text ?? ""
        minCount = timeList[0][taskTimePickerView.selectedRow(inComponent: 0)]
        secCount = timeList[0][taskTimePickerView.selectedRow(inComponent: 1)]
        let time = "\(minCount)分\(secCount)秒"
        routineModel.updateTask(taskTitle: title, taskTime: time, routineID: selectedRoutineID, taskID: selectedTaskID)
        dismiss(animated: true)
        
    }
}

extension TaskDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    //コンポーネントの個数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return timeList.count
    }
    //コンポーネントのデータの個数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeList[component].count
    }
    //データの中身
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.left
        pickerLabel.text = String(timeList[component][row])
        return pickerLabel
    }
    //データ選択時
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        getTimeCount()
    }
    //サイズ
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return taskTimePickerView.bounds.width * 1/3
    }
    
    func createPickerLabels() {
        //「分」のラベルを追加
        var mStr = UILabel()
        mStr.text = "分"
        mStr.sizeToFit()
        mStr = UILabel(frame: CGRect(x: taskTimePickerView.bounds.width/3 - mStr.bounds.width/2,
                                     y: taskTimePickerView.bounds.height/2 - (mStr.bounds.height/2),
                                     width: mStr.bounds.width,
                                     height: mStr.bounds.height))
        taskTimePickerView.addSubview(mStr)
        //「秒」のラベルを追加
        var sStr = UILabel()
        sStr.text = "秒"
        sStr.sizeToFit()
        sStr = UILabel(frame: CGRect(x: taskTimePickerView.bounds.width*2/3 - sStr.bounds.width/2,
                                     y: taskTimePickerView.bounds.height/2 - (sStr.bounds.height/2),
                                     width: sStr.bounds.width,
                                     height: sStr.bounds.height))
        taskTimePickerView.addSubview(sStr)
    }
}
