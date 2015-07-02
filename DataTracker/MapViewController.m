//
//  MapViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-05-04.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "MapViewController.h"
#import "DataManagement.h"
#import <CCHMapClusterController.h>

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) CCHMapClusterController *mapClusterController;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.map.showsUserLocation=YES;
    self.map.delegate = self;
    
    
    NSArray *locations = [[NSArray alloc] initWithArray:[[DataManagement sharedInstance] locations]];
    self.mapClusterController = [[CCHMapClusterController alloc] initWithMapView:self.map];
    [self.mapClusterController addAnnotations:locations withCompletionHandler:NULL];
}

-(void)viewDidAppear:(BOOL)animated{
    
}

-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.map.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.01f;
    mapRegion.span.longitudeDelta = 0.01f;
    [self.map regionThatFits:mapRegion];
    [self.map setRegion:mapRegion animated:NO];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)accuracyChanged:(id)sender
{
    NSLog(@"segmentcontrol changed");
}

- (IBAction)enabledStateChanged:(id)sender {

}

- (IBAction)testButtonAction:(id)sender {
    NSLog(@"TEST BUTTON PRESSED");
    NSMutableArray *locations = [[NSMutableArray alloc] initWithArray:[[DataManagement sharedInstance] locations]];
    NSMutableArray *locations2 = [[NSMutableArray alloc] initWithArray:[[DataManagement sharedInstance] locations2]];
    
    for (MKPointAnnotation *annotation in locations) {
        NSLog(@"Location is: %@", annotation);
        //[self.map addAnnotation:annotation];
    }
    for (NSNumber *num in locations2) {
        NSLog(@"%@", num);
    }
    [self.mapClusterController addAnnotations:locations withCompletionHandler:NULL];
    
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
