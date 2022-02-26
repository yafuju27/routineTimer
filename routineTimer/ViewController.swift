//
//  ViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/02/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var taskCollectionView: UICollectionView!
    
    var viewWidth: CGFloat!
    var viewHeight: CGFloat!
    var cellWidth: CGFloat!
    var cellHeight: CGFloat!
    var cellOffset: CGFloat!
    var navHeight: CGFloat!
    
    var iconArray = ["sun","run","strech","study","night"]
    var titleArray = ["Morning Routine","HIT Training","Strech Routine","Pomodoro Technique","Night Routine"]
    var timeArray = ["45分30秒","20分00秒","15分00秒","12時間30分00秒","45分30秒"]
    
    
    
    //---------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        taskCollectionView.delegate = self
        taskCollectionView.dataSource = self
        //セルの登録
        let nib = UINib(nibName: "CollectionViewCell", bundle: .main)
        taskCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    //---------------------------------------------------------------------------------------
    
    
    
        //セルの個数
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return iconArray.count
        }
        //セルの中身
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
            cell.backgroundColor = UIColor.white
            cell.layer.cornerRadius = 12
            cell.layer.shadowOpacity = 0.2
            cell.layer.shadowRadius = 12
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 8, height: 8)
            cell.layer.masksToBounds = false
            
            cell.cellTitle.text = "\(titleArray[indexPath.row])"
            cell.cellTime.text = "\(timeArray[indexPath.row])"
            cell.cellImage.image = UIImage(named: iconArray[indexPath.row])
            return cell
        }
        //セル同士の間隔
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 20
        }
        //セルのサイズ
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            cellWidth = viewWidth - 30
            cellHeight = cellWidth / 3
            cellOffset = viewWidth - cellWidth
            return CGSize(width: cellWidth, height: cellHeight)
        }
        //余白の調整
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 20,left: cellOffset/2,bottom: 0,right: cellOffset/2)
        }
    
    
}

