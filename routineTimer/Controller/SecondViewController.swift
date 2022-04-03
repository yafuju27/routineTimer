//titleTextFieldのバグ
//キーボード閉じ(returnキー)
//タスクの合計時間反映
//セル並び替え&削除
//セルのタイトル変更
//セルの時間変更
//セルのbackgroundcolor選択

import UIKit
import RealmSwift

class SecondViewController: UIViewController {
    @IBOutlet weak var taskCollectionView: UICollectionView!
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
    
    var selectedID = ""
    var routineID = ""
    var unwrappedAllTimeInt = 0
    let realm = try! Realm()
    
    var allTimeCount:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
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
        taskCollectionView.reloadData()
        print("🟦selectedID:\(selectedID)")
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
    }
    
    @IBAction func startButton(_ sender: Any) {
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        if titleTextField.text == "" {
            alert(title: "タイトルがありません",
                          message: "タイトルの欄に文字を入力してください")
        } else {
            guard let routineTitle = titleTextField.text else {
                // TDOO: - ここにアラートを入れる
                return
            }
            //新しいRoutineの登録
            if selectedID == "" {
                routineModel.createRoutine(routineTitle: routineTitle)
            } else {
                routineModel.updateRoutine(routineID: selectedID, routineTitle: routineTitle)
            }
            //ViewControllerへ戻る処理
            self.navigationController?.popViewController(animated: true)
            //ボタンの振動
            Feedbacker.impact(style: .medium)
        }
    }
    
    @IBAction func addTaskButtonAction(_ sender: Any) {
        routineModel.createTask(taskTitle: "新規タスク", taskTime: 0, routineID: selectedID)
        taskCollectionView.reloadData()
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
        
        //テキストフィールドのカスタマイズ
        titleTextField.setCustomeLine()
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        taskCollectionView.dropDelegate = self
        taskCollectionView.dragDelegate = self
        
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        let nib = UINib(nibName: "TaskCollectionViewCell", bundle: .main)
        taskCollectionView.register(nib, forCellWithReuseIdentifier: "taskCell")
        
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
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //セルの個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
        return target?.task.count ?? 0
    }
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
        let taskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as! TaskCollectionViewCell
        taskCell.layer.cornerRadius = viewWidth / 18
        taskCell.backgroundColor = UIColor.white
        taskCell.layer.masksToBounds = false
        taskCell.taskName.text = target?.task[indexPath.row].taskTitle
        if let unwrappedTime = target?.task[indexPath.row].taskTime {
            taskCell.taskTime.text = "\(Int(unwrappedTime/60))分\(Int(unwrappedTime%60))秒"
        } else {
            print("taskTimeはnil")
        }
        
        if taskCell.taskName.text == "新規タスク" {
            taskCell.taskName.textColor = .systemGray2
            taskCell.taskTime.textColor = .systemGray2
        } else {
            taskCell.taskName.textColor = .black
            taskCell.taskTime.textColor = .black
        }
        return taskCell
    }
    //セル同士の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    //セルのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = viewWidth - 30
        cellHeight = 45
        cellOffset = viewWidth - cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let target = realm.objects(Routine.self).filter("routineID == %@", selectedID).first
        let storyboard = UIStoryboard(name: "TaskDetail", bundle: nil)
        let taskDetailVC = storyboard.instantiateViewController(withIdentifier: "TaskDetail") as! TaskDetailViewController
        taskDetailVC.selectedRoutineID = selectedID
        taskDetailVC.selectedTaskID = target?.task[indexPath.row].taskID ?? ""
        taskDetailVC.modalPresentationStyle = .fullScreen
        self.present(taskDetailVC, animated: true)
    }
}

extension SecondViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    //セルのドラッグ
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let itemIdentifier = indexPath.item.description
        let itemProvider = NSItemProvider(object: itemIdentifier as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
    //謎
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
    }
    //セルのドロップ
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        if coordinator.proposal.operation == .move {
            guard let item = coordinator.items.first,
                  let destinationIndexPath = coordinator.destinationIndexPath,
                  let sourceIndexPath = item.sourceIndexPath else {
                return
            }
            
            collectionView.performBatchUpdates({
                // データソースの更新
                // let n = dataList.remove(at: sourceIndexPath.item)
                // dataList.insert(n, at: destinationIndexPath.item)
                //セルの移動
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
    func swipeCellDelete(){
        
    }
}
