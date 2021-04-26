//
//  SearchRestuarantViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/13.
//

import UIKit
import CoreLocation

class SearchRestuarantViewController: BaseViewController, CLLocationManagerDelegate{

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var restuarantCollectionView: UICollectionView!
    let restuarantViewModel = RestuarantViewModel()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let sortValueDic = ["평점순": 0, "조회순": 1, "리뷰순": 2, "거리순":3]
    var queryValue : QueryValue = (0, 3000)
    var sortValue: String = "평점순"
    
    var foodValueList: [Int] = []
    var priceValueList: [Int] = []
    var parkingValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLocation()
        self.updateAPI()
        //self.dismissIndicator()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func updateAPI(){
        self.showIndicator()
        self.restuarantViewModel.vc = self
        self.restuarantViewModel.getRestuarantListAPI(filter: queryValue.filter, food: foodValueList, price: priceValueList, isAvailParking: parkingValue, long: 127.071539, lat: 37.535978, distance: queryValue.distance)
    }
    
    @IBAction func mapButtonTab(_ sender: UIButton) {
        
    }
    
    @IBAction func chooseSortButtonTab(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SortView") as? SortViewController else{
            return
        }
        vc.delegate = self
        vc.sortSelectedDefault = sortValue
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func filterButtonTab(_ sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SearchFilterView") as? SearchFilterViewController else{
            return
        }
        vc.delegate = self
        self.present(vc, animated: false, completion: nil)
    }
}


//MARK: Cell에서 가고싶다 클릭시, 로그인이 안되어있으면 로그인하는 화면 띄우는 프로토콜
extension SearchRestuarantViewController: LoginDelegate{
    func requestLoginPressed() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRequestView") as? LoginRequestViewController else{
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK: 리뷰순, 추천순, 거리순, 평점순 고를때 선택한 값이 돌아오는 프로토콜
extension SearchRestuarantViewController: SortSelectedDataDelegate{
    func sendData(data: String) {
        sortValue = data
        queryValue.filter = self.sortValueDic[sortValue]!
        self.restuarantViewModel.getRestuarantListAPI(filter: queryValue.filter, food: foodValueList, price: priceValueList, isAvailParking: parkingValue, long: 127.071539, lat: 37.535978, distance: queryValue.distance)
    }
}


// MARK: 필터 고를때 선택한 값이 돌아오는 프로토콜
extension SearchRestuarantViewController: FilterSelectedDataDelegate{
    func sendData(foodValueList: [Int], priceValueList: [Int], parkingValue: Int) {
        self.foodValueList = foodValueList
        self.priceValueList = priceValueList
        self.parkingValue = parkingValue
        self.restuarantViewModel.getRestuarantListAPI(filter: queryValue.filter, food: foodValueList, price: priceValueList, isAvailParking: parkingValue, long: 127.071539, lat: 37.535978, distance: queryValue.distance)
        self.restuarantCollectionView.reloadData()
    }
}

// MARK: 맛집찾기 메인뷰안의 컬렉션뷰에 관한 내용
extension SearchRestuarantViewController: UICollectionViewDelegate, UICollectionViewDataSource ,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restuarantViewModel.numOfRestuarantInfoList
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestuarantCell", for: indexPath) as? RestuarantCell else {
            return UICollectionViewCell()
        }
        let restuarantInfo = restuarantViewModel.restuarantInfo(at: indexPath.item)
        cell.delegate = self
        cell.updateUI(info: restuarantInfo)
        return cell
        
    }
    
    //UICollectionViewDelegateFlowLayout 프로토콜
    //cell사이즈를  계산할꺼 - 다양한 디바이스에서 일관적인 디자인을 보여주기 위해 에 대한 답
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = (collectionView.bounds.width - 8)/2
        let height: CGFloat = width * 51/40 
        return CGSize(width: width, height: height)
    }
    
    // 맛집 헤더뷰 어떻게 표시할까?
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind { // kind의 종류는 크게 해더와 푸터가 있음
        case UICollectionView.elementKindSectionHeader:
            //해더, footer등등 를 deque할 땐 supplementaryView임.
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchCollectionHeader", for: indexPath) as? SearchCollectionHeader else {
                return UICollectionReusableView()
            }
            if foodValueList == [] && priceValueList == [] {
                header.filterButton.isSelected = false
            }
            else{
                header.filterButton.isSelected = true
            }
            header.sortButton.setTitle(sortValue, for: .normal)
            header.updateProtocols()
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "DetailRestaurantStoryboard", bundle: nil).instantiateViewController(withIdentifier: "DetailNavigationView") as? DetailNavigationViewController else{
            return
        }
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
}


// MARK: 현재 위치 설정
extension SearchRestuarantViewController{
    func setupLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil{
            currentLocation = locations.first
            locationManager.stopUpdatingLocation()
            print(currentLocation)
        }
    }
}
