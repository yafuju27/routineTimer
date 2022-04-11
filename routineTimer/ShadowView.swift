//
//  ShadowView.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/04/10.
//

import UIKit

class ShadowView: UIView {
    private var viewWidth: CGFloat!
    private var viewHeight: CGFloat!
    
    override var bounds: CGRect {
        didSet {
            viewWidth = UIScreen.main.bounds.size.width
            setupShadow()
            self.backgroundColor = UIColor(red: 0/255, green: 173/255, blue: 181/255, alpha: 1)
        }
    }
    private func setupShadow() {
        self.layer.cornerRadius = 0.05*viewWidth
        self.layer.shadowOffset = CGSize(width: 1, height: 5)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.2
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}
