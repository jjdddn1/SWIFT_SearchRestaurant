//
//  TableViewController.swift
//  SearchRestaurant
//
//  Created by Huiyuan Ren on 16/3/8.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import SwiftyJSON
import MapKit


class TableViewController: UITableViewController {
    var jsonfile : JSON!
    let picUrlBase = "http://admin.neurodining.com/images/gallery/"
    var picArray: [String] = ["screen_shot_20150805_at_4.59.40_pm.png",
                            "screen_shot_20150807_at_3.02.11_pm.png",
                            "screen_shot_20151020_at_12.57.19_pm.png",
                            "screen_shot_20150806_at_6.35.23_pm.png",
                            "1445361952screen_shot_20151020_at_1.19.04_pm.png",
                            "screen_shot_20151020_at_2.15.09_pm.png",
                            "ample2.jpg",
                            "wangsa.jpg",
                            "1445285252screen_shot_20151019_at_3.57.39_pm.png",
                            "screen_shot_20150819_at_4.33.32_pm.png",
                            "screen_shot_20150806_at_4.54.43_pm.png",
                            "14468379831.jpg",
                            "beautique/beautique_2.png.jpg",
                            "harlem_shake_a.jpg",
                            "screen_shot_20151021_at_11.57.56_am_2.jpg",
                            "capture_decran_20160224_a_15.23.16.jpg",
                            "screen_shot_20151109_at_2.00.18_pm.png"
        
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = false
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let image = UIImage(named: "wallpaper-1714888")
        let ImageView: UIImageView = UIImageView.init(image: image)
        ImageView.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)
        self.tableView.backgroundView = ImageView;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return jsonfile["response"]["data"].count
    }
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return 287
//    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableViewCell", forIndexPath: indexPath) as! TableViewCell
        cell.RestaurantPicImageView.image = UIImage(named:"Unknown.png")
        cell.RestaurantAddressLabel.text = self.jsonfile["response"]["data"][indexPath.row]["address"].string! + ", " + DataStruct.city + ", " + DataStruct.state
        cell.RestaurantNameLabel.text = self.jsonfile["response"]["data"][indexPath.row]["name"].string!
        cell.rate = self.jsonfile["response"]["data"][indexPath.row]["rating"].double!

        if self.jsonfile["response"]["data"][indexPath.row]["cuisine"] != nil {
            cell.RestaurantTypeLabel.text = self.jsonfile["response"]["data"][indexPath.row]["cuisine"].arrayObject![0] as? String
        }
        cell.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)

        let imageFile = picUrlBase + picArray[indexPath.row % 17]
        cell.imageFile = imageFile
        if DataStruct.imageData!.indexForKey(imageFile) != nil{
            let img : UIImage = DataStruct.imageData![imageFile]!!
            cell.RestaurantPicImageView.image = img
            cell.RestaurantPicImageView.contentMode =  UIViewContentMode.ScaleAspectFill
            cell.RestaurantPicImageView.clipsToBounds =  true
            cell.RestaurantPicImageView.image = DataStruct.imageData![imageFile]!
            
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                let imgData = NSData(contentsOfURL: NSURL(string: imageFile)!)
                if(imgData != nil){
                    DataStruct.imageData!.updateValue(UIImage(data: imgData!)!, forKey: imageFile)
                    //print("============================")
                    dispatch_async(dispatch_get_main_queue()) {
                        if (DataStruct.imageData!.indexForKey(cell.imageFile) != nil){
                            let img : UIImage = DataStruct.imageData![imageFile]!!
                            cell.RestaurantPicImageView.image = img
                            cell.RestaurantPicImageView.contentMode =  UIViewContentMode.ScaleAspectFill
                            cell.RestaurantPicImageView.clipsToBounds =  true
                            cell.RestaurantPicImageView.image = DataStruct.imageData![cell.imageFile]!;
                        }
                    }
                }
            }
        }
        
        // Configure the cell...

        return cell
    }

    
    var currentIndex = 0
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath.row
        performSegueWithIdentifier("showDetailSegue", sender: self)
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailSegue" {
            let des = segue.destinationViewController as! DetailViewController
            
            let longitude = self.jsonfile["response"]["data"][currentIndex]["longitude"].double!
            let latitude = self.jsonfile["response"]["data"][currentIndex]["latitude"].double!
            let cor = CLLocation(latitude: latitude, longitude: longitude)
            
            des.initialLocation = cor
            
            des.RestaurantAddress =
                self.jsonfile["response"]["data"][currentIndex]["address"].string! + ", " + DataStruct.city + ", " + DataStruct.state
            des.RestaurantName = self.jsonfile["response"]["data"][currentIndex]["name"].string!
            des.rate = self.jsonfile["response"]["data"][currentIndex]["rating"].double!
            
            if self.jsonfile["response"]["data"][currentIndex]["cuisine"] != nil {
                des.RestaurantType = self.jsonfile["response"]["data"][currentIndex]["cuisine"].arrayObject![0] as! String
            }
            
            
            
            des.RestaurantOpenTime = createOpenTime()
