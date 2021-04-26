//
//  allReviewsImageCell.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/24.
//

import UIKit
import Kingfisher

class allReviewsImageCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    func updateUI(urlString: String?){
        guard let urlString = urlString else {
            image.isHidden = true
            return
        }
        if urlString.contains("firebase"){
            guard let url1 = URL(string: urlString) else {
                return
            }
            self.image.kf.setImage(with: url1)
        }
        else{
            let imagePath = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            guard let url = imagePath, let url1 = URL(string: url) else {
                return
            }
            self.image.kf.setImage(with: url1)
        }
    }
}
