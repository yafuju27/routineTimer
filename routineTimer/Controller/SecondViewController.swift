//titleTextFieldのバグ
//キーボード閉じ
//タスクの合計時間反映
//セル並び替え&削除
//セルのタイトル変更
//セルの時間変更
//ボタンの振動


import Foundation
import UIKit

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var taskList: UICollectionView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var iconBack: UIView!
    @IBOutlet weak var colorBack: UIView!
    @IBOutlet weak var bellBack: UIView!
    
    @IBOutlet weak var iconButton: UIButton!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var bellButton: UIButton!
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    
    var taskArray = ["トイレ","うがい","水分補給","体重測定","スクワット","ストレッチ","英単語","Todoリスト確認"]
    var taskTimeArray = ["5分30秒","2分00秒","1分00秒","3分00秒","4分30秒","2分20秒","0分30秒","1分20秒"]
    
    
    //var imageOfIcon = iconImageView.imageView
    var selectedImage: UIImage!
    
    
    //---------------------------------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.cornerRadius = 12
        startButton.layer.shadowOpacity = 0.2
        startButton.layer.shadowRadius = 12
        startButton.layer.shadowColor = UIColor.black.cgColor
        startButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        saveButton.layer.cornerRadius = 12
        
        iconBack.layer.cornerRadius = 12
        colorBack.layer.cornerRadius = 12
        bellBack.layer.cornerRadius = 12
        
        colorButton.imageView?.tintColor = .red
        //テキストフィールドのカスタマイズ
        titleTextField.setUnderLine()
        titleTextField.text = "モーニングルーティーン"
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        taskList.delegate = self
        taskList.dataSource = self
        //iconImageView.image = selectedImage
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        iconButton.contentMode = UIView.ContentMode.scaleAspectFit
        let nib = UINib(nibName: "TaskCollectionViewCell", bundle: .main)
        taskList.register(nib, forCellWithReuseIdentifier: "taskCell")
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    //---------------------------------------------------------------------------------------
    
    
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
        return 5
    }
    //セルのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = viewWidth - 30
        cellHeight = 48
        cellOffset = viewWidth - cellWidth
        print(CGFloat(cellHeight))
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
    

    //------------------------------------
    @IBAction func startButton(_ sender: Any) {
        //画面遷移
    }
    @IBAction func saveButton(_ sender: Any) {
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
    }
    
    
    
    @IBAction func iconButton(_ sender: Any) {
    }
    @IBAction func colorButton(_ sender: Any) {
    }
    @IBAction func bellButton(_ sender: Any) {
    }
    
    
}
