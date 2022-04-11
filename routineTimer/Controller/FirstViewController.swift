
//セルの並べ替え&削除

import UIKit
import RealmSwift

class FirstViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var routinesTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    
    let realm = try! Realm()
    private var routineItems: Results<Routine>!
    private var list: List<Routine>!
    
    private let routineModel = Routine()
    private let dateModel = DateModel()
    
    private var unwrappedAllTimeInt = 0
    var selectedID = ""
    var routineID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        list = realm.objects(RoutineList.self).first?.list
        
        routinesTableView.delegate = self
        routinesTableView.dataSource = self
        routinesTableView.dragDelegate = self
        routinesTableView.dropDelegate = self
        routinesTableView.dragInteractionEnabled = true
        
        routinesTableView.register(UINib(nibName: "RoutineTableViewCell", bundle: nil), forCellReuseIdentifier: "routineCell")
        routinesTableView.separatorStyle = .none
        routinesTableView.showsVerticalScrollIndicator = false
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        routinesTableView.reloadData()
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
    }
    
    @IBAction func addButton(_ sender: Any) {
        Feedbacker.impact(style: .medium)
        var alertTextField: UITextField?
        let alert = UIAlertController(title: "新しいルーティーン",
                                      message: "ルーティーンのタイトルを\n入力してください",
                                      preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "キャンセル",
                                         style: .default) { (action: UIAlertAction!) -> Void in
        }
        let saveAction = UIAlertAction(title: "保存",
                                       style: .default) { (action: UIAlertAction!) -> Void in
            let newTitle: String = alertTextField?.text ?? ""
            self.routineModel.createRoutine(routineTitle: "\(newTitle)")
            self.routinesTableView.reloadData()
            print("🟥全てのデータ🟥\n\(self.realm.objects(Routine.self))")
            
        }
        saveAction.isEnabled = false
        alert.addTextField { (textField) in
            alertTextField = textField
            
            textField.placeholder = "例：朝の準備"
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using:
                                                    {_ in
                let textCount = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines).count ?? 0
                let textIsNotEmpty = textCount > 0
                saveAction.isEnabled = textIsNotEmpty
            })
            
            alert.addAction(cancelAction)
            alert.addAction(saveAction)
            self.present(alert,
                         animated: true,
                         completion: nil)
        }
    }
    
    private func setupView() {
        
        todayDateLabel.text = dateModel.getTodayDate()
        
        addButton.tintColor = .darkGray
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowRadius = 8
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
    }
}

extension FirstViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let routineItems = self.realm.objects(Routine.self)
        return routineItems.count
    }
    //セルの中身
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "routineCell", for: indexPath) as! RoutineTableViewCell
        let routineItems = self.realm.objects(Routine.self)
        cell.cellTitle!.text = "\(routineItems[indexPath.row].routineTitle)"
        cell.cellTime!.text = "合計\(routineItems[indexPath.row].totalTime/60)分\(routineItems[indexPath.row].totalTime%60)秒"
        cell.mainBackground.layer.cornerRadius = 0.055*viewWidth
        cell.mainBackground.layer.masksToBounds = true
        return cell
    }
    //セルの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    //セルが選択された時
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //画面遷移
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Second") as! SecondViewController
        let routineItems = realm.objects(Routine.self)
        secondVC.selectedID = routineItems[indexPath.row].routineID
        self.navigationController?.pushViewController(secondVC, animated: true)
        
        Feedbacker.impact(style: .medium)
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
                let routineItems = self.realm.objects(Routine.self)
                let item = routineItems[indexPath.row]
                realm.delete(item)
            }
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    //deleteボタンのカスタマイズ
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
            Feedbacker.impact(style: .medium)
            try! self.realm.write {
                let routineItems = self.realm.objects(Routine.self)
                let item = routineItems[indexPath.row]
                self.realm.delete(item)
            }
            tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
        }
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = .white
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
    //セルの並び替え
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        Feedbacker.impact(style: .medium)
        //        try! realm.write {
        //            let routineItems = self.realm.objects(Routine.self)
        //            let listItem = routineItems[sourceIndexPath.row]
        //            routineItems.remove(at: sourceIndexPath.row)
        //            routineItems.insert(listItem, at: destinationIndexPath.row)
        //        }
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
