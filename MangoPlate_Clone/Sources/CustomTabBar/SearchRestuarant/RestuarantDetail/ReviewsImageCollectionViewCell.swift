//
//  ReviewImageCollectionViewCell.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/20.
//

import UIKit
import Kingfisher

class ReviewsImageCollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var image: UIImageView!
    
    func updateUI(urlString: String?){
        guard let urlString = urlString else {
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
