//
//  ViewController.swift
//  SearchRestaurant
//
//  Created by Huiyuan Ren on 16/3/7.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import GooglePlacesAutocomplete
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var MenuButton: UIButton!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var CityTextField: UITextField!
    @IBOutlet weak var SearchButton: UIButton!
    
    @IBOutlet weak var loadingImageView: UIImageView!
    var jsonfile : JSON!
    
    let gpaViewController = GooglePlacesAutocomplete (
        apiKey: "AIzaSyAiArhRrFcd8aymlY4vp5QlIy1o1PoHwEI",
        placeType: .Cities
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CityTextField.delegate = self
        setUpUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hidden = true
        CityTextField.text = gpaViewController.getCity()
        
        if(CityTextField.text! == ""){
            SearchButton.enabled = false
            SearchButton.backgroundColor = UIColor.grayColor()
        }else{
            SearchButton.enabled = true
            SearchButton.backgroundColor = UIColor(red: 128/255, green: 0, blue: 255/255, alpha: 1)
        }
    }
    
    override func viewDidAppear(animated: Bool) {

        
        
        // move things back to its position
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.TitleLabel.transform = CGAffineTransformMakeTranslation(0, 0)
            self.TitleLabel.alpha = 1
            
            self.CityTextField.transform = CGAffineTransformMakeTranslation(0, 0)
            self.CityTextField.alpha = 1
            
            self.SearchButton.transform = CGAffineTransformMakeTranslation(0, 0)
            self.SearchButton.alpha = 1
            
            self.MenuButton.alpha = 1

            }, completion: nil)
        

        //searchForRestaurant()
    }
    
    func setUpUI(){
        
        // set the padding for the text field
        let paddingView = UIView.init(frame: CGRectMake(0, 0, 10, 30))
        CityTextField.leftView = paddingView;
        CityTextField.leftViewMode = UITextFieldViewMode.Always
        CityTextField.attributedPlaceholder = NSAttributedString(string:"Enter the city name",
            attributes:[NSForegroundColorAttributeName: UIColor.grayColor()])
        CityTextField.layer.cornerRadius = 3
        
        // set up button
        SearchButton.layer.cornerRadius = 3
        
        //Move the items away, set alpha to 0
        TitleLabel.transform = CGAffineTransformMakeTranslation(0, -50)
        MenuButton.alpha = 0
        TitleLabel.alpha = 0
        CityTextField.alpha = 0
        
        SearchButton.transform = CGAffineTransformMakeTranslation(0, 50)
        SearchButton.alpha = 0
        
      
        
        // add the loading annimation
        loadingImageView.image = UIImage.gifWithName("loading2")
        loadingImageView.hidden = true
    }
    
    func searchForRestaurant(){

        let origin = CityTextField.text!
        let LocationArr = origin.characters.split(",").map(String.init)
        
        var state = "state"
        var city = "city"
        if(LocationArr.count > 2){
            city = LocationArr[0].stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceCharacterSet())
            DataStruct.city = city
            
            state = LocationArr[1].stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceCharacterSet())
            DataStruct.state = state
        }else{
            city = LocationArr[0].stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceCharacterSet())
            DataStruct.city = city
            state = ""
            DataStruct.state = ""
        }
        
        let Path = "http://api.v3.factual.com/t/restaurants?filters=" + ("{\"$and\":[{\"country\":{\"$eq\":\"US\"}},{\"region\":{\"$eq\":\"" + state + "\"}},{\"locality\":{\"$eq\":\"" + city + "\"}}]}&KEY=rOQigMOXzkM9jCmHf7JI4NWgvTJtuyAv2NBauylR").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())!
        print(Path)
        
        let url = NSURL(string: Path)
        Alamofire.request(.GET, url!).validate().responseJSON { response in
            switch response.result {
            case .Success:
                self.loadingImageView.hidden = true
                if let value = response.result.value {
                    self.jsonfile = JSON(value)
                }
                self.performSegueWithIdentifier("showListSegue", sender: self)
                break
            case .Failure:
                self.loadingImageView.hidden = true
                break
            }
        }
    }
    
    func PopUPSearchPage() {
        gpaViewController.placeDelegate = self
        presentViewController(gpaViewController, animated: true, completion: nil)
    }
    
    @IBAction func SearchButtonPressed(sender: UIButton) {
        loadingImageView.hidden = false
        DataStruct.historyArray.insert(CityTextField.text!, atIndex: 0)
        searchForRestaurant()
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        PopUPSearchPage()
        return false
    }
    
    @IBAction func MenuButtonPressed(sender: UIButton) {
        performSegueWithIdentifier("showMenuSegue", sender: self)
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showListSegue"){
            let des = segue.destinationViewController as! TableViewController
            des.jsonfile = self.jsonfile
        }else if segue.identifier == "showMenuSegue" {
            let des = segue.destinationViewController as! SearchHistoryViewController
            des.beforeViewController = self
        }
            
    }
    
}
//
extension ViewController : GooglePlacesAutocompleteDelegate {
    
    func placeSelected(place: Place) {
        print(place.description)
    }
    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

