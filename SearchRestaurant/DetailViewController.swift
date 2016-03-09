//
//  DetailViewController.swift
//  SearchRestaurant
//
//  Created by Huiyuan Ren on 16/3/8.
//  Copyright © 2016年 Huiyuan Ren. All rights reserved.
//

import UIKit
import MapKit
import Spring

class DetailViewController: UIViewController, MKMapViewDelegate {

    var RestaurantName = ""
    var RestaurantType = ""
    var RestaurantAddress = ""
    var RestaurantOpenTime = ""
    var imageFile = ""
    
    @IBOutlet var DetailBackgroundView: SpringView!
    
    @IBOutlet weak var RestaurantNameLabel: UILabel!
    @IBOutlet weak var Star1: UIImageView!
    @IBOutlet weak var Star2: UIImageView!
    @IBOutlet weak var Star3: UIImageView!
    @IBOutlet weak var Star4: UIImageView!
    @IBOutlet weak var Star5: UIImageView!
    
    @IBOutlet weak var RestaurantPicImageView: UIImageView!
    @IBOutlet weak var RestaurantTypeLabel: UILabel!
    @IBOutlet weak var RestaurantAddressLabel: UILabel!
    @IBOutlet weak var RestaurantOpenTimeLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!{
        didSet{
        mapView.mapType = .Standard
        //  mapView.delegate = self
        }
    }
    
    // Map related
    @IBOutlet weak var MapButton: UIButton!
    @IBOutlet weak var CancelMapButton: UIButton!
    @IBOutlet weak var OpenInButton: UIButton!
    @IBOutlet weak var MapNameLabel: UILabel!
    
    var rate = 0.0
    let regionRadius: CLLocationDistance = 150
    var initialLocation : CLLocation!
    var starArray: NSMutableArray! = []
    
