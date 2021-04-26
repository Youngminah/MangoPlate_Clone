//
//  EATDealViewController.swift
//  MangoPlate_Clone
//
//  Created by meng on 2021/03/22.
//

import UIKit

class EATDealViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

}


extension EATDealViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EATDealCell", for: indexPath) as? EATDealCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
}
