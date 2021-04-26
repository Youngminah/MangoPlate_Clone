//
//  LoginProfileTableViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/13.
//

import UIKit
import Kingfisher

class LoginProfileTableViewController: UITableViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var followerLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var visitedLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    var userViewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getUserAPI()
        self.userImage.cornerCircleRadius()
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func getUserAPI(){
        self.showIndicator()
        self.userViewModel.userInfoAPI()
        self.userViewModel.didFinishFetch = {
            self.updateUI()
            self.dismissIndicator()
        }
    }
    
    func updateUI(){
        guard let data = self.userViewModel.userInfo else {
            return
        }
        self.userNameLabel.text = data.userName
        self.followerLabel.text = "\(data.follower)"
        self.followingLabel.text = "\(data.following)"
        self.reviewsLabel.text = "\(data.reviews)"
        self.visitedLabel.text = "\(data.visited)"
        self.photosLabel.text = "\(data.photos)"
        // MARK: 이미지업뎃
        guard let userImageURL = URL(string: data.userImage) else {
            return
        }
        self.userImage.kf.setImage(with: userImageURL)
    }
}

extension LoginProfileTableViewController {
    // MARK: - Table view data source
    
    //테이블 뷰 헤더 섹션의 높이 설정
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 10.0
    }

    //테이블 뷰 해더 섹션 폰트, 폰트크기 정하기
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = #colorLiteral(red: 0.9635811237, green: 0.9635811237, blue: 0.9635811237, alpha: 1)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //설정 클릭시
        if indexPath.section == 3 && indexPath.row == 0{
            guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingTableView") as? SettingTableViewController else{
                return
            }
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
