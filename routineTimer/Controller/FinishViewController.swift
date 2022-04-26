import UIKit

class FinishViewController: UIViewController {
    
    @IBOutlet weak var returnButton: UIButton!
    @IBOutlet weak var frontView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontView.layer.cornerRadius = 15
        frontView.layer.shadowOpacity = 0.2
        frontView.layer.shadowRadius = 12
        frontView.layer.shadowColor = UIColor.black.cgColor
        frontView.layer.shadowOffset = CGSize(width: 1, height: 1)
        returnButton.backgroundColor = .customeOrange
        returnButton.layer.cornerRadius = 8
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func returnButton(_ sender: Any) {
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
