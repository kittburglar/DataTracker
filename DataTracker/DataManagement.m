//
//  DataManagement.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-17.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "DataManagement.h"

@implementation DataManagement
@synthesize managedObjectContext = _managedObjectContext;

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
    //totalUsage(past) should be less the addrUsage(unless a reboot occured)
    
    //THIS IS HOW WE CALCULATE THE WAN USAGE ON DEVICE
    NSLog(@"lastUsage is: %f", [[NSUserDefaults standardUserDefaults] floatForKey:@"lastUsage"]);
    float addrUsage = ([[[self usageData] objectAtIndex:2] floatValue] + [[[self usageData] objectAtIndex:3] floatValue]);
    
    //HERE IS WHERE WE ADD THE DIFFERENCE
    float totalUsage = [[NSUserDefaults standardUserDefaults] floatForKey:@"totalUsage"];
    float lastUsage = [[NSUserDefaults standardUserDefaults] floatForKey:@"lastUsage"];
    //CHECK IF REBOOTED!!
    if (addrUsage < lastUsage) {
        NSLog(@"WE REBOOTED MUST ADJUST!");
        //totalUsage = totalUsage + addrUsage;
        NSLog(@"totalUsage is: %f, addrUsage is: %f, lastUsage is: %f", totalUsage, addrUsage, lastUsage
              );
    }
    else{
        NSLog(@"NO REBOOT NEEDED! ADD TO TOTALUSAGE!");
        totalUsage = totalUsage + (addrUsage - lastUsage);
        NSLog(@"totalUsage is: %f, addrUsage is: %f, lastUsage is: %f", totalUsage, addrUsage, lastUsage);
    }
    
    [[NSUserDefaults standardUserDefaults] setFloat:totalUsage forKey:@"totalUsage"];
    
    //HERE IS WHERE WE SET LASTUSAGE FOR NEXT CALL
    //addrUsage = ([[[self usageData] objectAtIndex:2] floatValue] + [[[self usageData] objectAtIndex:3] floatValue]);
    [[NSUserDefaults standardUserDefaults] setFloat:addrUsage forKey:@"lastUsage"];
    NSLog(@"addrUsage is: %f", addrUsage);
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

- (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}

