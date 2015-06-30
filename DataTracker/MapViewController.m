//
//  MapViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-05-04.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "MapViewController.h"
#import "DataManagement.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    }
    for (NSNumber *num in locations2) {
        NSLog(@"%@", num);
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
