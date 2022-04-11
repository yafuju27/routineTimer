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
    @IBOutlet weak var statusButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    @IBAction func statusButtonAction(_ sender: Any) {
    }
    
}
