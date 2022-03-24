//titleTextFieldのバグ
//キーボード閉じ(returnキー)
//タスクの合計時間反映
//セル並び替え&削除
//セルのタイトル変更
//セルの時間変更
//セルのbackgroundcolor選択

import UIKit
import RealmSwift

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    @IBOutlet weak var taskList: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    

    @IBOutlet weak var bellButton: UIButton!
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    
    var taskArray = ["トイレ","うがい","水分補給","体重測定","スクワット","ストレッチ","英単語","Todoリスト確認","トイレ","うがい","水分補給","体重測定","スクワット","ストレッチ","英単語","Todoリスト確認","トイレ","うがい","水分補給","体重測定","スクワット","ストレッチ","英単語","Todoリスト確認"]
    var taskTimeArray = ["5分30秒","2分00秒","1分00秒","3分00秒","4分30秒","2分20秒","0分30秒","1分20秒","5分30秒","2分00秒","1分00秒","3分00秒","4分30秒","2分20秒","0分30秒","1分20秒","5分30秒","2分00秒","1分00秒","3分00秒","4分30秒","2分20秒","0分30秒","1分20秒"]
    
    
    //var imageOfIcon = iconImageView.imageView
    var selectedImage: UIImage!
    
    //Realmを使う時のお決まりのやつ
    let realm = try! Realm()
    
    //---------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        taskList.delegate = self
        taskList.dataSource = self
        taskList.dropDelegate = self
        taskList.dragDelegate = self
        
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        let nib = UINib(nibName: "TaskCollectionViewCell", bundle: .main)
        taskList.register(nib, forCellWithReuseIdentifier: "taskCell")
        
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
    //---------------------------------------------------------------------------------------
    
    //キーボード閉じる処理
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.titleTextField.resignFirstResponder()
        return true
    }
    
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
    //    // Cell が選択された場合
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        // [indexPath.row] から画像名を探し、UImage を設定
    //        selectedImage = UIImage(named: iconArray[indexPath.row])
    //        if selectedImage != nil {
    //            // SubViewController へ遷移するために Segue を呼び出す
    //            performSegue(withIdentifier: "toSecondViewController",sender: nil)
    //        }
    
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
//                        // データソースの更新
//                        let n = dataList.remove(at: sourceIndexPath.item)
//                        dataList.insert(n, at: destinationIndexPath.item)
                        //セルの移動
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            }
    }
    

    //------------------------------------
    @IBAction func startButton(_ sender: Any) {
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    @IBAction func saveButton(_ sender: Any) {
        
        //ボタンを押したら、先ほど用意したデータの箱に、テキストフィールドに入力された値を書き込む処理を追記。
        let routine = Routine()
        routine.title = titleTextField.text!
//        routine.time = timeBox.text!
//        routine.number = numberBox.text!
        //routine.color = optionColor
        try! realm.write {
            realm.add(routine)
        }
        
        //ViewControllerへ戻る処理
        self.navigationController?.popViewController(animated: true)
//        //(タイトル、日付、本文)のセットである「日記」を配列の中に入れる
//        //date,body,date
//        print("セーブボタン押した")
//        contentsArray = saveGetModel.getData()
//        //「DateModel」で定義した設計図をインスタンスにする
//        let dateModel = DateModel()
//        //構造体の設計図をインスタンスとして定義する
//        //左の「contentsModel」はインスタンス、右の「ContentsModel」は設計図
//        //構造体はインスタンスにしなければ使用することができない
//        let routinesModel = RoutinesModel(title: titleTextField.text!,body:honbunTextView.text!, date: dateModel.getTodayDate())
//        print("🟥\(routinesModel)")
//        //インスタンス化された「ContentsModel()」を「contentsArray」に入れる
//        contentsArray.append(routinesModel)
//        //「saveGetModel」の「backProtocol」を自分に委任する
//        saveGetModel.backProtocol = self
//        //保存をする(モデルに渡す)
//        //「SveGetModel.swift」で作成したメソッド「saveData」を発動
//        //saveData()を発動したことにより、データを保存する
//        saveGetModel.saveData(contentsArray: contentsArray)
        
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }

    
    
    @IBAction func addTaskButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func bellButtonAction(_ sender: Any) {
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
}
