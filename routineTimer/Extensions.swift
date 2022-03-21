//
//  Extensions.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/02/28.
//
import UIKit

extension UIColor {
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
//黒と青
        static let color1 = UIColor.rgb(r: 34, g: 40, b: 49)
        static let color2 = UIColor.rgb(r: 57, g: 62, b: 70)
        static let color3 = UIColor.rgb(r: 0, g: 173, b: 181)
        static let color4 = UIColor.rgb(r: 238, g: 238, b: 238)
//ドイツ
//        static let color1 = UIColor.rgb(r: 45, g: 64, b: 89)
//        static let color2 = UIColor.rgb(r: 234, g: 84, b: 85)
//        static let color3 = UIColor.rgb(r: 240, g: 123, b: 63)
//        static let color4 = UIColor.rgb(r: 255, g: 212, b: 96)
//白黒中心
//        static let color1 = UIColor.rgb(r: 240, g: 245, b: 249)
//        static let color2 = UIColor.rgb(r: 201, g: 214, b: 223)
//        static let color3 = UIColor.rgb(r: 82, g: 97, b: 107)
//        static let color4 = UIColor.rgb(r: 30, g: 32, b: 34)
    //ベージュと青
//        static let color1 = UIColor.rgb(r: 251, g: 248, b: 241)
//        static let color2 = UIColor.rgb(r: 247, g: 236, b: 222)
//        static let color3 = UIColor.rgb(r: 233, g: 218, b: 193)
//        static let color4 = UIColor.rgb(r: 84, g: 186, b: 185)
    //ベージュと緑
//        static let color1 = UIColor.rgb(r: 229, g: 227, b: 201)
//        static let color2 = UIColor.rgb(r: 180, g: 207, b: 176)
//        static let color3 = UIColor.rgb(r: 148, g: 180, b: 159)
//        static let color4 = UIColor.rgb(r: 120, g: 147, b: 149)
    //ピンクと黒
//        static let color1 = UIColor.rgb(r: 255, g: 200, b: 200)
//        static let color2 = UIColor.rgb(r: 255, g: 153, b: 153)
//        static let color3 = UIColor.rgb(r: 68, g: 79, b: 90)
//        static let color4 = UIColor.rgb(r: 62, g: 65, b: 73)
    //赤と紺
//        static let color1 = UIColor.rgb(r: 246, g: 114, b: 128)
//        static let color2 = UIColor.rgb(r: 192, g: 108, b: 132)
//        static let color3 = UIColor.rgb(r: 108, g: 91, b: 123)
//        static let color4 = UIColor.rgb(r: 53, g: 92, b: 125)
    //茶色中心
//        static let color1 = UIColor.rgb(r: 28, g: 10, b: 0)
//        static let color2 = UIColor.rgb(r: 54, g: 21, b: 0)
//        static let color3 = UIColor.rgb(r: 96, g: 54, b: 1)
//        static let color4 = UIColor.rgb(r: 204, g: 149, b: 68)
    //ベージュ、ティール、ピーチ
//        static let color1 = UIColor.rgb(r: 252, g: 248, b: 232)
//        static let color2 = UIColor.rgb(r: 212, g: 226, b: 212)
//        static let color3 = UIColor.rgb(r: 236, g: 179, b: 144)
//        static let color4 = UIColor.rgb(r: 223, g: 120, b: 97)
    //黄色、オレンジ、紫
//        static let color1 = UIColor.rgb(r: 249, g: 237, b: 105)
//        static let color2 = UIColor.rgb(r: 240, g: 138, b: 93)
//        static let color3 = UIColor.rgb(r: 184, g: 59, b: 94)
//        static let color4 = UIColor.rgb(r: 106, g: 44, b: 112)
    
    static let clearColor = UIColor.clear
}


extension UITextField {
    func setCustomeLine() {
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる❓
        underline.frame = CGRect(x: 0, y: frame.height - 4, width: frame.width, height: 3)
        // 枠線の色
        underline.backgroundColor = .darkGray
        underline.layer.cornerRadius = 2
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}



//let red = [#colorLiteral(red: 0.9654200673, green: 0.1590853035, blue: 0.2688751221, alpha: 1),#colorLiteral(red: 0.7559037805, green: 0.1139892414, blue: 0.1577021778, alpha: 1)]
//        let orangeRed = [#colorLiteral(red: 0.9338900447, green: 0.4315618277, blue: 0.2564975619, alpha: 1),#colorLiteral(red: 0.8518816233, green: 0.1738803983, blue: 0.01849062555, alpha: 1)]
//        let orange = [#colorLiteral(red: 0.9953531623, green: 0.54947716, blue: 0.1281470656, alpha: 1),#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1)]
//        let yellow = [#colorLiteral(red: 0.9409626126, green: 0.7209432721, blue: 0.1315650344, alpha: 1),#colorLiteral(red: 0.8931249976, green: 0.5340107679, blue: 0.08877573162, alpha: 1)]
//        let green = [#colorLiteral(red: 0.3796315193, green: 0.7958304286, blue: 0.2592983842, alpha: 1),#colorLiteral(red: 0.2060100436, green: 0.6006633639, blue: 0.09944178909, alpha: 1)]
//        let greenBlue = [#colorLiteral(red: 0.2761503458, green: 0.824685812, blue: 0.7065336704, alpha: 1),#colorLiteral(red: 0, green: 0.6422213912, blue: 0.568986237, alpha: 1)]
//        let kindaBlue = [#colorLiteral(red: 0.2494148612, green: 0.8105323911, blue: 0.8425348401, alpha: 1),#colorLiteral(red: 0, green: 0.6073564887, blue: 0.7661359906, alpha: 1)]
//        let skyBlue = [#colorLiteral(red: 0.3045541644, green: 0.6749247313, blue: 0.9517192245, alpha: 1),#colorLiteral(red: 0.008423916064, green: 0.4699558616, blue: 0.882807076, alpha: 1)]
//        let blue = [#colorLiteral(red: 0.1774400771, green: 0.466574192, blue: 0.8732826114, alpha: 1),#colorLiteral(red: 0.00491155684, green: 0.287129879, blue: 0.7411141396, alpha: 1)]
//        let bluePurple = [#colorLiteral(red: 0.4613699913, green: 0.3118675947, blue: 0.8906354308, alpha: 1),#colorLiteral(red: 0.3018293083, green: 0.1458326578, blue: 0.7334778905, alpha: 1)]
//        let purple = [#colorLiteral(red: 0.7080290914, green: 0.3073516488, blue: 0.8653779626, alpha: 1),#colorLiteral(red: 0.5031493902, green: 0.1100070402, blue: 0.6790940762, alpha: 1)]
//        let pink = [#colorLiteral(red: 0.9495453238, green: 0.4185881019, blue: 0.6859942079, alpha: 1),#colorLiteral(red: 0.8123683333, green: 0.1657164991, blue: 0.5003474355, alpha: 1)]
