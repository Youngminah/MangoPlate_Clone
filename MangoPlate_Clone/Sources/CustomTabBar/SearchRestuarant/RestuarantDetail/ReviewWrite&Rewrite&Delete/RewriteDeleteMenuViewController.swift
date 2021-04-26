//
//  RewriteDeleteMenuViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/24.
//

import UIKit

class RewriteDeleteMenuViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var rewriteButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let deleteReviewViewModel = DeleteReviewViewModel()
    var reviewId: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setAnimation()
        self.updateUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showSetAnimation()
    }
    
    @IBAction func rewriteButtonTab(_ sender: UIButton) {
        
    }
    
    @IBAction func deleteButtonTab(_ sender: UIButton) {
        requestAPI()
    }
    
    @IBAction func cancelButtonTab(_ sender: UIButton) {
        self.showDimissAnimation()
    }
    
    
    @objc func dismissByTabGesture(_ gesture: UITapGestureRecognizer){
        self.showDimissAnimation()
    }
    
    func requestAPI(){
        self.showIndicator()
        self.deleteReviewViewModel.deleteReviewAPI(reviewId: self.reviewId)
        self.deleteReviewViewModel.didFinishFetch = {
            self.dismissIndicator()
            self.goBackToRootAnimation()
        }
    }
    
    func setAnimation(){
        self.prepareSetAnimation()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissByTabGesture(_:)))
        self.contentView.addGestureRecognizer(tapGesture)
    }
    
    func updateUI(){
        self.contentView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.rewriteButton.layer.borderWidth = 2
        self.rewriteButton.layer.cornerRadius = 20
        self.rewriteButton.layer.borderColor = #colorLiteral(red: 0.992348969, green: 0.4946574569, blue: 0.004839691333, alpha: 1)
        self.deleteButton.layer.borderWidth = 2
        self.deleteButton.layer.cornerRadius = 20
        self.deleteButton.layer.borderColor = #colorLiteral(red: 0.992348969, green: 0.4946574569, blue: 0.004839691333, alpha: 1)
        self.cancelButton.layer.borderWidth = 2
        self.cancelButton.layer.cornerRadius = 20
        self.cancelButton.layer.borderColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    }
    
}

// MARK: 메뉴 애니메이션 띄우기 & 지우기 함수
extension RewriteDeleteMenuViewController{
    private func prepareSetAnimation(){
        self.menuView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
    }
    
    private func showSetAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.menuView.transform = CGAffineTransform.identity
                       }, completion: nil)
    }
    
    private func showDimissAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.menuView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
                       }, completion: {_ in
                            self.dismiss(animated: false, completion: nil)
                       })
    }
    
    private func goBackToRootAnimation(){
        UIView.animate(withDuration: 0.6, delay: 0, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.menuView.transform = CGAffineTransform(translationX: 0, y: self.contentView.frame.height)
                       }, completion: {_ in
                        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                       })
    }
}
