//
//  SearchCollectionHeader.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/14.
//

import UIKit

class SearchCollectionHeader: UICollectionReusableView{
    
    @IBOutlet weak var adCollectionView: UICollectionView!
    @IBOutlet weak var adPageControl: UIPageControl!
    @IBOutlet weak var sortButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    
    var adImages: [String] = ["광고1","광고2","광고3","광고4"]
    var timer = Timer()
    var counter = 0
        
}

// MARK: 광고 컬렉션뷰에 관한 부분
extension SearchCollectionHeader: UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return adImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ADCell", for: indexPath) as? AdCell else {
            return UICollectionViewCell()
        }
        cell.image = UIImage(named: adImages[indexPath.item])
        return cell
    }

    func updateProtocols(){
        self.adCollectionView.delegate = self
        self.adCollectionView.dataSource = self
        adPageControl.numberOfPages = self.adImages.count
        adPageControl.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.changeAdImage), userInfo: nil, repeats: true)
        }
    }
    
    // MARK: UICollectionViewDelegate에 있는 메소드
    // 사용자가 직접 광고 CollectionView를 스크롤할 경우를 대비한 메소드
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
      let page = Int(targetContentOffset.pointee.x / self.frame.width)
      adPageControl.currentPage = page
      counter = page
    }
    
    @objc func changeAdImage(){
        if counter < adImages.count{
            let index = IndexPath.init(item: counter, section: 0)
            self.adCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            adPageControl.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.adCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            adPageControl.currentPage = counter
            counter = 1
        }
    }
    
    func  collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.width/69 * 26
        return CGSize(width: width, height: height)
    }
}

