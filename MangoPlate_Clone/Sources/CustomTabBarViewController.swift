//
//  CustomTabBarViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/15.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon


class CustomTabBarViewController: BaseViewController , UIViewControllerTransitioningDelegate{

    @IBOutlet weak var contentView: UIView!
    @IBOutlet var containerMainView: UIView!
    @IBOutlet weak var tabBarStackView: UIStackView!
    @IBOutlet weak var searchRestuarantImage: UIButton!
    @IBOutlet weak var searchRestuarantLabel: UIButton!
    @IBOutlet weak var mangoPickImage: UIButton!
    @IBOutlet weak var mangoPickLabel: UIButton!
    @IBOutlet weak var plusImage: UIButton!
    @IBOutlet weak var theNewsImage: UIButton!
    @IBOutlet weak var theNewsLabel: UIButton!
    @IBOutlet weak var myProfileImage: UIButton!
    @IBOutlet weak var myProfileLabel: UIButton!
    @IBOutlet weak var animationBar: UIView!
    
    var tabBarItemImage : [UIButton] = [UIButton]()
    var tabBarItemLabel : [UIButton] = [UIButton]()
    let transition =  CircularTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItemImage = [self.searchRestuarantImage , self.mangoPickImage , self.theNewsImage, self.myProfileImage]
        self.tabBarItemLabel = [self.searchRestuarantLabel , self.mangoPickLabel , self.theNewsLabel, self.myProfileLabel]
        changeViewToSearchRestuarantView(containerView: contentView)
        selectedStatusTabBarButton(selectedTabBarImage: self.searchRestuarantImage, selectedTabBarLabel: self.searchRestuarantLabel)
        self.plusImage.layer.cornerRadius = self.plusImage.frame.width/2
    }
    
    @IBAction func searchRestuarantButtonTab(_ sender: Any) {
        changeViewToSearchRestuarantView(containerView: contentView)
        slideViewAnimation(moveX: 0)
        selectedStatusTabBarButton(selectedTabBarImage: self.searchRestuarantImage, selectedTabBarLabel: self.searchRestuarantLabel)
    }
    
    @IBAction func mangoPickButtonTab(_ sender: UIButton) {
        changeViewToMangoPickView(containerView: contentView)
        slideViewAnimation(moveX: self.view.frame.width/5)
        selectedStatusTabBarButton(selectedTabBarImage: self.mangoPickImage, selectedTabBarLabel: self.mangoPickLabel)
    }
    
    @IBAction func theNewsButtonTab(_ sender: Any) {
        changeViewToTheNewsView(containerView: contentView)
        slideViewAnimation(moveX: self.view.frame.width/5*3)
        selectedStatusTabBarButton(selectedTabBarImage: self.theNewsImage, selectedTabBarLabel: self.theNewsLabel)
    }
    
    @IBAction func profileButtonTab(_ sender: Any) {
        changeViewToProfileView()
        slideViewAnimation(moveX: self.view.frame.width/5*4)
        selectedStatusTabBarButton(selectedTabBarImage: self.myProfileImage, selectedTabBarLabel: self.myProfileLabel)
    }
    
    // MARK:커스텀 탭바 버튼들의 isSelect 바꾸는 함수
    func selectedStatusTabBarButton(selectedTabBarImage : UIButton, selectedTabBarLabel : UIButton){
        tabBarItemImage = tabBarItemImage.map { button in
            button.isSelected = false
            return button
        }
        tabBarItemLabel = tabBarItemLabel.map { button in
            button.isSelected = false
            return button
        }
        selectedTabBarImage.isSelected = true
        selectedTabBarLabel.isSelected = true
    }
    
    func changeViewToProfileView(){
        UserApi.shared.accessTokenInfo { (_, error) in
            if let error = error {
                if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                    //로그인 필요
                    self.changeViewToUnLoginProfileView(containerView: self.contentView)
                }
                else {
                    print(error)
                }
            }
            else {
                //토큰 유효성 체크 성공(필요 시 토큰 갱신됨)
                self.changeViewToLoginProfileView(containerView: self.contentView)
            }
        }
    }
    
    func slideViewAnimation(moveX: CGFloat){
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 0.7, options: .allowUserInteraction,
                       animations: {
                        //변하기 전의 모습으로는 identity로 접근이 가능함.
                        self.animationBar.transform = CGAffineTransform(translationX: moveX, y: 0)
                       }, completion: {_ in
                       })
    }
}


