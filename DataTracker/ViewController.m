//
//  ViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-20.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "ViewController.h"
#import <math.h>
#import "UIViewController+ECSlidingViewController.h"
#import "FirstTableViewController.h"

NSArray *usageData2;

@interface ViewController ()

@end

@implementation ViewController

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View loaded");
    usageData2 = [self getDataCounters];
    //NSLog(@"%@", [usageData objectAtIndex:<#(NSUInteger)#>]);
    self.WIFILabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue])/1000000];
    self.WIFILabel.textColor = UIColorFromRGB(0x4d4d4c);
    
    //self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue])/1000000];
    self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", [self calculateWAN]];
    self.WANLabel.textColor = UIColorFromRGB(0x4d4d4c);
    
    //self.navigationItem.title=@"First View";
    self.percentLabel.text = [NSString stringWithFormat:@"%f", [self calculatePercentage]];
    
    //Circular Progress Bar
    self.myProgressLabel.progressColor = UIColorFromRGB(0x4271ae);
    self.myProgressLabel.trackColor = UIColorFromRGB(0x8e908c);
    //self.myProgressLabel.progress = [self calculatePercentage];
    self.myProgressLabel.text = [NSString stringWithFormat:@"%.0f%%", [self calculatePercentage]*100];
    self.myProgressLabel.textColor = UIColorFromRGB(0x4d4d4c);
    self.myProgressLabel.trackWidth = 50;         // Defaults to 5.0
    self.myProgressLabel.progressWidth = 50;        // Defaults to 5.0
    //self.myProgressLabel.roundedCornersWidth = 40; // Defaults to 0
    
    //Animation
    self.myProgressLabel.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };
    [self.myProgressLabel setProgress:[self calculatePercentage]
                               timing:TPPropertyAnimationTimingEaseOut
                             duration:1.0
                                delay:0.0];
    
    //Map stuff
    self.locations = [[NSMutableArray alloc] init];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=kCLDistanceFilterNone;
    //self.locationManager.distanceFilter=50;
    self.locationManager.delegate = self;
    
}

- (void)viewWillAppear:(BOOL)animated{
    usageData2 = [self getDataCounters];
    
    self.WIFILabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue])/1000000];
    //self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue])/1000000];
    self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", [self calculateWAN]];
    self.percentLabel.text = [NSString stringWithFormat:@"%f", [self calculatePercentage]];
    
    //Circular Progress Bar
    //self.myProgressLabel.progress = [self calculatePercentage];
    self.myProgressLabel.text = [NSString stringWithFormat:@"%.0f%%", [self calculatePercentage]*100];
    
    //Animation
    self.myProgressLabel.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };
    [self.myProgressLabel setProgress:[self calculatePercentage]
                               timing:TPPropertyAnimationTimingEaseOut
                             duration:1.0
                                delay:0.0];
}

- (float)calculateWAN{
    float WANUsage = 0.0;
    WANUsage = (([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) - (floorf(([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) * [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue])/1000000;
    return WANUsage;
}

- (float)calculatePercentage{
    float percentage = 0.0;
    float difference = 0.0;
    //WAN mod allowed amount
    //difference =  [[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue] - fmodf(([[usageData objectAtIndex:2] floatValue] + [[usageData objectAtIndex:3] floatValue]), [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]);
    NSLog(@"Current usage is:%f.\nThe difference is %f/",[[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue], difference);
    //percentage = fmodf([[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue] + ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]), [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue] == 0) {
        percentage = 0.0;
    }
    else{
       percentage = (([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) - (floorf(([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) * [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue];
    }
    
    //percentage = fmodf(difference + ([[usageData objectAtIndex:2] floatValue] + [[usageData objectAtIndex:3] floatValue]), [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue];
    NSLog(@"The percentage is: %f", percentage);
    return percentage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)refreshButton:(id)sender {
    NSLog(@"refreshButton");
    usageData2 = [self getDataCounters];
    
    self.WIFILabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue])/1000000];
    //self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue])/1000000];
    self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", [self calculateWAN]];
    self.percentLabel.text = [NSString stringWithFormat:@"%f", [self calculatePercentage]];
    
    //Circular Progress Bar
    //self.myProgressLabel.progress = [self calculatePercentage];
    self.myProgressLabel.text = [NSString stringWithFormat:@"%.0f%%", [self calculatePercentage]*100];
    
    //Animation
    self.myProgressLabel.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };
    [self.myProgressLabel setProgress:[self calculatePercentage]
                               timing:TPPropertyAnimationTimingEaseOut
                             duration:1.0
                                delay:0.0];
}

- (IBAction)flipView:(id)sender{
    NSLog(@"pressed flip button");
    [self performSegueWithIdentifier:@"SegueToNextPage" sender:self];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    
    usageData2 = [self getDataCounters];
    float lastWanSinceUpdate = [[[NSUserDefaults standardUserDefaults] stringForKey:@"LastWanSinceUpdate"] floatValue];
    float thisWan = ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]);
    
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
    }
    
    //[[NSUserDefaults standardUserDefaults] setFloat:lastWanSinceUpdate forKey:@"LastWanSinceUpdate"];
    
    
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
