import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let customeBlack = UIColor.rgb(r: 34, g: 40, b: 49)
    static let customeGray = UIColor.rgb(r: 57, g: 62, b: 70)
    static let customeBlue = UIColor.rgb(r: 0, g: 173, b: 181)
    static let customeOrange = UIColor.rgb(r: 234, g: 130, b: 54)
    static let clearColor = UIColor.clear
}

