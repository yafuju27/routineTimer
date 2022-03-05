//
//  SubViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/02/26.
//

import Foundation
import UIKit

class SecondViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var taskList: UICollectionView!
    @IBOutlet weak var iconImageView: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var iconBack: UIImageView!
    @IBOutlet weak var colorBack: UIImageView!
    @IBOutlet weak var bellBack: UIImageView!
    
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
        
        iconBack.layer.cornerRadius = 12
        colorBack.layer.cornerRadius = 12
        bellBack.layer.cornerRadius = 12
        //テキストフィールドのカスタマイズ
        titleTextField.setUnderLine()
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        taskList.delegate = self
        taskList.dataSource = self
        //iconImageView.image = selectedImage
        // 画像のアスペクト比を維持しUIImageViewサイズに収まるように表示
        iconImageView.contentMode = UIView.ContentMode.scaleAspectFit
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
        cellHeight = cellWidth / 8
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
    

    
    @IBAction func startButton(_ sender: Any) {
        //画面遷移
    }
    @IBAction func iconButton(_ sender: Any) {
    }
    
}