// MARK: 플러스화면 이동에 필요한 함수 모음
extension CustomTabBarViewController{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondVC = segue.destination as! PlusViewController
        secondVC.transitioningDelegate = self
        secondVC.modalPresentationStyle = .custom
        secondVC.xButtonMidY = plusImage.frame.midY
        secondVC.screenHeight = self.contentView.bounds.size.height
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = CGPoint(x: self.contentView.bounds.size.width/2, y: self.contentView.bounds.size.height - plusImage.frame.midY)
        //print(self.contentView.bounds.size.height)
        transition.circleColor = plusImage.backgroundColor!
        
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint(x: self.contentView.bounds.size.width/2, y: self.contentView.bounds.size.height - plusImage.frame.midY)
        transition.circleColor = plusImage.backgroundColor!
        
        return transition
    }
}

extension CustomTabBarViewController{
    
    // MARK: Custom TabBar 화면전환
    func changeViewToSearchRestuarantView(containerView: UIView){
        guard let SearchVC = UIStoryboard(name: "SearchRestuarantStoryboard", bundle: nil).instantiateViewController(identifier: "SearchNavigationView") as? SearchNavigationController else {
            return
        }
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        SearchVC.willMove(toParent: self)
        containerView.frame = SearchVC.view.bounds
        containerView.addSubview(SearchVC.view)
        self.addChild(SearchVC)
        SearchVC.didMove(toParent: self)
    }
    
    func changeViewToMangoPickView(containerView: UIView){
        guard let mangoPickVC = UIStoryboard(name: "MangoPickStoryboard", bundle: nil).instantiateViewController(identifier: "MangoPickView") as? MangoPickViewController else {
            return
        }
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        mangoPickVC.willMove(toParent: self)
        containerView.addSubview(mangoPickVC.view)
        self.addChild(mangoPickVC)
        mangoPickVC.didMove(toParent: self)
    }
    
    func changeViewToPlusView(containerView: UIView){
        guard let plusVC = UIStoryboard(name: "PlusStoryboard", bundle: nil).instantiateViewController(identifier: "PlusView") as? PlusViewController else {
            return
        }
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        plusVC.willMove(toParent: self)
        containerView.addSubview(plusVC.view)
        self.addChild(plusVC)
        plusVC.didMove(toParent: self)
    }
    
    func changeViewToTheNewsView(containerView: UIView){
        guard let theNewsVC = UIStoryboard(name: "TheNewsStoryboard", bundle: nil).instantiateViewController(identifier: "TheNewsNavigation") as? TheNewsNavigationController else {
            return
        }
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        theNewsVC.willMove(toParent: self)
        containerView.addSubview(theNewsVC.view)
        self.addChild(theNewsVC)
        theNewsVC.didMove(toParent: self)
    }
    
    func changeViewToUnLoginProfileView(containerView: UIView){
        guard let profileVC = UIStoryboard(name: "ProfileStoryboard", bundle: nil).instantiateViewController(identifier: "UnLoginProfileView") as? UnLoginViewController else {
            return
        }
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        profileVC.willMove(toParent: self)
        containerView.addSubview(profileVC.view)
        self.addChild(profileVC)
        profileVC.didMove(toParent: self)
    }
    
    func changeViewToLoginProfileView(containerView: UIView){
        guard let profileVC = UIStoryboard(name: "ProfileStoryboard", bundle: nil).instantiateViewController(identifier: "ProfileNavigation") as? ProfileNavigationController else {
            return
        }
        
        for view in containerView.subviews{
            view.removeFromSuperview()
        }
        profileVC.willMove(toParent: self)
        containerView.addSubview(profileVC.view)
        self.addChild(profileVC)
        profileVC.didMove(toParent: self)
    }
    
}



