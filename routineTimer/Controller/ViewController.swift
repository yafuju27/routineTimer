//3/7

//セルの並べ替え&削除
//セル新規追加
//ボタンの振動

import UIKit
import RealmSwift

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    
    var routineItems: Results<Routine>!
    //Realmを使う時のお決まりのやつ
    let realm = try! Realm()
    
    @IBOutlet weak var routinesCollectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    
    var iconArray = ["sun","run","strech","study","night"]
    //var titleArray = ["モーニングルーティーン","自重トレーニング","ストレッチ","ポモドーロ","寝る前のルーティーン"]
    var timeArray = ["45分30秒","20分00秒","15分00秒","12時間30分00秒","45分30秒"]
    
    var selectedImage : UIImage?
    
    //まだ時計が更新されない状態
    var myTimer: Timer!
    var dateModel = DateModel()
    
    
    
    
    //---------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayDateLabel.text = dateModel.getTodayDate()
        
        addButton.tintColor = .darkGray
        addButton.layer.shadowOpacity = 0.2
        addButton.layer.shadowRadius = 8
        addButton.layer.shadowColor = UIColor.black.cgColor
        addButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        
        viewWidth = view.frame.width
        viewHeight = view.frame.height
        navHeight = self.navigationController?.navigationBar.frame.size.height
        
        routinesCollectionView.delegate = self
        routinesCollectionView.dataSource = self
        routinesCollectionView.dropDelegate = self
        routinesCollectionView.dragDelegate = self
        routinesCollectionView.dragInteractionEnabled
        
        //セルの登録
        let nib = UINib(nibName: "CollectionViewCell", bundle: .main)
        routinesCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        //self.navigationController?.navigationBar.tintColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        routineItems = realm.objects(Routine.self)
        
        routinesCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        routinesCollectionView.reloadData()
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
        //データがあるだけセルを作るようにします。
        let routineItems = realm.objects(Routine.self)
        return routineItems.count
    }
    //セルの中身
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let routineItems = realm.objects(Routine.self)
        cell.backgroundColor = .color3
        cell.layer.cornerRadius = 12
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 6
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.masksToBounds = false
        
        cell.cellTitle!.text = "\(routineItems[indexPath.row].title)"
//        cell.cellTime!.text = "\(routineItems[indexPath.row].time)"
//        cell.cellImage!.text = "\(routineItems[indexPath.row].number)"
        
        //cell.colorView!.backgroundColor = routineItems[indexPath.row].color
        
//        cell.cellTitle.text = "\(titleArray[indexPath.row])"
        cell.cellTime.text = "\(timeArray[indexPath.row])"
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
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 20,left: cellOffset/2,bottom: 0,right: cellOffset/2)
//    }
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // [indexPath.row] から画像名を探し、UImage を設定
        selectedImage = UIImage(named: iconArray[indexPath.row])
        if selectedImage != nil {
            // SubViewController へ遷移するために Segue を呼び出す
            performSegue(withIdentifier: "toSecondViewController",sender: nil)
        }
    }
    
    
    func deleteRoutine(at index: Int) {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(routineItems[index])
        }
    }
    
    //---------------------------------------------------------
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
    
    //---------------------------------------------------------
    
    @IBAction func addButton(_ sender: Any) {
    }
    
    
    
}

