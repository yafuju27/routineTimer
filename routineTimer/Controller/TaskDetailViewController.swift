//
//  TaskDetailViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/03/24.
//

import UIKit
import RealmSwift

class TaskDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    
    
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTimeTextView: UITextView!
    @IBOutlet weak var taskTimePickerView: UIPickerView!
    
    private var timer:Timer = Timer()
    private var count:Int = 0
    let timeList = [[Int](0...60), [Int](0...60)]
    
    var selectedRoutineID = ""
    var selectedTaskID = ""
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedRoutineID).first
        let task = target?.task.filter("taskID == %@", selectedTaskID).first
        taskTextField.text = task?.taskTitle
        
        createPickerLabel()
    }
    
    func createPickerLabel() {
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
        
    }
    //サイズ
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return taskTimePickerView.bounds.width * 1/3
    }
    
    @IBAction func cancelBarButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func doneBarButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
}
