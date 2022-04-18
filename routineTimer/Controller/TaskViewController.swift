import UIKit
import RealmSwift

class TaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var titleBackView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var allTimeLabel: UILabel!
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    private var alertController: UIAlertController!
    private let routineModel = Routine()
    
    let timeList = [[Int](0...60), [Int](0...60)]
    let screenWidth = UIScreen.main.bounds.width - 20
    let screenHeight = UIScreen.main.bounds.height / 2
    var selectedRow = 0
    
    var routineID = ""
    var unwrappedAllTimeInt = 0
    var allTimeCount = 0
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        taskTableView.dragDelegate = self
        taskTableView.dropDelegate = self
        taskTableView.dragInteractionEnabled = true
        
        taskTableView.register(UINib(nibName: "TaskTableViewCell", bundle: nil), forCellReuseIdentifier: "taskCell")
        taskTableView.separatorStyle = .none
        taskTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let targetRoutine = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        titleTextField.text = targetRoutine?.routineTitle
        updateTotalTimeLabel()
        taskTableView.reloadData()
        print("🟦遷移後のselectedID:\(routineID)")
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //キーボード閉じる処理
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleTextField.resignFirstResponder()
        return true
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
    
    private func setupView() {
        startButton.layer.cornerRadius = 12
        startButton.layer.shadowOpacity = 0.2
        startButton.layer.shadowRadius = 12
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        startButton.backgroundColor = UIColor.rgb(r: 234, g: 130, b: 54)
        
        saveButton.layer.cornerRadius = 12
        saveButton.backgroundColor = .color3
        
        titleBackView.layer.cornerRadius = 15
        
        titleTextField.setCustomeLine()
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        titleBackView.layer.borderWidth = 3.0
        titleBackView.layer.borderColor = UIColor.darkGray.cgColor
        
        
        //画面がタップされたらキーボード閉じるための処理準備
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    private func updateTotalTimeLabel() {
        let targetRoutine = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        unwrappedAllTimeInt = targetRoutine?.totalTime ?? 0
        allTimeLabel.text = "合計\(Int(unwrappedAllTimeInt/60))分\(Int(unwrappedAllTimeInt%60))秒"
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if titleTextField.text == "" {
            alert(title: "タイトルがありません",
                  message: "タイトルの欄に文字を入力してください")
        } else {
            let updateTitle = titleTextField.text ?? ""
            routineModel.updateRoutine(routineID: routineID, routineTitle: updateTitle)
        }
        Feedbacker.impact(style: .medium)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTaskButtonAction(_ sender: Any) {
        Feedbacker.impact(style: .medium)
        let taskVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        taskVC.modalPresentationStyle = .overCurrentContext
        taskVC.modalTransitionStyle = .crossDissolve
        self.present(taskVC, animated: true)
        
        taskVC.selectedRoutineID = routineID
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
    }
    
    @IBAction func startButton(_ sender: Any) {
        Feedbacker.impact(style: .medium)
        let timerVC = self.storyboard?.instantiateViewController(withIdentifier: "TimerView") as! TimerViewController
        timerVC.titleArray = ["トイレに行く","ヘアセット","マウスウォッシュ","歯磨き","着替え","洗濯"]
        timerVC.timeArray = [80, 60, 40, 90, 20, 120]
        self.navigationController?.pushViewController(timerVC, animated: true)
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
        let pickerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        pickerLabel.textAlignment = NSTextAlignment.left
        pickerLabel.text = String(timeList[component][row])
        pickerLabel.sizeToFit()
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let targetRoutine = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        return targetRoutine?.task.count ?? 0
    }
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        let targetRoutine = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        let targetTask = targetRoutine?.task.sorted(byKeyPath: "taskOrder", ascending: true)
        cell.taskName.text = targetTask?[indexPath.row].taskTitle
        if let unwrappedTime = targetTask?[indexPath.row].taskTime {
            cell.taskTime.text = "\(Int(unwrappedTime/60))分\(Int(unwrappedTime%60))秒"
        } else {
            print("taskTimeはnil")
        }
        
        if cell.taskName.text == "新規タスク" {
            cell.taskName.textColor = .systemGray2
            cell.taskTime.textColor = .systemGray2
        } else {
            cell.taskName.textColor = .black
            cell.taskTime.textColor = .black
        }
        
        cell.backView.layer.cornerRadius = viewWidth / 18
        cell.backgroundColor = .clear
        cell.layer.masksToBounds = false
        //チェーンデザイン
        if indexPath.row == 0 && targetTask?.count != 1 {
            cell.chain1.isHidden = true
        } else if indexPath.row == Int(targetTask?.count ?? 0) - 1 {
            cell.chain2.isHidden = true
        } else if indexPath.row == 0 && targetTask?.count != 1 {
            cell.chain1.isHidden = true
            cell.chain2.isHidden = true
        }
        return cell
    }
    
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewWidth*0.12
    }
    //セルが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "DetailView") as! DetailViewController
        let targetRoutine = realm.object(ofType: Routine.self, forPrimaryKey: routineID)
        detailVC.selectedRoutineID = routineID
        detailVC.selectedTaskID = targetRoutine?.task[indexPath.row].taskID ?? ""
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.modalTransitionStyle = .crossDissolve
        self.present(detailVC, animated: true)
    }
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    //スワイプしたセルを削除
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Feedbacker.impact(style: .medium)
            try! self.realm.write {
                let taskItems = self.realm.object(ofType: Routine.self, forPrimaryKey: self.routineID)?.task.sorted(byKeyPath: "taskOrder", ascending: true)
                let item = taskItems?[indexPath.row]
                let nextOrder:Int = (item?.taskOrder ?? 0) + 1
                let lastOrder:Int = (taskItems?.count ?? 0) - 1
                if (lastOrder == 0) || (nextOrder == taskItems?.count) {
                    } else {
                        for index in nextOrder...lastOrder {
                            let object = taskItems?[index]
                            object?.taskOrder -= 1
                    }
                }
                self.realm.delete(item!)
            }
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            updateTotalTimeLabel()
            tableView.reloadData()
            print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
        }
        
    }
    //deleteボタンのカスタマイズ
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            Feedbacker.impact(style: .medium)
            try! self.realm.write {
                let taskItems = self.realm.object(ofType: Routine.self, forPrimaryKey: self.routineID)?.task.sorted(byKeyPath: "taskOrder", ascending: true)
                let item = taskItems?[indexPath.row]
                let nextOrder:Int = (item?.taskOrder ?? 0) + 1
                let lastOrder:Int = (taskItems?.count ?? 0) - 1
                if (lastOrder == 0) || (nextOrder == taskItems?.count) {
                    } else {
                        for index in nextOrder...lastOrder {
                            let object = taskItems?[index]
                            object?.taskOrder -= 1
                    }
                }
                self.realm.delete(item!)
            }
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
            self.updateTotalTimeLabel()
            tableView.reloadData()
            print ("🟥全てのデータ🟥\n\(self.realm.objects(Routine.self))")
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = .systemGray6
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    //セルの並び替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        try! realm.write {
            let taskItems = self.realm.object(ofType: Routine.self, forPrimaryKey: self.routineID)?.task.sorted(byKeyPath: "taskOrder", ascending: true)
            let sourceObject = taskItems?[sourceIndexPath.row]
            let destinationObject = taskItems?[destinationIndexPath.row]
            
            let destinationObjectOrder = destinationObject?.taskOrder
            
            if sourceIndexPath.row < destinationIndexPath.row {
                // 上から下に移動した場合、間の項目を上にシフト
                for index in sourceIndexPath.row...destinationIndexPath.row {
                    let object = taskItems?[index]
                    object?.taskOrder -= 1
                }
            } else {
                // 下から上に移動した場合、間の項目を下にシフト
                for index in (destinationIndexPath.row..<sourceIndexPath.row).reversed() {
                    let object = taskItems?[index]
                    object?.taskOrder += 1
                }
            }
            // 移動したセルの並びを移動先に更新
            sourceObject?.taskOrder = destinationObjectOrder ?? 0
            tableView.reloadData()
            print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
        }
    }
    //ドラッグ
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    //ドロップ
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}


