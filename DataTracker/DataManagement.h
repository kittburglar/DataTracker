//
//  DataManagement.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-17.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface DataManagement : NSObject <CLLocationManagerDelegate>{
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, strong) NSObject* object;
@property (nonatomic, strong) NSArray* usageData;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

+ (DataManagement*)sharedInstance;
- (NSArray *)getDataCounters;
- (float)calculateWAN;
- (void)calibrateTotalUsage;
- (void)resetData;
- (float)calculatePercentage;
-(NSArray *)CDDataUsage:(NSDate *)startDate withEndDate:(NSDate *)endDate;
- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;
-(NSArray *)getColors;

@end
