//
//  MapViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-05-04.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "ViewController.h"
#import <ASValueTrackingSlider.h>
#import <MapKit/MapKit.h>

@interface MapViewController : ViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentAccuracy;
@property (strong, nonatomic) IBOutlet ASValueTrackingSlider *slider;
@property (strong, nonatomic) IBOutlet MKMapView *map;
@property (strong, nonatomic) IBOutlet UIView *fullView;
@property (strong, nonatomic) IBOutlet UISwitch *switchEnabled;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) NSDate *dataDate;
@property (strong, nonatomic) NSDateFormatter *dataDateFormatter;
- (IBAction)accuracyChanged:(id)sender;
- (IBAction)enabledStateChanged:(id)sender;
- (IBAction)testButtonAction:(id)sender;
- (IBAction)sliderValueChanged:(ASValueTrackingSlider *)sender;
- (IBAction)prevButton:(id)sender;
- (IBAction)nextButton:(id)sender;


@end
