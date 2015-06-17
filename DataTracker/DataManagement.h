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

@interface DataManagement : NSObject

@property (nonatomic, strong) NSObject* object;
@property (nonatomic, strong) NSArray* usageData;

+ (DataManagement*)sharedInstance;
- (NSArray *)getDataCounters;
- (float)calculateWAN;
-(void)calibrateTotalUsage;
- (void)resetData;
- (float)calculatePercentage;

@end
