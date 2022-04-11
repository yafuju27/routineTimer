import UIKit

class RoutineTableViewCell: UITableViewCell {
    override class func description() -> String {
            return "TableAnimationViewCell"
        }
    
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellTime: UILabel!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var shadowLayer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        NSLayoutConstraint.activate([
                    contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    contentView.topAnchor.constraint(equalTo: topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}