    //map related
    var frame: CGRect!
    var MapCenter : CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        RestaurantOpenTimeLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        RestaurantOpenTimeLabel.layer.borderWidth = 1
        setUpUI()
        CancelMapButton.addTarget(self, action: "cancelMap", forControlEvents: .TouchUpInside )
        OpenInButton.addTarget(self, action: "openInAppleMap", forControlEvents: .TouchUpInside )
        MapButton.enabled = false
     // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        let address = RestaurantNameLabel.text! + ", " + RestaurantAddressLabel.text! + ", New York, NY, US"
        let geocoder = CLGeocoder.init()
        geocoder.geocodeAddressString(address) { ( placemarks,  error) -> Void in
            for  aPlacemark in placemarks!
            {
                self.initialLocation = aPlacemark.location
                self.centerMapOnLocation(self.initialLocation)
                break
                
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    func setUpUI()
    {
        RestaurantNameLabel.text = RestaurantName
        MapNameLabel.text = RestaurantName
        RestaurantTypeLabel.text = RestaurantType
        RestaurantAddressLabel.text = RestaurantAddress
           RestaurantOpenTimeLabel.text = RestaurantOpenTime
        
        //set star 
        starArray.removeAllObjects()
        starArray.addObject(self.Star1)
        starArray.addObject(self.Star2)
        starArray.addObject(self.Star3)
        starArray.addObject(self.Star4)
        starArray.addObject(self.Star5)
        
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
        
        if DataStruct.imageData!.indexForKey(imageFile) != nil{
            let img : UIImage = DataStruct.imageData![imageFile]!!
            RestaurantPicImageView.image = img
            RestaurantPicImageView.contentMode =  UIViewContentMode.ScaleAspectFill
            RestaurantPicImageView.clipsToBounds =  true
            RestaurantPicImageView.image = DataStruct.imageData![imageFile]!
            
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
                let imgData = NSData(contentsOfURL: NSURL(string: self.imageFile)!)
                if(imgData != nil){
                    DataStruct.imageData!.updateValue(UIImage(data: imgData!)!, forKey: self.imageFile)
                    //print("============================")
                    dispatch_async(dispatch_get_main_queue()) {
                        if (DataStruct.imageData!.indexForKey(self.imageFile) != nil){
                            let img : UIImage = DataStruct.imageData![self.imageFile]!!
                            self.RestaurantPicImageView.image = img
                            self.RestaurantPicImageView.contentMode =  UIViewContentMode.ScaleAspectFill
                            self.RestaurantPicImageView.clipsToBounds =  true
                            self.RestaurantPicImageView.image = DataStruct.imageData![self.imageFile]!;
                        }
                    }
                }
            }
        }
        
        CancelMapButton.enabled = false
        CancelMapButton.alpha = 0
        OpenInButton.enabled = false
        OpenInButton.alpha = 0
        MapNameLabel.hidden = true
        MapNameLabel.transform = CGAffineTransformMakeTranslation(0, -MapNameLabel.frame.size.height)
    }
    @IBAction func quitButtonPressed(sender: UIButton) {
        DetailBackgroundView.animation = "fall"
        DetailBackgroundView.animate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

    @IBAction func MapButtonPressed(sender: UIButton) {
        DataStruct.ViewingMap = true
        frame = mapView.bounds
        MapButton.enabled = false
        MapCenter = CGPointMake(self.mapView.center.x,  self.mapView.center.y )
        MapNameLabel.hidden = false
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mapView.frame = CGRectMake(self.view.frame.minX, self.view.frame.minY, self.view.frame.width, self.view.frame.height)
            self.CancelMapButton.alpha = 1
            self.OpenInButton.alpha = 1
            }) { (Bool) -> Void in
                self.CancelMapButton.enabled = true
                self.OpenInButton.enabled = true
                
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.MapNameLabel.transform = CGAffineTransformMakeTranslation(0, 0)
                })
                
        }
        
    }
    
    
    func cancelMap(){
        DataStruct.ViewingMap = false
        
        MapButton.enabled = true
        CancelMapButton.enabled = false
        OpenInButton.enabled = false
        
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.mapView.center = self.MapCenter
            self.mapView.bounds = self.frame
            self.CancelMapButton.alpha = 0
            self.OpenInButton.alpha = 0
            self.MapNameLabel.transform = CGAffineTransformMakeTranslation(0, -self.MapNameLabel.frame.size.height)
            }){(Bool) -> Void in
                self.getBacktoLocation(self.initialLocation)
                
        }
        
    }
    
    func openInAppleMap(){
        let alert =
        UIAlertController(title: RestaurantName, message: RestaurantAddress, preferredStyle: UIAlertControllerStyle.ActionSheet)
        alert.addAction(UIAlertAction(title: "View in Apple Map", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            let locationPinCoord =  CLLocationCoordinate2DMake(self.initialLocation.coordinate.latitude, self.initialLocation.coordinate.longitude)
            
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(self.initialLocation.coordinate,
                self.regionRadius * 2.0, self.regionRadius * 2.0)
            
            
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(MKCoordinate: coordinateRegion.center),
                MKLaunchOptionsMapSpanKey: NSValue(MKCoordinateSpan: coordinateRegion.span)
            ]
            let placemark = MKPlacemark(coordinate: locationPinCoord, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = "\(self.RestaurantName)"
            mapItem.openInMapsWithLaunchOptions(options)
        }) )
        
        
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (UIAlertAction) -> Void in
            
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        let locationPinCoord =  CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationPinCoord
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        MapButton.enabled = true

    }
    
    func getBacktoLocation(location: CLLocation){
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
            regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        
        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView!.canShowCallout = true
        }
        else {
            anView!.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        anView?.center = CGPoint(x: 17.5,y: 35)
        //anView?.centerOffset = CGPoint(x: 17.5,y: -17.5)
        anView?.frame = CGRect(x: 50,y: 50,width: 35,height: 35)
        
        //        anView?.frame = CGRect(x: 40,y: 40,width: 40,height: 40)
        
        return anView
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
