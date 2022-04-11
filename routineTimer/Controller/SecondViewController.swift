import UIKit
import RealmSwift

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var taskTableView: UITableView!
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
    
    var selectedID = ""
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
        if selectedID == "" {
            let targetNew = realm.objects(Routine.self).filter("routineTitle == %@", "").first
            selectedID = targetNew?.routineID ?? ""
            unwrappedAllTimeInt = 0
            allTimeLabel.text = "合計0分0秒"
            routineModel.createTask(taskTitle: "新規タスク", taskTime: 0, routineID: selectedID)
            print("🟦ターゲットのID:\(targetNew?.routineID ?? "")")
        } else {
            let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
            titleTextField.text = target?.routineTitle
            unwrappedAllTimeInt = target?.totalTime ?? 0
            allTimeLabel.text = "合計\(Int(unwrappedAllTimeInt/60))分\(Int(unwrappedAllTimeInt%60))秒"
        }
        taskTableView.reloadData()
        print("🟦selectedID:\(selectedID)")
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
    }
    
    @IBAction func startButton(_ sender: Any) {
        Feedbacker.impact(style: .medium)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if titleTextField.text == "" {
            alert(title: "タイトルがありません",
                  message: "タイトルの欄に文字を入力してください")
        } else {
            let updateTitle = titleTextField.text ?? ""
            routineModel.updateRoutine(routineID: selectedID, routineTitle: updateTitle)
        }
        Feedbacker.impact(style: .medium)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addTaskButtonAction(_ sender: Any) {
        Feedbacker.impact(style: .medium)
        let taskVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskView") as! DetailViewController
        taskVC.modalPresentationStyle = .overCurrentContext
        taskVC.modalTransitionStyle = .crossDissolve
        self.present(taskVC, animated: true)
        routineModel.createTask(taskTitle: "新規タスク", taskTime: 0, routineID: selectedID)
        taskTableView.reloadData()
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
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
        startButton.backgroundColor = UIColor.rgb(r: 234, g: 84, b: 85)
        
        saveButton.layer.cornerRadius = 12
        saveButton.backgroundColor = .color3
        
        titleTextField.setCustomeLine()
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        //画面がタップされたらキーボード閉じるための処理準備
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
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

extension SecondViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
        return target?.task.count ?? 0
    }
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskTableViewCell
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
        cell.taskName.text = target?.task[indexPath.row].taskTitle
        if let unwrappedTime = target?.task[indexPath.row].taskTime {
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
        return cell
    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewWidth*0.13
    }
    //セルが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
        //画面遷移
        let taskVC = self.storyboard?.instantiateViewController(withIdentifier: "TaskView") as! DetailViewController
        taskVC.selectedRoutineID = selectedID
        taskVC.selectedTaskID = target?.task[indexPath.row].taskID ?? ""
        taskVC.modalPresentationStyle = .overCurrentContext
        taskVC.modalTransitionStyle = .crossDissolve
        self.present(taskVC, animated: true)
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
            try! realm.write {
                let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
                let item = target?.task[indexPath.row]
                realm.delete(item!)
            }
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
    }
    //deleteボタンのカスタマイズ
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = .systemGray6
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    //セルの並び替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        Feedbacker.impact(style: .medium)
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
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


