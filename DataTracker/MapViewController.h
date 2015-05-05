//
//  MapViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-05-04.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController : ViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentAccuracy;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UISwitch *switchEnabled;
- (IBAction)accuracyChanged:(id)sender;
- (IBAction)enabledStateChanged:(id)sender;

@end
