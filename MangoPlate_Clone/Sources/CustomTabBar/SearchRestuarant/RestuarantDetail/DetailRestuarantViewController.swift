//
//  RestuarantDetailViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/16.
//

import UIKit


class DetailRestuarantViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var restaurantTitle: UILabel!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var restaurantScoreLabel: UILabel!
    @IBOutlet weak var restaurantViewsLabel: UILabel!
    @IBOutlet weak var restaurantReviewsLabel: UILabel!
    @IBOutlet weak var wannagoLabel: UILabel!
    @IBOutlet weak var generalAddressLabel: UILabel!
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var openTimeLabel: UILabel!
    @IBOutlet weak var priceAverageLabel: UILabel!
    @IBOutlet weak var firstMenuLabel: UILabel!
    @IBOutlet weak var secondMenuLabel: UILabel!
    @IBOutlet weak var thirdMenuLabel: UILabel!
    @IBOutlet weak var firstMenuPriceLabel: UILabel!
    @IBOutlet weak var secondMenuPriceLabel: UILabel!
    @IBOutlet weak var thirdMenuPriceLabel: UILabel!
    @IBOutlet weak var majorReviewsLabel: UILabel!
    @IBOutlet weak var greatLabel: UILabel!
    @IBOutlet weak var sosoLabel: UILabel!
    @IBOutlet weak var badLabel: UILabel!
    @IBOutlet weak var firstKeywordButton: UIButton!
    
    let restaurantViewModel = DetailRestaurantViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        requestRestaurantInfoAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @IBAction func dismissBarButtonTab(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func aa(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func writeReviewButtonTab(_ sender: UIButton) {
        if !JwtToken.isLogin {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRequestView") as? LoginRequestViewController else{
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else{
            guard let vc = self.storyboard?.instantiateViewController(identifier: "WriteNavigation") as? WriteNavigationController else {
                return
            }
            vc.delegate = self
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func wannagoButtonTab(_ sender: UIButton) {
        if !JwtToken.isLogin {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRequestView") as? LoginRequestViewController else{
                return
            }
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else{
            sender.isSelected = !sender.isSelected
        }
    }
    
    func updateUI(){
        self.firstKeywordButton.layer.borderWidth = 1
        self.firstKeywordButton.layer.borderColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.firstKeywordButton.layer.cornerRadius = 15
    }
    
    func requestRestaurantInfoAPI(){
        self.showIndicator()
        self.restaurantViewModel.requestRestaurantListAPI(restaurantID: 1)
        self.restaurantViewModel.didFinishFetch = {
            guard let data = self.restaurantViewModel.detailRestaurantInfoList else {
                return
            }
            self.restaurantTitle.text = data.name
            self.restaurantNameLabel.text = data.name
            self.restaurantScoreLabel.text = "\(data.score)"
            self.restaurantViewsLabel.text = "\(data.views)".insertComma
            self.restaurantReviewsLabel.text = "\(data.reviews)".insertComma
            self.wannagoLabel.text = "\(data.wannago)".insertComma
            self.generalAddressLabel.text = data.generalAddress
            self.streetAddressLabel.text = data.streetAddress
            self.openTimeLabel.text = data.openTime
            self.priceAverageLabel.text = data.priceAverage
            self.firstMenuLabel.text = self.restaurantViewModel.menuList[0]
            self.secondMenuLabel.text = self.restaurantViewModel.menuList[1]
            self.thirdMenuLabel.text = self.restaurantViewModel.menuList[2]
            self.firstMenuPriceLabel.text = self.restaurantViewModel.menuPrice[0]
            self.secondMenuPriceLabel.text = self.restaurantViewModel.menuPrice[1]
            self.thirdMenuPriceLabel.text = self.restaurantViewModel.menuPrice[2]
            self.majorReviewsLabel.text = "주요 리뷰 (\(data.great + data.soso + data.bad))"
            self.greatLabel.text = "맜있다! (\(data.great))"
            self.sosoLabel.text = "괜찮다 (\(data.soso))"
            self.badLabel.text = "별로 (\(data.bad))"
            self.dismissIndicator()
        }
    }
}


extension DetailRestuarantViewController: ReloadDelegate{
    func dismissWrite() {
    }
}
