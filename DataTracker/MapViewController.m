//
//  MapViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-05-04.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.locations = [[NSMutableArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)accuracyChanged:(id)sender
{
    NSLog(@"segmentcontrol changed");
    const CLLocationAccuracy accuracyValues[] = {
        kCLLocationAccuracyBestForNavigation,
        kCLLocationAccuracyBest,
        kCLLocationAccuracyNearestTenMeters,
        kCLLocationAccuracyHundredMeters,
        kCLLocationAccuracyKilometer,
        kCLLocationAccuracyThreeKilometers};
    
    self.locationManager.desiredAccuracy = accuracyValues[self.segmentAccuracy.selectedSegmentIndex];
}

- (IBAction)enabledStateChanged:(id)sender {
    if (self.switchEnabled.on)
    {
        NSLog(@"Switch is on");
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
    }
    else
    {
        [self.locationManager stopUpdatingLocation];
    }
}


#pragma mark - CLLocationManagerDelegate

/*
 *  locationManager:didUpdateToLocation:fromLocation:
 *
 *  Discussion:
 *    Invoked when a new location is available. oldLocation may be nil if there is no previous location
 *    available.
 *
 *    This method is deprecated. If locationManager:didUpdateLocations: is
 *    implemented, this method will not be called.
 */
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    // Add another annotation to the map.
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = newLocation.coordinate;
    [self.map addAnnotation:annotation];
    
    // Also add to our map so we can remove old values later
    [self.locations addObject:annotation];
    
    // Remove values if the array is too big
    while (self.locations.count > 100)
    {
        annotation = [self.locations objectAtIndex:0];
        [self.locations removeObjectAtIndex:0];
        
        // Also remove from the map
        [self.map removeAnnotation:annotation];
    }
    
    if (UIApplication.sharedApplication.applicationState == UIApplicationStateActive)
    {
        // determine the region the points span so we can update our map's zoom.
        double maxLat = -91;
        double minLat =  91;
        double maxLon = -181;
        double minLon =  181;
        
        for (MKPointAnnotation *annotation in self.locations)
        {
            CLLocationCoordinate2D coordinate = annotation.coordinate;
            
            if (coordinate.latitude > maxLat)
                maxLat = coordinate.latitude;
            if (coordinate.latitude < minLat)
                minLat = coordinate.latitude;
            
            if (coordinate.longitude > maxLon)
                maxLon = coordinate.longitude;
            if (coordinate.longitude < minLon)
                minLon = coordinate.longitude;
        }
        
        MKCoordinateRegion region;
        region.span.latitudeDelta  = (maxLat +  90) - (minLat +  90);
        region.span.longitudeDelta = (maxLon + 180) - (minLon + 180);
        
        // the center point is the average of the max and mins
        region.center.latitude  = minLat + region.span.latitudeDelta / 2;
        region.center.longitude = minLon + region.span.longitudeDelta / 2;
        
        // Set the region of the map.
        [self.map setRegion:region animated:YES];
    }
    else
    {
        NSLog(@"App is backgrounded. New location is %@", newLocation);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