-(NSMutableArray *)CDDataUsage:(NSDate *)startDate withEndDate:(NSDate *)endDate{
    //core data
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appdelegate managedObjectContext];
    
    NSInteger daysBetweenDate = [self daysBetweenDate:startDate andDate:endDate];
    NSMutableArray * usageArray = [[NSMutableArray alloc] initWithCapacity:daysBetweenDate];
    
    NSLog(@"Number of days between %@ and %@ is %d", startDate, endDate, daysBetweenDate);
    
    //Form Predicate to search in core data
    NSMutableArray *partPredicates = [NSMutableArray arrayWithCapacity:daysBetweenDate];
    NSDate *usageDate = startDate;
    for (int i = 0; i < daysBetweenDate + 1; i++) {
        NSLog(@"CDDataUsage: usageDate is: %@", usageDate);
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        [dt setDateFormat:@"dd/MM/yyyy"]; // for example
        NSString *dateString = [dt stringFromDate:usageDate];
        NSDate *date = [dt dateFromString:dateString];
        NSPredicate *currentPartPredicate = [NSPredicate predicateWithFormat:@"date == %@", date];
        [partPredicates addObject:currentPartPredicate];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:+1];
        usageDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:usageDate options:0];
    }
    
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Usage" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entitydesc];
    NSPredicate *fullPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:partPredicates];
    [request setPredicate:fullPredicate];
    
    NSError *error;
    NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&error];
    
    //Find the core data objects by date
    if (matchingData.count <=0) {
        NSLog(@"No dates match in core data to fill bars.");
    }
    else{
        //Fill each mini progress bar
        for (NSManagedObjectContext *obj in matchingData) {
            NSDate *date = [obj valueForKey:@"date"];
            NSNumber *wanNum = [obj valueForKey:@"wan"];
            float wan = [wanNum floatValue]/1000000;
            NSLog(@"The usage for date %@ is %f", date, wan);
            [usageArray addObject:[NSNumber numberWithFloat:wan]];
        }
    }
    
    NSInteger dayOfTheWeek = [self daysBetweenDate:startDate andDate:[NSDate date]];
    NSLog(@"dayOfTheWeek is: %ld", (long)dayOfTheWeek);
    for (int i = dayOfTheWeek; i < daysBetweenDate; i++) {
        NSLog(@"date left");
        [usageArray addObject:[NSNumber numberWithFloat:0]];
    }
    
    return usageArray;
}



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"DataMangement: locationManager didUpdateToLocation");
    [self setUsageData:[self getDataCounters]];
    float lastWanSinceUpdate = [[[NSUserDefaults standardUserDefaults] stringForKey:@"LastWanSinceUpdate"] floatValue];
    
    [self calibrateTotalUsage];
    
    float thisWan = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    
    // Add another annotation to the map.
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = newLocation.coordinate;
    annotation.title = [NSString stringWithFormat:@"%f MB", (thisWan - lastWanSinceUpdate)/100000];
    //annotation.subtitle = @"World";
    
    if ((thisWan - lastWanSinceUpdate) > 100000) {
        NSLog(@"(thisWan - lastWanSinceUpdate) > 100000");
        //[self.map addAnnotation:annotation];
        // Also add to our map so we can remove old values later
        [self.locations addObject:annotation];
        
        [[NSUserDefaults standardUserDefaults] setFloat:thisWan forKey:@"LastWanSinceUpdate"];
        
        NSDate *today = [NSDate date];
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        [dt setDateFormat:@"dd/MM/yyyy"]; // for example
        NSString *dateString = [dt stringFromDate:today];
        NSDate *date = [dt dateFromString:dateString];
        
        //add to core data again
        AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
        managedObjectContext = [appdelegate managedObjectContext];
        
        NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Usage" inManagedObjectContext:managedObjectContext];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entitydesc];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"date == %@", date];
        [request setPredicate:predicate];
        NSError *error;
        NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&error];
        
        if (matchingData.count <=0) {
            //Add to core data
            NSLog(@"NO Items entity. Must create one.");
            //NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"" inManagedObjectContext:self.managedObjectContext];
            NSManagedObject *newUsage = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:managedObjectContext];
            
            NSDate *today = [NSDate date];
            NSDateFormatter *dt = [[NSDateFormatter alloc] init];
            [dt setDateFormat:@"dd/MM/yyyy"]; // for example
            NSString *dateString = [dt stringFromDate:today];
            NSDate *date = [dt dateFromString:dateString];
            [newUsage setValue:date forKey:@"date"];
            [newUsage setValue:[NSNumber numberWithFloat:(thisWan - lastWanSinceUpdate)] forKey:@"wan"];
            [newUsage setValue:[NSNumber numberWithFloat:0.0f] forKey:@"wifi"];
            
            NSError *error;
            [managedObjectContext save:&error];
        }
        else{
            
            NSManagedObject *obj = [[managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
            NSNumber *wan = [obj valueForKey:@"wan"];
            float value = [wan floatValue];
            wan = [NSNumber numberWithInt:value + (thisWan - lastWanSinceUpdate)];
            [obj setValue:wan forKey:@"wan"];
            NSLog(@"wan Count is: %@ for date: %@", [obj valueForKey:@"wan"], [obj valueForKey:@"date"]);
            [managedObjectContext save:&error];
        }
        
    }
    
    
    
    // Remove values if the array is too big
    while (self.locations.count > 100)
    {
        annotation = [self.locations objectAtIndex:0];
        [self.locations removeObjectAtIndex:0];
        
        // Also remove from the map
        //[self.map removeAnnotation:annotation];
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
        
        
    }
    else
    {
        NSLog(@"App is backgrounded. New location is %@", newLocation);
        NSLog(@"This wan is: %f. Last Wan is: %f. Difference is: %f", thisWan, lastWanSinceUpdate,thisWan - lastWanSinceUpdate);
    }
}

@end

