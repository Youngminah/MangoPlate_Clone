//
//  SearchFilterViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/21.
//

import UIKit


protocol FilterSelectedDataDelegate {
    func sendData(foodValueList: [Int], priceValueList: [Int], parkingValue: Int)
}

class SearchFilterViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var contentMenuView: UIView!
    @IBOutlet weak var categoryAllButton: UIButton!
    @IBOutlet weak var categoryWannagoButton: UIButton!
    @IBOutlet weak var categoryHavebeenButton: UIButton!
    @IBOutlet weak var parkingDontCareButton: UIButton!
    @IBOutlet weak var parkingAvailButton: UIButton!
    
    @IBOutlet weak var foodButton1: UIButton!
    @IBOutlet weak var foodButton2: UIButton!
    @IBOutlet weak var foodButton3: UIButton!
    @IBOutlet weak var foodButton4: UIButton!
    @IBOutlet weak var foodButton5: UIButton!
    @IBOutlet weak var foodButton6: UIButton!
    @IBOutlet weak var foodButton7: UIButton!
    @IBOutlet weak var foodButton8: UIButton!
    
    @IBOutlet weak var priceButton1: UIButton!
    @IBOutlet weak var priceButton2: UIButton!
    @IBOutlet weak var priceButton3: UIButton!
    @IBOutlet weak var priceButton4: UIButton!
    
    
    var delegate: FilterSelectedDataDelegate?
    var foodButtons: [UIButton] = []
    var priceButtons: [UIButton] = []
    var foodValueList: [Int] = []
    var priceValueList: [Int] = []
    var parkingValue: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodButtons = [foodButton1, foodButton2, foodButton3, foodButton4, foodButton5, foodButton6, foodButton7, foodButton8]
        self.priceButtons = [priceButton1, priceButton2, priceButton3, priceButton4]
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        prepareSetAnimation()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissByTabGesture(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
        updateSelectedButtonUI(button: self.categoryAllButton)
        updateSelectedButtonUI(button: self.parkingDontCareButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showSetAnimation()
    }
    
    @IBAction func requestFilterButtonTab(_ sender: UIButton) {
        self.makeSelectedButtonInfoArray()
        delegate?.sendData(foodValueList: self.foodValueList, priceValueList: self.priceValueList, parkingValue: self.parkingValue)
        self.showDimissAnimation()
    }
    
    @IBAction func categoryButtonTab(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        updateSelectedButtonUI(button: sender)
        if sender.tag == 0{
            updateNotSelectedButtonUI(button: self.categoryWannagoButton)
            updateNotSelectedButtonUI(button: self.categoryHavebeenButton)
        }else if sender.tag == 1{
            updateNotSelectedButtonUI(button: self.categoryAllButton)
            updateNotSelectedButtonUI(button: self.categoryHavebeenButton)
        }else{
            updateNotSelectedButtonUI(button: self.categoryAllButton)
            updateNotSelectedButtonUI(button: self.categoryWannagoButton)
        }
    }
    
    @IBAction func foodButtonTab(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func priceButtonTab(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func parkingButtonTab(_ sender: UIButton) {
        if sender.isSelected {
            return
        }
        updateSelectedButtonUI(button: sender)
        if sender.tag == 1{
            parkingValue = 1
            updateNotSelectedButtonUI(button: self.parkingAvailButton)
        }else{
            parkingValue = 0
            updateNotSelectedButtonUI(button: self.parkingDontCareButton)
        }
    }
    
    @IBAction func dismissButtonTab(_ sender: UIButton) {
        self.showDimissAnimation()
    }
    
    func makeSelectedButtonInfoArray(){
        for button in self.foodButtons{
            if button.isSelected == true {
                self.foodValueList.append(button.tag)
            }
        }
        for button in self.priceButtons{
            if button.isSelected == true {
                self.priceValueList.append(button.tag)
            }
        }
    }
    
    func updateSelectedButtonUI(button : UIButton){
        button.isSelected = true
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 16
        button.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
    }
    
    func updateNotSelectedButtonUI(button : UIButton){
        button.isSelected = false
        button.layer.borderWidth = 0.0;
    }
}


// MARK: 메뉴 애니메이션 띄우기 & 지우기 함수
extension SearchFilterViewController{
    
    @objc func dismissByTabGesture(_ gesture: UITapGestureRecognizer){
        self.showDimissAnimation()
    }
    
    private func prepareSetAnimation(){
        self.contentMenuView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
    }
    
    private func showSetAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.contentMenuView.transform = CGAffineTransform.identity
                       }, completion: nil)
    }
    
    private func showDimissAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.contentMenuView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
                       }, completion: {_ in
                            self.dismiss(animated: false, completion: nil)
                       })
    }
}
