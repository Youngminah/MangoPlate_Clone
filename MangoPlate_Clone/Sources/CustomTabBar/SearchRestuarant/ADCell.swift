//
//  ADCell.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/18.
//

import UIKit

class AdCell: UICollectionViewCell{
    
    @IBOutlet weak var adImageView: UIImageView!
    
    var image: UIImage! {
        didSet {
            adImageView.image = image
        }
    }
}
