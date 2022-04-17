import UIKit
import RealmSwift

class DetailViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var taskTitleView: UIView!
    @IBOutlet weak var taskTextField: UITextField!
    @IBOutlet weak var taskTimeTextView: UITextView!
    @IBOutlet weak var taskTimePickerView: UIPickerView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var frontView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    
    private let routineModel = Routine()
    
    private var timer:Timer = Timer()
    private var alertController: UIAlertController!
    let timeList = [[Int](0...60), [Int](0...60)]
    
    var selectedRoutineID = ""
    var selectedTaskID = ""
    let realm = try! Realm()
    var targetTitle = ""
    var targetTime = 0
    var targetMin = 0
    var targetSec = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskTextField.delegate = self
        taskTimePickerView.dataSource = self
        taskTimePickerView.delegate = self
        
        setStatus()
        //createPickerLabels()
        createShape()
        forKeyBoard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(false, animated: animated)
        }
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.beginAppearanceTransition(true, animated: animated)
            presentingViewController?.endAppearanceTransition()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 13.0, *) {
            presentingViewController?.endAppearanceTransition()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func forKeyBoard() {
        //画面がタップされたらキーボード閉じるための処理準備
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
        //キーボードが上下する処理
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setStatus() {
        //ScondViewControllerの値を反映
        let targetTask = realm.object(ofType: Task.self, forPrimaryKey: selectedTaskID)
        targetTitle = targetTask?.taskTitle ?? ""
        targetTime = targetTask?.taskTime ?? 0
        targetMin = targetTime / 60
        targetSec = targetTime % 60
        taskTextField.text = "\(targetTitle)"
        taskTimePickerView.selectRow(targetMin, inComponent: 0, animated: true) // 初期値
        taskTimePickerView.selectRow(targetSec, inComponent: 1, animated: true) // 初期値
        taskTimeTextView.text = " \(targetMin) 分 \(targetSec) 秒"
    }
    
    private func createShape() {
        taskTitleView.layer.cornerRadius = 5.0
        taskTimeTextView.layer.masksToBounds = true
        taskTextField.layer.cornerRadius = 5.0
        taskTextField.layer.masksToBounds = true
        taskTimeTextView.layer.cornerRadius = 5.0
        taskTimeTextView.layer.masksToBounds = true
        
        frontView.layer.cornerRadius = 15
        frontView.layer.shadowOpacity = 0.2
        frontView.layer.shadowRadius = 12
        frontView.layer.shadowColor = UIColor.black.cgColor
        frontView.layer.shadowOffset = CGSize(width: 1, height: 1)
        doneButton.backgroundColor = UIColor(red: 0/255, green: 173/255, blue: 181/255, alpha: 1)
        doneButton.layer.cornerRadius = 8
        cancelButton.layer.cornerRadius = 8
        navigationItem.hidesBackButton = true
    }
    
    private func alert(title:String, message:String) {
        alertController = UIAlertController(title: title,
                                            message: message,
                                            preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: .default,
                                                handler: nil))
        present(alertController, animated: true)
    }
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func doneButtonAction(_ sender: Any) {
        print("🟦selectedRoutineID", selectedRoutineID)
        if taskTextField.text == "" {
            alert(title: "タスク名がありません",
                  message: "タスク名の欄に文字を入力してください")
        } else {
            let title = taskTextField.text ?? ""
            targetMin = timeList[0][taskTimePickerView.selectedRow(inComponent: 0)]
            targetSec = timeList[0][taskTimePickerView.selectedRow(inComponent: 1)]
            let time = targetMin*60 + targetSec
            
            if selectedTaskID == "" {
                routineModel.createTask(taskTitle: title, taskTime: time, routineID: selectedRoutineID)
            } else {
                routineModel.updateTask(taskTitle: title, taskTime: time, routineID: selectedRoutineID, taskID: selectedTaskID)
            }
            routineModel.calcTotalTime(routineID: selectedRoutineID, taskTime: time)
            dismiss(animated: true)
            print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
        }
    }
    //キーボード閉じる処理
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.taskTextField.resignFirstResponder()
        return true
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if !taskTextField.isFirstResponder {
            return
        }
        if self.view.frame.origin.y == 0 {
            if let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.frame.origin.y -= keyboardRect.height
            }
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        targetMin = timeList[0][taskTimePickerView.selectedRow(inComponent: 0)]
        targetSec = timeList[0][taskTimePickerView.selectedRow(inComponent: 1)]
        taskTimeTextView.text = " \(targetMin) 分 \(targetSec) 秒"
    }
    //サイズ
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return taskTimePickerView.bounds.width * 1/3
    }
    
    //    func createPickerLabels() {
    //        //「分」のラベルを追加
    //        var mStr = UILabel()
    //        mStr.text = "分"
    //        mStr.sizeToFit()
    //        mStr = UILabel(frame: CGRect(x: taskTimePickerView.bounds.width/3 - mStr.bounds.width/2,
    //                                     y: taskTimePickerView.bounds.height/2 - (mStr.bounds.height/2),
    //                                     width: mStr.bounds.width,
    //                                     height: mStr.bounds.height))
    //        taskTimePickerView.addSubview(mStr)
    //        //「秒」のラベルを追加
    //        var sStr = UILabel()
    //        sStr.text = "秒"
    //        sStr.sizeToFit()
    //        sStr = UILabel(frame: CGRect(x: taskTimePickerView.bounds.width*2/3 - sStr.bounds.width/2,
    //                                     y: taskTimePickerView.bounds.height/2 - (sStr.bounds.height/2),
    //                                     width: sStr.bounds.width,
    //                                     height: sStr.bounds.height))
    //        taskTimePickerView.addSubview(sStr)
    //    }
}
