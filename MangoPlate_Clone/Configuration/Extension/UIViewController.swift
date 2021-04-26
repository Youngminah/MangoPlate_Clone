//
//  UIViewController.swift
//  EduTemplate - storyboard
//
//  Created by Zero Yoon on 2022/02/23.
//

import UIKit
import SnapKit
import CoreLocation

extension UIViewController {
    // MARK: 빈 화면을 눌렀을 때 키보드가 내려가도록 처리
    func dismissKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
//        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(false)
    }
    
    // MARK: 취소와 확인이 뜨는 UIAlertController
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      handler: ((UIAlertAction) -> Void)? = nil) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let actionDone = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(actionDone)
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: 커스텀 UIAction이 뜨는 UIAlertController
    func presentAlert(title: String, message: String? = nil,
                      isCancelActionIncluded: Bool = false,
                      preferredStyle style: UIAlertController.Style = .alert,
                      with actions: UIAlertAction ...) {
        self.dismissIndicator()
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { alert.addAction($0) }
        if isCancelActionIncluded {
            let actionCancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func getRootController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first
        let topController = keyWindow?.rootViewController
        return topController
    }
    
    // MARK: UIWindow의 rootViewController를 변경하여 화면전환
    func changeRootViewController(_ viewControllerToPresent: UIViewController) {
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = viewControllerToPresent
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil)
        } else {
            viewControllerToPresent.modalPresentationStyle = .overFullScreen
            self.present(viewControllerToPresent, animated: true, completion: nil)
        }
    }
    
    // MARK: 커스텀 하단 경고창
    func presentBottomAlert(message: String, target: ConstraintRelatableTarget? = nil, offset: Double? = -12) {
        let alertSuperview = UIView()
        alertSuperview.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        alertSuperview.layer.cornerRadius = 10
        alertSuperview.isHidden = true
    
        let alertLabel = UILabel()
        alertLabel.font = .NotoSans(.regular, size: 15)
        alertLabel.textColor = .white
        
        self.view.addSubview(alertSuperview)
        alertSuperview.snp.makeConstraints { make in
            make.bottom.equalTo(target ?? self.view.safeAreaLayoutGuide).offset(-12)
            make.centerX.equalToSuperview()
        }
        
        alertSuperview.addSubview(alertLabel)
        alertLabel.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.bottom.equalTo(-6)
            make.leading.equalTo(12)
            make.trailing.equalTo(-12)
        }
        
        alertLabel.text = message
        alertSuperview.alpha = 1.0
        alertSuperview.isHidden = false
        UIView.animate(
            withDuration: 2.0,
            delay: 1.0,
            options: .curveEaseIn,
            animations: { alertSuperview.alpha = 0 },
            completion: { _ in
                alertSuperview.removeFromSuperview()
            }
        )
    }
    
    // MARK: 인디케이터 표시
    func showIndicator() {
        IndicatorView.shared.show()
        IndicatorView.shared.showIndicator()
    }
    
    // MARK: 인디케이터 숨김
    @objc func dismissIndicator() {
        IndicatorView.shared.dismiss()
    }
    
    // MARK: 위도 경도를 한국주소로 바꾸기
    func translateLocationKr(currentLocation: CLLocation?){
        guard let currentLocation = currentLocation else {
            return
        }
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        let findLocation: CLLocation = CLLocation(latitude: lat, longitude: lon)
        let geoCoder: CLGeocoder = CLGeocoder()
        let local: Locale = Locale(identifier: "Ko-kr") // Korea
        geoCoder.reverseGeocodeLocation(findLocation, preferredLocale: local) { (place, error) in
            if let address: [CLPlacemark] = place {
                guard let str1 = address.last?.administrativeArea, let str2 = address.last?.locality else {
                    return
                }
                print(str1 + " " + str2)
            }
        }
    }
}
