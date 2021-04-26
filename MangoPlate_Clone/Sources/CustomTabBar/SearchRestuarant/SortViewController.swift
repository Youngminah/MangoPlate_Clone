//
//  SortViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/18.
//

import UIKit

protocol SortSelectedDataDelegate {
    func sendData(data: String)
}

class SortViewController: UIViewController {

    @IBOutlet weak var gradeButton: UIButton!
    @IBOutlet weak var recomendButton: UIButton!
    @IBOutlet weak var reviewButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var sortMeneView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    var delegate: SortSelectedDataDelegate?
    var sortSelectedDefault: String!
    var sortMenuButton : [UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        prepareSetAnimation()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissByTabGesture(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showSetAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //showSetAnimation()
    }

    @IBAction func dismissButtonTab(_ sender: UIButton) {
        self.showDimissAnimation()
    }
    
    @objc func dismissByTabGesture(_ gesture: UITapGestureRecognizer){
        self.showDimissAnimation()
    }
    
    func updateUI(){
        self.sortMenuButton = [self.gradeButton , self.recomendButton , self.reviewButton, self.distanceButton]
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.navigationController?.isNavigationBarHidden = true
        if sortSelectedDefault == "평점순"{
            sortCategoryButtonUpdateUI(tag : 0)
        }else if sortSelectedDefault == "조회순"{
            sortCategoryButtonUpdateUI(tag : 1)
        }else if sortSelectedDefault == "리뷰순"{
            sortCategoryButtonUpdateUI(tag : 2)
        }else{
            sortCategoryButtonUpdateUI(tag : 3)
        }
    }
    
    @IBAction func sortCategoryButtonTab(_ sender: UIButton) {
        if let data = sender.title(for: .normal){
            delegate?.sendData(data: data)
        }
        self.sortCategoryButtonUpdateUI(tag: sender.tag)
        self.showDimissAnimation()
    }
    
    func sortCategoryButtonUpdateUI(tag : Int){
        self.sortMenuButton = self.sortMenuButton.map { button in
            button.isSelected = false
            button.layer.borderWidth = 0.0;
            return button
        }
        for button in sortMenuButton{
            if button.tag == tag{
                button.isSelected = true
                button.layer.borderWidth = 2
                button.layer.cornerRadius = 16
                button.layer.borderColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
            }
        }
    }
    
}

// MARK: 메뉴 애니메이션 띄우기 & 지우기 함수
extension SortViewController{
    private func prepareSetAnimation(){
        self.sortMeneView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
    }
    
    private func showSetAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.sortMeneView.transform = CGAffineTransform.identity
                       }, completion: nil)
    }
    
    private func showDimissAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.sortMeneView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
                       }, completion: {_ in
                            self.dismiss(animated: false, completion: nil)
                       })
    }
}
