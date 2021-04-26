//
//  TableViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/17.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKUser

class SettingTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "설정뒤로가기"), style: .plain, target: self, action: #selector(cancel))
        self.tableView.separatorColor = self.tableView.backgroundColor
        self.tableView.rowHeight = 60
    }
    
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }

    //테이블 뷰 헤더 섹션의 높이 설정
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: 설정 클릭시 ( 눌러야할 cell이 많아지면 cell에 관한 배열 생성 바람 )
        if indexPath.section == 3 && indexPath.row == 0{
            self.resetLoginToken()
            self.requestKakaoLogout()
        }
    }
    
    func resetLoginToken(){
        UserDefaults.standard.removeObject(forKey: "JwtToken")
        UserDefaults.standard.removeObject(forKey: "UserId")
        JwtToken.isLogin = false
    }
    
    func requestKakaoLogout(){
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                guard let mainLoginViewController = UIStoryboard(name: "SplashStoryboard", bundle: nil).instantiateViewController(identifier: "SplashView") as? SplashViewController else{
                    return
                }
                self.changeRootViewController(mainLoginViewController)
                print("logout() success.")
            }
        }
    }

}
