//
//  PictureListViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/19.
//

import UIKit

class DetailPictureViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    let imageViewModel = DetailImageViewModel()
    var imageArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.requestDataAPI()
    }
    
    func requestDataAPI(){
        self.showIndicator()
        self.imageViewModel.requestDetailImageListAPI(restaurantID: 1)
        self.imageViewModel.didFinishFetch = {
            self.imageArray = self.imageViewModel.mainImageURLArray
            self.imageCollectionView.reloadData()
            self.dismissIndicator()
        }
    }
}

extension DetailPictureViewController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageViewModel.numOfRestuarantInfoList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailImageCell", for: indexPath) as? DetailImageCollectionViewCell else {
            return UICollectionViewCell()
        }
        // indexPath. item으로 접근하기
        let imagePath = imageArray[indexPath.item]
        cell.updateUI(imagePath: imagePath)
        return cell
    }
}
