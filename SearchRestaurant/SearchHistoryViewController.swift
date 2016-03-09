//
//  SearchHistoryViewController.swift
//  SearchRestaurant
//
//  Created by Huiyuan Ren on 16/3/8.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit

class SearchHistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var beforeViewController: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.transform = CGAffineTransformMakeTranslation(-self.tableView.frame.width, 0)
        
        self.tableView.layer.shadowColor = UIColor.darkGrayColor().CGColor;//shadowColor阴影颜色
        self.tableView.layer.shadowOffset = CGSizeMake(4,0);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
        self.tableView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
        self.tableView.layer.shadowRadius = 5;//阴影半径，默认3
        self.tableView.clipsToBounds = false // 不屏蔽阴影
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(self.tableView.frame.width / 2 , 0)
            self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath)
        cell.textLabel?.text = "\(DataStruct.historyArray[indexPath.row])"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        beforeViewController.CityTextField.text = DataStruct.historyArray[indexPath.row]
        beforeViewController.SearchButton.enabled = true
        beforeViewController.SearchButton.backgroundColor = UIColor(red: 128/255, green: 0, blue: 255/255, alpha: 1)

        CancelButtonPressed(UIButton())
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return DataStruct.historyArray.count
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            DataStruct.historyArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    
    @IBAction func CancelButtonPressed(sender: UIButton) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor
            self.tableView.transform = CGAffineTransformMakeTranslation(-self.tableView.frame.width, 0)
            self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(0 , 0)
            }) { (Bool) -> Void in
                self.dismissViewControllerAnimated(false, completion: nil)
        }
    }
    var location = CGPoint (x: 0, y: 0)
    var originLocation = CGPoint (x: 0, y: 0)
    var offsetX : CGFloat = 0
    var offsetY : CGFloat = 0
    var touchInSide = false
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch : UITouch! = touches.first
        originLocation = touch.locationInView(self.view)
        touchInSide = true
        
        
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {

            let touch : UITouch! = touches.first
            self.location = touch.locationInView(self.view)
            offsetX = location.x - originLocation.x
            offsetY = location.y - originLocation.y
            if abs(offsetX) > 10 || abs(offsetY) > 10 {
                touchInSide = false
            }
        
            if offsetX > 0 {
                offsetX = 0
            }
            self.tableView.transform = CGAffineTransformMakeTranslation(offsetX, 0)
            self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(self.tableView.frame.width / 2 + offsetX / 2 , 0)
            self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3 + offsetX / self.tableView.frame.width * 0.3 ).CGColor

        
//            print(location.x + offsetX)

    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let maxOffset = self.tableView.frame.width / 4
        if(offsetX > -maxOffset && touchInSide == false){
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.tableView.transform = CGAffineTransformMakeTranslation(0, 0)
                self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(self.tableView.frame.width / 2 , 0)
                self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3).CGColor
                }) { (Bool) -> Void in
            }
        }else if (touchInSide == true){
            CancelButtonPressed(UIButton())
        }else{
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableView.transform = CGAffineTransformMakeTranslation(-self.tableView.frame.width, 0)
                self.beforeViewController.view.transform = CGAffineTransformMakeTranslation(0 , 0)
                self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor

                }) { (Bool) -> Void in
                    self.dismissViewControllerAnimated(false, completion: nil)
            }
        }
    }

    @IBAction func DeleteAllButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Clean up search history", message: "Are you sure you want to delete all search history?", preferredStyle: .Alert)
        let confirm = UIAlertAction(title: "Continue", style: .Default) { (_) -> Void in
            DataStruct.historyArray.removeAll()
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addAction(cancel)
        alertController.addAction(confirm)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
