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
    func setUnderLine() {
        // 枠線を非表示にする
        borderStyle = .none
        let underline = UIView()
        // heightにはアンダーラインの高さを入れる
        underline.frame = CGRect(x: 0, y: frame.height - 4, width: frame.width, height: 3)
        // 枠線の色
        underline.backgroundColor = .darkGray
        underline.layer.cornerRadius = 2
        addSubview(underline)
        // 枠線を最前面に
        bringSubviewToFront(underline)
    }
}
