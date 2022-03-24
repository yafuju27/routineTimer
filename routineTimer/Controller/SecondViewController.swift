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
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    
    var taskArray = ["トイレ"]
    var taskTimeArray = ["5分30秒"]
    var selectedImage: UIImage!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @IBAction func startButton(_ sender: Any) {
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        //ボタンを押したら、先ほど用意したデータの箱に、テキストフィールドに入力された値を書き込む処理を追記。
        let routine = Routine()
        routine.title = titleTextField.text!
        try! realm.write {
            realm.add(routine)
        }
        //ViewControllerへ戻る処理
        self.navigationController?.popViewController(animated: true)
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    @IBAction func addTaskButtonAction(_ sender: Any) {
        taskArray.append("歯磨き")
        taskTimeArray.append("1分30秒")
        taskCollectionView.reloadData()
    }
    
    @IBAction func bellButtonAction(_ sender: Any) {
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    //キーボード閉じる処理
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    private func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleTextField.resignFirstResponder()
        return true
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
        
        let routineItems = realm.objects(Routine.self)
        print("🟥全てのデータ\(routineItems)")
    }
    
}

extension SecondViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //セルの個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskArray.count
    }
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let taskCell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCell", for: indexPath) as! TaskCollectionViewCell
        taskCell.layer.cornerRadius = 24
        taskCell.backgroundColor = UIColor.white
        taskCell.layer.masksToBounds = false
        taskCell.taskName.text = "\(taskArray[indexPath.row])"
        taskCell.taskTime.text = "\(taskTimeArray[indexPath.row])"
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
        let storyboard = UIStoryboard(name: "TaskDetail", bundle: nil)
        let taskDetailVC = storyboard.instantiateViewController(withIdentifier: "TaskDetail") as! TaskDetailViewController
        taskDetailVC.taskTitle = taskArray[indexPath.row]
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
}
