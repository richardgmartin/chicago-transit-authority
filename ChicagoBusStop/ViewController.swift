//
//  ViewController.swift
//  ChicagoBusStop
//
//  Created by Richard Martin on 2016-02-02.
//  Copyright © 2016 Richard Martin. All rights reserved.
//

import UIKit
import MapKit
var busStopObjects = [Busstop]()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var busMapView: MKMapView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var busStopTableView: UITableView!
    
    var busDictionaryArray = [NSDictionary]()
    var annotations = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. set chicago as the region
        
        let chicagoLatitude:CLLocationDegrees = 41.8937362
        let chicagoLongitude:CLLocationDegrees = -87.6375008
        let chicagoLatDelta:CLLocationDegrees = 0.5
        let chicagoLongDelta:CLLocationDegrees = 0.5
        let span:MKCoordinateSpan = MKCoordinateSpanMake(chicagoLatDelta, chicagoLongDelta)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(chicagoLatitude, chicagoLongitude)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        self.busMapView.setRegion(region, animated: true)

        // MARK: Import CTA JSON file and populate busStopObjects array
        
        let url = NSURL(string: "https://s3.amazonaws.com/mmios8week/bus.json")
        
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithURL(url!) { (data, response, error) -> Void in
            do{
                let ctaBusStopsDict = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                
                self.busDictionaryArray = ctaBusStopsDict.objectForKey("row") as! [NSDictionary]
    
                for dict: NSDictionary in self.busDictionaryArray {
                    let busStopObject: Busstop = Busstop(busStopDictionary: dict)
                    busStopObjects.append(busStopObject)
                }
                
            }
            catch let error as NSError{
                print("JSON Error: \(error.localizedDescription)")
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.busStopTableView.reloadData()
            })
            
            // 2. assign pins to map to represent each cta bus stop
            
            for busStop:Busstop in busStopObjects {
                self.dropPinForLocation(busStop)
            }
            
        }
        task.resume()
    }
    
    // MARK: drop pin for each CTA bus stop
    

    func dropPinForLocation(busStop: Busstop) {
        
        let annotation = MKPointAnnotation()
        let pin = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        annotation.coordinate = CLLocationCoordinate2DMake(busStop.latitude, busStop.longitude)
        annotation.title = busStop.stopName
        annotation.subtitle = busStop.routes
        busMapView.addAnnotation(annotation)
        self.annotations.append(annotation)
        pin.canShowCallout = true
    }
    
    // MARK: Segment selector logic
    
    @IBAction func segmentedControlChanged(sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            busStopTableView.hidden = false
            busMapView.hidden = true
        } else {
            busStopTableView.hidden = true
            busMapView.hidden = false
            
        }
    }
    
    // MARK: tableView logic
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return busDictionaryArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CellID")!
        let busStop = busStopObjects[indexPath.row]
        cell.textLabel?.text = busStop.stopName
        cell.detailTextLabel!.text = busStop.routes
        
        return cell
        
    }

}

