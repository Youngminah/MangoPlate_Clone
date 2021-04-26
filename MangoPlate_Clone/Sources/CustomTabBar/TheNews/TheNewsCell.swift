//
//  TheNewsCell.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

import UIKit
import Kingfisher

class TheNewsCell: UICollectionViewCell {
    
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var totalReviewsLabel: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var gradeImage: UIImageView!
    @IBOutlet weak var reviewContent: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var reviewContentHeight: NSLayoutConstraint!
    
    var reviewsImagePath : [String?] = []
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonTab(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func updateUI(data: ReviewsInfo){
        self.userProfileImage.layer.cornerRadius = self.userProfileImage.bounds.width / 2
        self.userNameLabel.text = data.userName
        self.totalReviewsLabel.text = "\(data.totalReviews)".insertComma
        self.followerLabel.text = "\(data.follower)".insertComma
        self.reviewContent.text = data.reviewContent
        self.dateLabel.text = "\(data.date)"
        self.likesLabel.text = "좋아요 \(data.likes)개"
        self.commentsLabel.text = "댓글 \(data.comments)개"
        self.restaurantNameLabel.text = "@\(data.restaurantName)"
        self.locationLabel.text = "- \(data.location)"
        if data.satisfaction == "맛있다!"{
            self.gradeImage.image = UIImage(named: "리뷰맛있다")
        }
        else if data.satisfaction == "괜찮다"{
            self.gradeImage.image = UIImage(named: "리뷰괜찮다")
        }
        else{
            self.gradeImage.image = UIImage(named: "리뷰별로")
        }
        guard let userImageString = data.userImage else{
            return
        }
        //이미지업뎃
        let userImagePath = userImageString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        guard let url2 = userImagePath, let userImageURL = URL(string: url2) else {
            return
        }
        self.userProfileImage.kf.setImage(with: userImageURL)
    }
    
    func updateImageCellInfo(imageArray: [String?], forRow section: Int){
        if imageArray == [nil]{
            self.imageCollectionView.isHidden = true
            self.pageLabel.isHidden = true
            self.reviewContentHeight.constant += imageCollectionView.frame.height
            return
        }
        else{
            self.imageCollectionView.isHidden = false
            self.imageCollectionView.tag = section
            self.imageCollectionView.delegate = self
            self.imageCollectionView.dataSource = self
            self.reviewsImagePath = imageArray
        }
    }
    
    func updatePageUI(page: Int, totalPage: Int){
        self.pageLabel.text = "(\(page)/\(totalPage))"
    }
    
}


extension TheNewsCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviewsImagePath.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "allReviewsImageCell", for: indexPath) as? allReviewsImageCell else {
            return UICollectionViewCell()
        }
        let urlString = self.reviewsImagePath[indexPath.item]
        cell.updateUI(urlString: urlString)
        
        return cell
    }
    
    // MARK: Cell 사이즈 계산
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = width * 172/356
        return CGSize(width: width, height: height)
    }
    
    // MARK: UICollectionViewDelegate에 있는 메소드 : 사용자가 리뷰 이미지를 CollectionView를 스크롤할 경우를 대비한 메소드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width + 0.1)
        updatePageUI(page: page + 1, totalPage: self.reviewsImagePath.count)
    }
}
