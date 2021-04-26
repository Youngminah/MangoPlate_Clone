//
//  UnLoginViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/14.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class UnLoginViewController: BaseViewController {
    
    @IBOutlet var containerVew: UIView!
    @IBOutlet weak var loginButton: UIButton!
    let unLoginMenuList = [["이벤트"],["설정"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.layer.cornerRadius = 15
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    @IBAction func loginRequestTab(_ sender: UIButton) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginRequestView") as? LoginRequestViewController else{
            return
        }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: 테이블뷰 관련
extension UnLoginViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return unLoginMenuList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return unLoginMenuList[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UnLoginCell", for: indexPath) as? UnLoginViewCell else{
            return UITableViewCell()
        }
        cell.updateUI(indexPath: indexPath, unLoginMenuList: unLoginMenuList)
        return cell
    }
    
    //테이블 뷰 헤더 섹션의 높이 설정
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10.0
    }
    
    //테이블 뷰 해더 섹션 폰트, 폰트크기 정하기
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = #colorLiteral(red: 0.9635811237, green: 0.9635811237, blue: 0.9635811237, alpha: 1)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
}

class UnLoginViewCell: UITableViewCell{
    
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    func updateUI(indexPath: IndexPath, unLoginMenuList: [[String]]){
        let target = unLoginMenuList[indexPath.section][indexPath.row]
        menuImage.image = UIImage(named: "\(target)")
        menuLabel.text = target
    }
}
