//
//  ViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-20.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"
#include <arpa/inet.h> 
#include <net/if.h> 
#include <ifaddrs.h> 
#include <net/if_dl.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import <UICountingLabel/UICountingLabel.h>
#import <PNChart.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate>{
    #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}
@property (strong, nonatomic) IBOutlet UICountingLabel *WANLabel;
@property (strong, nonatomic) IBOutlet UICountingLabel *WIFILabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (strong, nonatomic) IBOutlet KAProgressLabel *myProgressLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *otherProgressLabel;
//Mini progress bars
@property (strong, nonatomic) IBOutlet KAProgressLabel *sunProgressLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *monProgressLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *tuesProgressLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *wedProgressLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *thursProgressLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *friProgressLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *satProgressLabel;
@property (strong, nonatomic) IBOutlet UICountingLabel *dailyUnusedAmount;
@property (strong, nonatomic) IBOutlet UILabel *dailyLabel;



#pragma mark - Core Data
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
- (IBAction)refreshButton:(id)sender;
- (IBAction)fillAction:(id)sender;
- (IBAction)testButton:(id)sender;
- (void)addUsageCD;
- (void)resetData;
- (float)calculateWAN;
@end

