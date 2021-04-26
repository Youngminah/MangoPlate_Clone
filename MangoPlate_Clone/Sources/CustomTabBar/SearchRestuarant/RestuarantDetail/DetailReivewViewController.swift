//
//  DetailReivewViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/20.
//

import UIKit



class DetailReivewViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    var page: [Int] = [1,1,1]
    var totalPage: [Int] = [0,0,0]
    let preReviewsViewModel = PreReviewsViewModel()
    var didFinishFetch: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestDataAPI()
        print("테이블 컨트롤러 willappear")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("테이블 컨트롤러 viewdidappear")
    }
    
    
    func requestDataAPI(){
        self.showIndicator()
        self.preReviewsViewModel.requestPreReviewsListAPI()
        self.preReviewsViewModel.didFinishFetch = {
            //print(self.preReviewsViewModel.reviewsImagePath)
            self.tableView.reloadData()
            self.dismissIndicator()
        }
    }
    
}



extension DetailReivewViewController: UITableViewDelegate, UITableViewDataSource{
    //테이블 뷰 각 섹션당 셸 몇개 ?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //테이블 뷰 헤더 섹션의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10.0
    }
    
    //테이블 뷰 섹션 색깔 바꾸기
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = #colorLiteral(red: 0.9415480182, green: 0.9506706024, blue: 0.9496951022, alpha: 1)
        return headerView
    }
    
    //테이블 뷰 해더 섹션 총 갯수 몇 개?
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    //테이블뷰 커스텀 셸 어떻게 보여줘?
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailReviewCell", for: indexPath) as? DetailReviewTableViewCell else {
            return UITableViewCell()
        }
        if self.preReviewsViewModel.numOfRestuarantInfoList <= indexPath.section {
            return cell
        }
        let data = self.preReviewsViewModel.preReviewsList(at: indexPath.section)
        cell.updateUI(data: data)
        cell.imageCollectionView.reloadData()
        cell.delegate = self
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
        totalPage[indexPath.section] = self.preReviewsViewModel.reviewsImagePath[indexPath.section].count
        cell.updatePageUI(page: page[indexPath.section], totalPage: totalPage[indexPath.section])
        print("컬렉션")
    
        return cell
    }
}

extension DetailReivewViewController: CellDelegate{
    func sharePressed(reviewId: Int) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RewriteDeleteMenuView") as? RewriteDeleteMenuViewController else{
            return
        }
        vc.reviewId = reviewId
        self.present(vc, animated: false, completion: nil)
    }
}

extension DetailReivewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if preReviewsViewModel.numOfRestuarantInfoList == 0 {
            return 0
        }
        return self.preReviewsViewModel.reviewsImagePath[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsImageCell", for: indexPath) as? ReviewsImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        let urlString = self.preReviewsViewModel.reviewsImagePath[collectionView.tag][indexPath.item]

        cell.updateUI(urlString: urlString)
        
        return cell
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width
        let height: CGFloat = width * 167/350
        return CGSize(width: width, height: height)
    }
    
    // MARK: UICollectionViewDelegate에 있는 메소드
    // 사용자가 직접 광고 CollectionView를 스크롤할 경우를 대비한 메소드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let page = Int(targetContentOffset.pointee.x / scrollView.frame.width + 0.1)
        self.page[scrollView.tag] = page + 1
        tableView.reloadData()
    }
}
