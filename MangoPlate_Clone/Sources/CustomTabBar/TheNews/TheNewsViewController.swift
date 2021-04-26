//
//  TheNewsViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/15.
//

import UIKit

class TheNewsViewController: UIViewController {

    @IBOutlet weak var allReviewsButton: UIButton!
    @IBOutlet weak var followingReviewsButton: UIButton!
    @IBOutlet weak var hollicReviewsButton: UIButton!
    @IBOutlet weak var animationBar: UIView!
    @IBOutlet weak var reviewColloectionView: UICollectionView!
    
    var userScore = 1
    var reviewsViewModel = ReviewsViewModel()
    var reviewImagesViewModel = ReviewImagesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestReviewsInfoAPI(score: userScore)
        reviewsViewModel.reset()
        reviewImagesViewModel.reset()
    }
    
    @IBAction func topBarButtonTab(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 0 {
            followingReviewsButton.isSelected = false
            hollicReviewsButton.isSelected = false
            slideViewAnimation(moveX: 0)
        } else if sender.tag == 1{
            allReviewsButton.isSelected = false
            hollicReviewsButton.isSelected = false
            slideViewAnimation(moveX: self.view.frame.width/3)
        }
        else{
            allReviewsButton.isSelected = false
            followingReviewsButton.isSelected = false
            slideViewAnimation(moveX: self.view.frame.width/3*2)
        }
    }
    
    @IBAction func gradeButtonTouchUp(_ sender: UIButton) {
        if sender.tag == 0 {
            reviewsViewModel.reset()
            reviewImagesViewModel.reset()
            self.requestReviewsInfoAPI(score: 1)
        }
        else if sender.tag == 1{
            reviewsViewModel.reset()
            reviewImagesViewModel.reset()
            self.requestReviewsInfoAPI(score: 0)
        }
        else {
            self.reviewsViewModel.reset()
            self.reviewImagesViewModel.reset()
            self.requestReviewsInfoAPI(score: -1)
        }
    }
    
    func requestReviewsInfoAPI(score: Int){
        self.showIndicator()
        self.reviewsViewModel.requestReviewsListAPI(score: score)
        self.reviewsViewModel.didFinishFetch = {
            self.reviewImagesViewModel.requestReviewImagesListAPI(score: score)
            self.reviewImagesViewModel.didFinishFetch = {
                self.reviewColloectionView.reloadData()
                self.dismissIndicator()
            }
        }
    }
    
    func slideViewAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 1, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.animationBar.transform = CGAffineTransform(translationX: moveX, y: 0)
                       }, completion: {_ in
                       })
    }
}

extension TheNewsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reviewsViewModel.numOfReviewsInfoList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TheNewsCell", for: indexPath) as? TheNewsCell else {
            return UICollectionViewCell()
        }
        // indexPath. item으로 접근하기
        let data = self.reviewsViewModel.reviewsInfo(at: indexPath.item)
        cell.updateUI(data: data)
        cell.updateImageCellInfo(imageArray: self.reviewImagesViewModel.reviewsImagePath[indexPath.item], forRow: indexPath.item)
        cell.updatePageUI(page: 1, totalPage: self.reviewImagesViewModel.reviewsImagePath[indexPath.item].count)
        cell.imageCollectionView.reloadData()
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 8)/2
        let height: CGFloat = width * 480/388
        return CGSize(width: width, height: height)
    }
    
    // 맛집 헤더뷰 어떻게 표시할까?
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind { // kind의 종류는 크게 해더와 푸터가 있음
        case UICollectionView.elementKindSectionHeader:
            //해더, footer등등 를 deque할 땐 supplementaryView임.
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TheNewsHeader", for: indexPath) as? TheNewsCollectionHeader else {
                return UICollectionReusableView()
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
}