//            "Monday: 10:00 - 12:00 \nTuesday: 10:00 - 12:00 \nWendsday: 10:00 - 12:00 \nThursday: 10:00 - 12:00 \nFriday: 10:00 - 12:00 \nSaturday: 10:00 - 12:00 \nSunday: 10:00 - 12:00"
            des.imageFile = picUrlBase + picArray[currentIndex % 17]

        }
        
    }
    
    func createOpenTime() -> String{
        var openTimeBase = ""
        
        //Add Monday's open time
        
        openTimeBase += "Monday: "
        if(self.jsonfile["response"]["data"][currentIndex]["hours"]["monday"] != nil){
            for var i = 0; i < self.jsonfile["response"]["data"][currentIndex]["hours"]["monday"].array!.count; i++ {
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["monday"].array![i].arrayObject![0] as! String)
                openTimeBase +=  " - "
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["monday"].array![i].arrayObject![1] as! String)
                if(i != self.jsonfile["response"]["data"][currentIndex]["hours"]["monday"].array!.count - 1){
                    openTimeBase += ", "
                }
            }
        }else{
            openTimeBase += "Close"
        }
        openTimeBase += "\n"
        
        //Add Tuesday's open time
        openTimeBase += "Tuesday: "
        if(self.jsonfile["response"]["data"][currentIndex]["hours"]["tuesday"] != nil){
            for var i = 0; i < self.jsonfile["response"]["data"][currentIndex]["hours"]["tuesday"].array!.count; i++ {
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["tuesday"].array![i].arrayObject![0] as! String)
                openTimeBase +=  " - "
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["tuesday"].array![i].arrayObject![1] as! String)
                if(i != self.jsonfile["response"]["data"][currentIndex]["hours"]["tuesday"].array!.count - 1){
                    openTimeBase += ", "
                }
            }
        }else{
            openTimeBase += "Close"
        }
        openTimeBase += "\n"
        
        //Add Wenesday's open time
        openTimeBase += "Wednesday: "
        if(self.jsonfile["response"]["data"][currentIndex]["hours"]["wednesday"] != nil){
            for var i = 0; i < self.jsonfile["response"]["data"][currentIndex]["hours"]["wednesday"].array!.count; i++ {
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["wednesday"].array![i].arrayObject![0] as! String)
                openTimeBase +=  " - "
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["wednesday"].array![i].arrayObject![1] as! String)
                if(i != self.jsonfile["response"]["data"][currentIndex]["hours"]["wednesday"].array!.count - 1){
                    openTimeBase += ", "
                }
            }
        }else{
            openTimeBase += "Close"
        }
        openTimeBase += "\n"
        
        //Add Thursday's open time
        openTimeBase += "Thursday: "
        if(self.jsonfile["response"]["data"][currentIndex]["hours"]["thursday"] != nil){
            for var i = 0; i < self.jsonfile["response"]["data"][currentIndex]["hours"]["thursday"].array!.count; i++ {
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["thursday"].array![i].arrayObject![0] as! String)
                openTimeBase +=  " - "
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["thursday"].array![i].arrayObject![1] as! String)
                if(i != self.jsonfile["response"]["data"][currentIndex]["hours"]["thursday"].array!.count - 1){
                    openTimeBase += ", "
                }
            }
        }else{
            openTimeBase += "Close"
        }
        openTimeBase += "\n"
        
        //Add Friday's open time
        openTimeBase += "Friday: "
        if(self.jsonfile["response"]["data"][currentIndex]["hours"]["friday"] != nil){
            for var i = 0; i < self.jsonfile["response"]["data"][currentIndex]["hours"]["friday"].array!.count; i++ {
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["friday"].array![i].arrayObject![0] as! String)
                openTimeBase +=  " - "
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["friday"].array![i].arrayObject![1] as! String)
                if(i != self.jsonfile["response"]["data"][currentIndex]["hours"]["friday"].array!.count - 1){
                    openTimeBase += ", "
                }
            }
        }else{
            openTimeBase += "Close"
        }
        openTimeBase += "\n"
        
        //Add Saturday's open time
        openTimeBase += "Saturday: "
        if(self.jsonfile["response"]["data"][currentIndex]["hours"]["saturday"] != nil){

            for var i = 0; i < self.jsonfile["response"]["data"][currentIndex]["hours"]["saturday"].array!.count; i++ {
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["saturday"].array![i].arrayObject![0] as! String)
                openTimeBase +=  " - "
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["saturday"].array![i].arrayObject![1] as! String)
                if(i != self.jsonfile["response"]["data"][currentIndex]["hours"]["saturday"].array!.count - 1){
                    openTimeBase += ", "
                }
            }
        }else{
            openTimeBase += "Close"
        }
        openTimeBase += "\n"
        
        //Add Sunday's open time
        openTimeBase += "Sunday: "
        if(self.jsonfile["response"]["data"][currentIndex]["hours"]["sunday"] != nil){
            for var i = 0; i < self.jsonfile["response"]["data"][currentIndex]["hours"]["sunday"].array!.count; i++ {
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["sunday"].array![i].arrayObject![0] as! String)
                openTimeBase +=  " - "
                openTimeBase += (self.jsonfile["response"]["data"][currentIndex]["hours"]["sunday"].array![i].arrayObject![1] as! String)
                if(i != self.jsonfile["response"]["data"][currentIndex]["hours"]["sunday"].array!.count - 1){
                    openTimeBase += ", "
                }
            }
        }else{
            openTimeBase += "Close"
        }
        return openTimeBase
    }


}
