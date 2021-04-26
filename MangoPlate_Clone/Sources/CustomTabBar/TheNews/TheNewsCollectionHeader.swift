//
//  TheNewsCollectionHeader.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

import UIKit

class TheNewsCollectionHeader: UICollectionReusableView {
        
    @IBOutlet weak var greatButton: UIButton!
    @IBOutlet weak var sosoButton: UIButton!
    @IBOutlet weak var badButton: UIButton!
    
    @IBAction func gradeButtonTab(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 0 {
            sosoButton.isSelected = false
            badButton.isSelected = false
        }
        else if sender.tag == 1{
            greatButton.isSelected = false
            badButton.isSelected = false
        }
        else {
            greatButton.isSelected = false
            sosoButton.isSelected = false
        }
    }
}
