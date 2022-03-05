//
//  ViewController.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/02/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var routinesCollectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    
    var iconArray = ["sun","run","strech","study","night"]
    var titleArray = ["モーニングルーティーン","自重トレーニング","ストレッチ","ポモドーロ","寝る前のルーティーン"]
    var timeArray = ["45分30秒","20分00秒","15分00秒","12時間30分00秒","45分30秒"]
    
    var selectedImage : UIImage?
    
    
    
    //---------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        routinesCollectionView.delegate = self
        routinesCollectionView.dataSource = self
        //セルの登録
        let nib = UINib(nibName: "CollectionViewCell", bundle: .main)
        routinesCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toSecondViewController") {
            let secondVC: SecondViewController = (segue.destination as? SecondViewController)!
            
            // SubViewController のselectedImgに選択された画像を設定する
            secondVC.selectedImage = selectedImage
        }
    }
    //---------------------------------------------------------------------------------------
    
    
    
    //セルの個数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return iconArray.count
    }
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 12
        cell.layer.shadowOpacity = 0.1
        cell.layer.shadowRadius = 12
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.masksToBounds = false
        
        cell.cellTitle.text = "\(titleArray[indexPath.row])"
        cell.cellTime.text = "\(timeArray[indexPath.row])"
        cell.cellImage.image = UIImage(named: iconArray[indexPath.row])
        return cell
    }
    //セル同士の間隔
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    //セルのサイズ
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellWidth = viewWidth - 30
        cellHeight = cellWidth / 4.5
        cellOffset = viewWidth - cellWidth
        return CGSize(width: cellWidth, height: cellHeight)
    }
    //余白の調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20,left: cellOffset/2,bottom: 0,right: cellOffset/2)
    }
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // [indexPath.row] から画像名を探し、UImage を設定
        selectedImage = UIImage(named: iconArray[indexPath.row])
        if selectedImage != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "toSecondViewController",sender: nil)
        }
    }
    
    
    @IBAction func addButton(_ sender: Any) {
    }
    
    
    
}

