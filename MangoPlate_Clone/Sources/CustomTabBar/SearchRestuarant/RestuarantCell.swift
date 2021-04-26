//
//  RestuarantCollectionViewCell.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/16.
//

import UIKit
import Kingfisher


protocol LoginDelegate {
    func requestLoginPressed()
}


class RestuarantCell: UICollectionViewCell {
    
    @IBOutlet weak var restuarantMainImage: UIImageView!
    @IBOutlet weak var restuarantNameLabel: UILabel!
    @IBOutlet weak var restuarantLocationLabel: UILabel!
    @IBOutlet weak var resturantDistanceLabel: UILabel!
    @IBOutlet weak var restuarantViewsLabel: UILabel!
    @IBOutlet weak var restuarantReviewsLabel: UILabel!
    @IBOutlet weak var restuarantGradeLabel: UILabel!
    @IBOutlet weak var wannogoButton: UIButton!
    
    var delegate: LoginDelegate?
    
    func updateUI(info: RestuarantInfo){
        self.restuarantNameLabel.text = info.name
        self.restuarantLocationLabel.text = info.location
        self.resturantDistanceLabel.text = info.distance
        self.restuarantViewsLabel.text = "\(info.views)".insertComma
        self.restuarantReviewsLabel.text = "\(info.reviews)".insertComma
        self.restuarantGradeLabel.text = "\(info.grade)".insertComma
        
        //이미지 부분.
        guard let imagePath = info.mainImage else {
            return
        }
        let someting = imagePath.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = someting , let url1 = URL(string: url)else {
            return
        }
        self.restuarantMainImage.kf.setImage(with: url1)
    }
    
    @IBAction func wannagoButtonTab(_ sender: UIButton) {
        if !JwtToken.isLogin {
            self.delegate?.requestLoginPressed()
        }
        else {
            sender.isSelected = !sender.isSelected
        }
    }
}
