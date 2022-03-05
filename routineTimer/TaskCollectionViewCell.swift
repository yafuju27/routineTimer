//
//  TaskCollectionViewCell.swift
//  routineTimer
//
//  Created by Yazici Yahya on 2022/02/27.
//

import UIKit

class TaskCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskTime: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        NSLayoutConstraint.activate([
                    contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                    contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                    contentView.topAnchor.constraint(equalTo: topAnchor),
                    contentView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }

}
