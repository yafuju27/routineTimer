
//セルの並べ替え&削除

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var routinesCollectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    private var cellWidth: CGFloat!
    private var cellHeight: CGFloat!
    private var cellOffset: CGFloat!
    private var navHeight: CGFloat!
    private var selectedImage : UIImage?
    private var routineItems: Results<Routine>!
    private let routineModel = Routine()
    var selectedID = ""
    var routineID = ""
    let realm = try! Realm()
    private var unwrappedAllTimeInt = 0
    
    private let dateModel = DateModel()
    
    /// UICollectionViewが編集中かどうか
    var isEditMode = false {
        didSet {
            self.routinesCollectionView.reloadData()
        }
    }
    
    var layout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        // ...今回は省略
        return layout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        routinesCollectionView.reloadData()
        print ("🟥全てのデータ🟥\n\(realm.objects(Routine.self))")
    }
    
    @IBAction func addButton(_ sender: Any) {
        routineModel.createRoutine(routineTitle: "")
        //ボタンの振動
        Feedbacker.impact(style: .medium)
    }
    
    @IBAction func editButton(_ sender: Any) {
        self.isEditMode = !self.isEditMode
                let title = self.isEditMode ? "完了" : "編集"
        (sender as AnyObject).setTitle(title, for: .normal)
        
//        let searchBarButtonItem = UIBarButtonItem(image: UIImage(named: "ico_search")!, style: .plain, target: self, action: #selector(didTapSearch))
                //navigationItem.rightBarButtonItem = searchBarButtonItem
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
        
        routinesCollectionView.delegate = self
        routinesCollectionView.dataSource = self
        routinesCollectionView.dropDelegate = self
        routinesCollectionView.dragDelegate = self
        
        //セルの登録
        let nib = UINib(nibName: "CollectionViewCell", bundle: .main)
        routinesCollectionView.register(nib, forCellWithReuseIdentifier: "cell")
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        //カタカタ用
        let nibQ = UINib(nibName: "CustomCollectionViewCell", bundle: nil)
                self.routinesCollectionView.register(nibQ, forCellWithReuseIdentifier: "CollectionViewCell")
                self.routinesCollectionView.dataSource = self
                self.routinesCollectionView.collectionViewLayout = self.layout
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        cell.layer.cornerRadius = 15
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 6
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 1, height: 1)
        cell.layer.masksToBounds = false
        
        cell.cellTitle!.text = "\(routineItems[indexPath.row].routineTitle)"
        cell.cellTime!.text = "合計\(routineItems[indexPath.row].totalTime/60)分\(routineItems[indexPath.row].totalTime%60)秒"
        
        if self.isEditMode {
                    cell.startVibrateAnimation(range: 1.0)
                } else {
                    cell.stopVibrateAnimation()
                }
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
    
    // Cell が選択された場合
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //画面遷移
        let secondVC = self.storyboard?.instantiateViewController(withIdentifier: "Second") as! SecondViewController
        let routineItems = realm.objects(Routine.self)
        secondVC.selectedID = routineItems[indexPath.row].routineID
        self.navigationController?.pushViewController(secondVC, animated: true)
        //ボタンの振動
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

extension ViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
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
                //// データソースの更新
                //let n = dataList.remove(at: sourceIndexPath.item)
                //dataList.insert(n, at: destinationIndexPath.item)
                //セルの移動
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [destinationIndexPath])
            })
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
        }
    }
}
extension UIView {
    /**
     震えるアニメーションを再生します
     - parameters:
        - range: 震える振れ幅
        - speed: 震える速さ
        - isSync: 複数対象とする場合,同時にアニメーションするかどうか
     */
    func startVibrateAnimation(range: Double = 2.0, speed: Double = 0.15, isSync: Bool = false) {
        if self.layer.animation(forKey: "VibrateAnimationKey") != nil {
            return
        }
        let animation: CABasicAnimation
        animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.beginTime = isSync ? 0.0 : Double((Int(arc4random_uniform(UInt32(9))) + 1)) * 0.1
        animation.isRemovedOnCompletion = false
        animation.duration = speed
        animation.fromValue = range.toRadian
        animation.toValue = -range.toRadian
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        self.layer.add(animation, forKey: "VibrateAnimationKey")
    }
    /// 震えるアニメーションを停止します
    func stopVibrateAnimation() {
        self.layer.removeAnimation(forKey: "VibrateAnimationKey")
    }
}
 
extension Double {
    /// ラジアンに変換します
    var toRadian: Double {
        return .pi * self / 180
    }
}
