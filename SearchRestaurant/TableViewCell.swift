//
//  TableViewCell.swift
//  SearchRestaurant
//
//  Created by Huiyuan Ren on 16/3/8.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var RestaurantPicImageView: UIImageView!
    
    @IBOutlet weak var RestaurantNameLabel: UILabel!
    
    @IBOutlet weak var Star1: UIImageView!
    @IBOutlet weak var Star2: UIImageView!
    @IBOutlet weak var Star3: UIImageView!
    @IBOutlet weak var Star4: UIImageView!
    @IBOutlet weak var Star5: UIImageView!
    
    @IBOutlet weak var RestaurantTypeLabel: UILabel!
    @IBOutlet weak var RestaurantAddressLabel: UILabel!
    
    var starArray: NSMutableArray! = []
    var imageFile: String = ""
    
    var rate = 0.0{
        didSet{
            
            //add the star imageview into the array
            starArray.removeAllObjects()
            starArray.addObject(self.Star1)
            starArray.addObject(self.Star2)
            starArray.addObject(self.Star3)
            starArray.addObject(self.Star4)
            starArray.addObject(self.Star5)
            
            for star in starArray  {
                let view = star as! UIImageView
                view.image = UIImage(named: "gray_star")
            }
            
            var i = 0
            while(rate > 0){
                let starImage = starArray[i] as! UIImageView
                if rate == 0.5{
                    
                    starImage.image = UIImage(named: "half_star")
                    
                }else {
                    starImage.image = UIImage(named: "gold_star")
                }
                rate -= 1
                i++
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        

        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
