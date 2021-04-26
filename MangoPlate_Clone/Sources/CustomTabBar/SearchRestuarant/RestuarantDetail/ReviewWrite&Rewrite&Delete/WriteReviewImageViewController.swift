//
//  WriteReviewViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/20.
//

import UIKit
import Photos
import FirebaseStorage



protocol ReloadDelegate {
    func dismissWrite()
}

protocol SendImageDataDelegate {
    func sendData(data: String)
}


class WriteReviewImageViewController: UIViewController {
    
 //   var imageCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var confirmView: UIView!
    @IBOutlet weak var imageMaxLabel: UILabel!
    
    private let storage = Storage.storage().reference()
    var delegate: ReloadDelegate?
    
    var imageArray = [UIImage]()
    var selectedImage : [UIImage] = []
    var imageIndex: [Int] = []
    var didFinishFetch: (() -> ())?
    var didFinishImageURLString: (() -> ())?
    var selectedImageCount : Int = 0
    var imageURLString : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showIndicator()
        grabPhotos()
        self.didFinishFetch = {
            self.dismissIndicator()
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        delegate?.dismissWrite()
    }
    
    @IBAction func nextButtonTab(_ sender: UIButton) {
        self.showIndicator()
        print(selectedImage.count)
        for index in 0..<selectedImage.count{
            var data = Data()
            data = selectedImage[index].jpegData(compressionQuality: 0.5)!
            storage.child("images/reviewImage\(index).png").putData(data, metadata: nil) { (_, error) in
                guard error == nil else{
                    print("Failed to upload")
                    return
                }
                DispatchQueue.global().sync {
                    self.storage.child("images/reviewImage\(index).png").downloadURL { (url, error) in
                        guard let url = url, error == nil else {
                            print(error)
                            return
                        }
                        let urlString = url.absoluteString
                        self.imageURLString.append(urlString)
                        print("다운로드 URL: \(urlString)")
                        
                        //한번만 실행
                        if self.imageURLString.count == self.selectedImage.count{
                            print("--> \(self.imageURLString)")
                            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "WriteReviewView") as? WriteReviewViewController else{
                                return
                            }
                            vc.imageURLString = self.imageURLString
                            self.navigationController?.pushViewController(vc, animated: true)
                            self.dismissIndicator()
                            
                        }
                    }
                }
            }
        }
        
    }
    
    func getloadImageURL(){
    }
 
    
    @IBAction func dismissButtonTab(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updatePhotos(){
        let photos = PHPhotoLibrary.authorizationStatus()
        if photos == .notDetermined{
            PHPhotoLibrary.requestAuthorization { (status) in
                if status == .authorized{
                    self.gotoVC()
                }
                else{
                    let alert = UIAlertController(title: "Photos Access Denied", message: "App needs access to photos", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
            }
        }
        else if photos == .authorized{
            gotoVC()
        }
    }

    func gotoVC(){
    }
    
    func grabPhotos(){
        imageArray = []
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            let imgManager=PHImageManager.default()
            let requestOptions=PHImageRequestOptions()
            requestOptions.isSynchronous=true
            requestOptions.deliveryMode = .highQualityFormat

            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]

            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult)
            print(fetchResult.count)
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("You got no photos.")
            }
            print("imageArray count: \(self.imageArray.count)")

            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                self.imageCollectionView.reloadData()
                self.didFinishFetch?()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension WriteReviewImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    // 맛집 헤더뷰 어떻게 표시할까?
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind { // kind의 종류는 크게 해더와 푸터가 있음
        case UICollectionView.elementKindSectionHeader:
            //해더, footer등등 를 deque할 땐 supplementaryView임.
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WriteReviewImageHeader", for: indexPath) as? WriteReviewImageHeader else {
                return UICollectionReusableView()
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count + 1
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 10)/4
        let height: CGFloat = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoItemCell", for: indexPath) as! PhotoItemCell
        cell.selectCountLabel.layer.cornerRadius = cell.selectCountLabel.bounds.width/2
        cell.selectView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        if indexPath.item == 0{
            cell.photo.image = UIImage(named: "리뷰쓰기사진")
            cell.selectView.isHidden = true
            return cell
        }else{
            if self.imageIndex.contains(indexPath.item - 1){
                if let index = self.imageIndex.firstIndex(where: { $0 == indexPath.item - 1 }) {
                    cell.selectCountLabel.text = "\(index + 1)"
                } 
                cell.selectView.isHidden = false
            }else{
                cell.selectView.isHidden = true
            }
            
            cell.photo.image = imageArray[indexPath.item-1]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let targetIndex = indexPath.item - 1
        let target = imageArray[targetIndex]
        if selectedImage.contains(target){
            if let index = selectedImage.firstIndex(where: { $0 == target}) {
                selectedImage.remove(at: index)
            }
            
            if let index = self.imageIndex.firstIndex(where: { $0 == targetIndex }) {
                imageIndex.remove(at: index)
            }
            print("빼기 --> \(imageIndex)")
        }
        else{
            if imageIndex.count == 30{
                return
            }
            selectedImage.append(imageArray[indexPath.item - 1])
            imageIndex.append(indexPath.item - 1)
            print("더하기 --> \(imageIndex)")
        }
        
        hasImageSelectUI()
        collectionView.reloadData()
    }
    
    func hasImageSelectUI(){
        self.imageMaxLabel.text = "(\(imageIndex.count)/30)"
        if imageIndex.count != 0{
            self.confirmView.backgroundColor = #colorLiteral(red: 0.992348969, green: 0.4946574569, blue: 0.004839691333, alpha: 1)
        }
        else{
            self.confirmView.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        }
    }
    
}

