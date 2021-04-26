//
//  DetailImageCollectionViewCell.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/20.
//

import UIKit
import Kingfisher


class DetailImageCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var mainImageView: UIImageView!
    
    func updateUI(imagePath: String){
        let someting = imagePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = someting, let url1 = URL(string: url) else {
            return
        }
        self.mainImageView.kf.setImage(with: url1)
    }
}
