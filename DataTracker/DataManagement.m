//
//  DataManagement.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-17.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "DataManagement.h"

@implementation DataManagement

+ (DataManagement*)sharedInstance
{
    static DataManagement* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSArray *)getDataCounters
{
    BOOL   success;
    struct ifaddrs *addrs;
    const struct ifaddrs *cursor;
    const struct if_data *networkStatisc;
    
    float WiFiSent = 0;
    float WiFiReceived = 0;
    float WWANSent = 0;
    float WWANReceived = 0;
    
    NSString *name=[[NSString alloc]init];
    
    success = getifaddrs(&addrs) == 0;
    if (success)
    {
        cursor = addrs;
        while (cursor != NULL)
        {
            name=[NSString stringWithFormat:@"%s",cursor->ifa_name];
            NSLog(@"ifa_name %s == %@\n", cursor->ifa_name,name);
            // names of interfaces: en0 is WiFi ,pdp_ip0 is WWAN
            
            if (cursor->ifa_addr->sa_family == AF_LINK)
            {
                if ([name hasPrefix:@"en"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WiFiSent+=networkStatisc->ifi_obytes;
                    WiFiReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WiFiSent %f ==%d",WiFiSent,networkStatisc->ifi_obytes);
                    NSLog(@"WiFiReceived %f ==%d",WiFiReceived,networkStatisc->ifi_ibytes);
                }
                
                if ([name hasPrefix:@"pdp_ip"])
                {
                    networkStatisc = (const struct if_data *) cursor->ifa_data;
                    WWANSent+=networkStatisc->ifi_obytes;
                    WWANReceived+=networkStatisc->ifi_ibytes;
                    NSLog(@"WWANSent %f ==%d",WWANSent,networkStatisc->ifi_obytes);
                    NSLog(@"WWANReceived %f ==%d",WWANReceived,networkStatisc->ifi_ibytes);
                }
            }
            
            cursor = cursor->ifa_next;
        }
        
        freeifaddrs(addrs);
    }
    
    return [NSArray arrayWithObjects:[NSNumber numberWithInt:WiFiSent], [NSNumber numberWithInt:WiFiReceived],[NSNumber numberWithInt:WWANSent],[NSNumber numberWithInt:WWANReceived], nil];
}

- (float)calculateWAN{
    float WANUsage = 0.0;
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue] == 0) {
        WANUsage = 0.0;
    }
    else{
        [self calibrateTotalUsage];
        NSLog(@"UsageDifference is: %f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue]);
        float totalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
        WANUsage = (totalUsage - (floorf(totalUsage / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) * [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue])/1000000;
    }
    return WANUsage;
}

/*
 - (float)calculateWIFI{
 float WIFIUsage = 0.0;
 WIFIUsage = (([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue]) - (floorf(([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) * [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue])/1000000;
 return WIFIUsage;
 }
 */

-(void) calibrateTotalUsage{
    [self setUsageData:[self getDataCounters]];
    float currentTotalUsage = ([[[self usageData] objectAtIndex:2] floatValue] + [[[self usageData] objectAtIndex:3] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsageDifference"] floatValue];
    float lastTotalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    NSLog(@"Calibrating Total Usage: Current total usage is: %f and last total usage is: %f", currentTotalUsage, lastTotalUsage);
    if (currentTotalUsage < lastTotalUsage) {
        NSLog(@"Current usage is less than last time. Must calibrate!");
        float difference = lastTotalUsage - currentTotalUsage;
        [[NSUserDefaults standardUserDefaults] setFloat:difference forKey:@"totalUsageDifference"];
        currentTotalUsage = ([[[self usageData] objectAtIndex:2] floatValue] + [[[self usageData] objectAtIndex:3] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsageDifference"] floatValue];
    }
    else{
        NSLog(@"Totalusage is: %f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue]);
        [[NSUserDefaults standardUserDefaults] setFloat:currentTotalUsage forKey:@"totalUsage"];
    }
    
}

- (void)resetData{
    NSLog(@"resettingData!");
    
    [self calibrateTotalUsage];
    float totalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    [[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"CurrentUsage"];
    [[NSUserDefaults standardUserDefaults] setFloat:[[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue] - fmodf(totalUsage, [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) forKey:@"UsageDifference"];
    
}

- (float)calculatePercentage{
    float percentage = 0.0;
    float difference = 0.0;
    NSLog(@"Current usage is:%f.\nThe difference is %f/",[[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue], difference);
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue] == 0) {
        percentage = 0.0;
    }
    else{
        [self calibrateTotalUsage];
        float totalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
        percentage = (totalUsage - (floorf(totalUsage / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) * [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue];
    }
    
    NSLog(@"The percentage is: %f", percentage);
    return percentage;
}

@end

