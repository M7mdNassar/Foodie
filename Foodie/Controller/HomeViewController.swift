//
//  HomeViewController.swift
//  Foodie
//
//  Created by Mac on 05/11/2023.
//

import UIKit

class HomeViewController: UIViewController {
    
    var restaurants = [Restaurant]()

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        restaurants.append(Restaurant.init(image: UIImage(named: "ice")!, name: "بوظه بلدنا"))
        restaurants.append(Restaurant.init(image: UIImage(named: "orjwan")!, name: "آرجوان"))
        restaurants.append(Restaurant.init(image: UIImage(named: "sanjria")!, name: "مطعم سانجريا"))
        restaurants.append(Restaurant.init(image: UIImage(named: "fantag")!, name: "فنتج كافيه"))
    }
    
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell") as! HomeTableViewCell
        let obj = restaurants[indexPath.row]
        cell.setUpCell(img: obj.image, name: obj.name)
        return cell
    }
    
    
}
extension HomeViewController: UITableViewDelegate{

    
}
