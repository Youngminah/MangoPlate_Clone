//
//  DetailReviewTableViewCell.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/20.
//

import UIKit
import Kingfisher


protocol CellDelegate {
    func sharePressed(reviewId: Int)
}


class DetailReviewTableViewCell: UITableViewCell{
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var userReviewsLabel: UILabel!
    @IBOutlet weak var userFollowerLabel: UILabel!
    @IBOutlet weak var userSatisfiedImage: UIImageView!
    @IBOutlet weak var reviewsTestView: UITextView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var reviewsImageString: [String] = []
    var delegate: CellDelegate?
    var reviewId: Int?
    
    func updateUI(data: PreReviewsInfo){
        self.profileImage.layer.cornerRadius = self.profileImage.bounds.width / 2
        self.userIDLabel.text = data.id
        self.userReviewsLabel.text = "\(data.totalReviews)".insertComma
        self.userFollowerLabel.text = "\(data.follower)".insertComma
        self.reviewsTestView.text = data.reviewContent
        self.likeLabel.text = "좋아요 \(data.likes)개".insertComma
        self.commentLabel.text = "댓글 \(data.comments)개"
        self.dateLabel.text = data.date
        self.reviewId = data.reviewId
        
        if data.satisfaction == "맛있다!"{
            userSatisfiedImage.image = UIImage(named: "리뷰맛있다")
        }
        else if data.satisfaction == "괜찮다"{
            userSatisfiedImage.image = UIImage(named: "리뷰괜찮다")
        }
        else{
            userSatisfiedImage.image = UIImage(named: "리뷰별로")
        }
        
        //이미지업뎃
        let temp = data.userImage.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url = temp, let userImageURL = URL(string: url) else {
            return
        }
        self.profileImage.kf.setImage(with: userImageURL)
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegate, forRow section: Int) {
        imageCollectionView.reloadData()
        imageCollectionView.delegate = dataSourceDelegate
        imageCollectionView.dataSource = dataSourceDelegate
        imageCollectionView.tag = section
    }
    
    func updatePageUI(page: Int, totalPage: Int){
        self.pageLabel.text = "(\(page)/\(totalPage))"
    }
    
    func dismissImage(){
        self.imageCollectionView.isHidden = true
    }
    
    @IBAction func menuButtonTab(_ sender: UIButton) {
        guard let reviewId = self.reviewId else {
            return
        }
        delegate?.sharePressed(reviewId: reviewId)
    }

}
