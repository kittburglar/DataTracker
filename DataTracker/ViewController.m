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
#import "AppDelegate.h"



NSArray *usageData2;

@interface ViewController ()



@end

@implementation ViewController

@synthesize managedObjectContext = _managedObjectContext;

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static void dumpAllFonts() {
    for (NSString *familyName in [UIFont familyNames]) {
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            NSLog(@"%@", fontName);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dumpAllFonts();
    
    //Check date and reset if necessary
    [self checkDate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"View loaded");
    
    //Get data usage
    usageData2 = [self getDataCounters];
    
    //Set up usage labels
    [self.WIFILabel countFrom:0 to:([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue])/1000000];
    [self.WANLabel countFrom:0 to:[self calculateWAN]];
    self.dailyUnusedAmount.format = @"%.01f MB";
    self.dailyUnusedAmount.animationDuration = 1.0;
    self.WANLabel.format = @"%.01f MB";
    self.WANLabel.animationDuration = 1.0;
    self.WIFILabel.format = @"%.01f MB";
    self.WIFILabel.animationDuration = 1.0;
    
    //Navigation Bar
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                    [UIFont fontWithName:@"OpenSans" size:21],
                                                                    NSFontAttributeName, nil]];
    self.navigationItem.title=@"MAIN";
    
    //Set up percentage label
    self.percentLabel.text = [NSString stringWithFormat:@"%f", [self calculatePercentage]];
    
    //Setup circular Progress Bars
    self.myProgressLabel.progressColor = UIColorFromRGB(0x4271ae);
    self.myProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.myProgressLabel.text = [NSString stringWithFormat:@"%.0f%%", [self calculatePercentage]*100];
    self.myProgressLabel.trackWidth = 50;         // Defaults to 5.0
    self.myProgressLabel.progressWidth = 50;        // Defaults to 5.0
    self.otherProgressLabel.progressColor = UIColorFromRGB(0xc82829);
    self.otherProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.otherProgressLabel.trackWidth = 10;
    self.otherProgressLabel.progressWidth = 10;
    self.sunProgressLabel.progressColor = UIColorFromRGB(0x718c00);
    self.sunProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.monProgressLabel.progressColor = UIColorFromRGB(0x718c00);
    self.monProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.tuesProgressLabel.progressColor = UIColorFromRGB(0x718c00);
    self.tuesProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.wedProgressLabel.progressColor = UIColorFromRGB(0x718c00);
    self.wedProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.thursProgressLabel.progressColor = UIColorFromRGB(0x718c00);
    self.thursProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.friProgressLabel.progressColor = UIColorFromRGB(0x718c00);
    self.friProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
    self.satProgressLabel.progressColor = UIColorFromRGB(0x718c00);
    self.satProgressLabel.trackColor = UIColorFromRGB(0xd6d6d6);
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
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startMonitoringSignificantLocationChanges];
    [self.locationManager startUpdatingLocation];
    
    //core data
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appdelegate managedObjectContext];
    
    [self calibrateTotalUsage];
    float thisWan = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    [[NSUserDefaults standardUserDefaults] setFloat:thisWan forKey:@"LastWanSinceUpdate"];
    [self fillWeeklyBars];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self checkDate];
    usageData2 = [self getDataCounters];
    
    [self.WIFILabel countFrom:0 to:([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue])/1000000];
    [self.WANLabel countFrom:0 to:[self calculateWAN]];
    self.percentLabel.text = [NSString stringWithFormat:@"%f", [self calculatePercentage]];
    
    self.myProgressLabel.text = [NSString stringWithFormat:@"%.0f%%", [self calculatePercentage]*100];
    
    //Animation
    self.myProgressLabel.labelVCBlock = ^(KAProgressLabel *label) {
        label.text = [NSString stringWithFormat:@"%.0f%%", (label.progress * 100)];
    };
    [self.myProgressLabel setProgress:[self calculatePercentage]
                               timing:TPPropertyAnimationTimingEaseOut
                             duration:1.0
                                delay:0.0];
    [self fillWeeklyBars];
   
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

- (void)fillWeeklyBars{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:-7];
    NSDate *sevenDaysAgo = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    NSLog(@"\ncurrentDate: %@\nseven days ago: %@", currentDate, sevenDaysAgo);
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:currentDate];
    int weekday = [comps weekday];
    
    NSLog(@"Weekday is: %d", weekday);
    
    NSMutableArray *partPredicates = [NSMutableArray arrayWithCapacity:weekday];
    //build predicate list
    for (int i = 1; i <= weekday ; i++) {
        NSLog(@"\ncurrentDate: %@", currentDate);
        NSDateFormatter *dt = [[NSDateFormatter alloc] init];
        [dt setDateFormat:@"dd/MM/yyyy"]; // for example
        NSString *dateString = [dt stringFromDate:currentDate];
        NSDate *date = [dt dateFromString:dateString];
        NSPredicate *currentPartPredicate = [NSPredicate predicateWithFormat:@"date == %@", date];
        [partPredicates addObject:currentPartPredicate];
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:-1];
        currentDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    }
    
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Usage" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entitydesc];
    NSPredicate *fullPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:partPredicates];
    [request setPredicate:fullPredicate];
    
    NSError *error;
    NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&error];
    
    NSLog(@"Weekday is: %d", weekday);
    
    
    if (matchingData.count <=0) {
        NSLog(@"No dates match in core data to fill bars.");
    }
    else{
        NSDate *date;
        int dataPlan = [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataPlan"] integerValue];
        int planDays = 0;
        
        //Fill each mini progress bar
        for (NSManagedObjectContext *obj in matchingData) {
            date = [obj valueForKey:@"date"];
            NSNumber *wanNum = [obj valueForKey:@"wan"];
            float wan = [wanNum floatValue];
            NSLog(@"Date from core data is: %@ with wan: %f", date, wan);
            NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
            NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
            int weekday = [comps weekday];
            
            //Budget changes for different plan cycles
            switch (dataPlan) {
                {case 0:
                    
                    //Find days until next billing period for daily budget suggestions
                    NSLog(@"Monthly");
                    NSDateFormatter *f = [[NSDateFormatter alloc] init];
                    [f setDateFormat:@"yyyy-MM-dd"];
                    NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
                    [dateComponents setMonth:-1];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDate *endDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"RenewDate"];
                    NSDate *startDate = [calendar dateByAddingComponents:dateComponents toDate:endDate options:0];
                    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit
                                                                        fromDate:startDate
                                                                          toDate:endDate
                                                                         options:0];
                    planDays = [components day];
                    NSLog(@"planDays is: %d", planDays);
                    break;}
                case 1:
                    NSLog(@"Weekly");
                    planDays = 7;
                    break;
                case 2:
                    NSLog(@"30 Days");
                    planDays = 30;
                    break;
                case 3:
                    NSLog(@"Daily");
                    planDays = 1;
                    break;
                default:
                    break;
            }
            
            float denominator = [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue] / planDays;
            NSLog(@"wan is: %f and denominator is: %f", wan, denominator);
            UIColor *color;
            
            //Colour progress bars according to budget usage percentage
            if (wan/denominator <= 0.50) {
                color = UIColorFromRGB(0x718c00);
            }
            else if (wan/denominator <= 0.75){
                color = UIColorFromRGB(0xeab700);
            }
            else if (wan/denominator <= 0.90){
                color = UIColorFromRGB(0xf5871f);
            }
            else {
                color = UIColorFromRGB(0xc82829);
            }
            
            NSDateComponents *comps2 = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
            int today = [comps2 weekday];
            
            //Fill each bar with animation
            switch (weekday) {
                case 1:
                    self.sunProgressLabel.progressColor = color;
                    [self.sunProgressLabel setProgress:wan/denominator
                                               timing:TPPropertyAnimationTimingEaseOut
                                             duration:1.0
                                                delay:0.0];
                    //NSLog(@"wan is: %f and denom is: %f", wan, denominator);
                    if (weekday == today) {
                        self.otherProgressLabel.progressColor = color;
                        [self.otherProgressLabel setProgress:wan/denominator
                                                    timing:TPPropertyAnimationTimingEaseOut
                                                  duration:1.0
                                                     delay:0.0];
                        //self.dailyUnusedAmount.text = [NSString stringWithFormat:@"%.1f MB", (denominator - wan)/1000000];
                        [self.dailyUnusedAmount countFrom:[self.dailyUnusedAmount currentValue] to:(denominator - wan)/1000000];
                    }
                    break;
                case 2:
                    self.monProgressLabel.progressColor = color;
                    [self.monProgressLabel setProgress:wan/denominator
                                                timing:TPPropertyAnimationTimingEaseOut
                                              duration:1.0
                                                 delay:0.0];
                    if (weekday == today) {
                        self.otherProgressLabel.progressColor = color;
                        [self.otherProgressLabel setProgress:wan/denominator
                                                    timing:TPPropertyAnimationTimingEaseOut
                                                  duration:1.0
                                                     delay:0.0];
                        //self.dailyUnusedAmount.text = [NSString stringWithFormat:@"%.1f MB", (denominator - wan)/1000000];
                        [self.dailyUnusedAmount countFrom:[self.dailyUnusedAmount currentValue] to:(denominator - wan)/1000000];
                    }
                    break;
                case 3:
                    self.tuesProgressLabel.progressColor = color;
                    [self.tuesProgressLabel setProgress:wan/denominator
                                                timing:TPPropertyAnimationTimingEaseOut
                                              duration:1.0
                                                 delay:0.0];
                    if (weekday == today) {
                        self.otherProgressLabel.progressColor = color;
                        [self.otherProgressLabel setProgress:wan/denominator
                                                    timing:TPPropertyAnimationTimingEaseOut
                                                  duration:1.0
                                                     delay:0.0];
                        //self.dailyUnusedAmount.text = [NSString stringWithFormat:@"%.1f MB", (denominator - wan)/1000000];
                        [self.dailyUnusedAmount countFrom:[self.dailyUnusedAmount currentValue] to:(denominator - wan)/1000000];
                    }
                    break;
                case 4:
                    self.wedProgressLabel.progressColor = color;
                    [self.wedProgressLabel setProgress:wan/denominator
                                                timing:TPPropertyAnimationTimingEaseOut
                                              duration:1.0
                                                 delay:0.0];
                    if (weekday == today) {
                        self.otherProgressLabel.progressColor = color;
                        [self.otherProgressLabel setProgress:wan/denominator
                                                    timing:TPPropertyAnimationTimingEaseOut
                                                  duration:1.0
                                                     delay:0.0];
                        //self.dailyUnusedAmount.text = [NSString stringWithFormat:@"%.1f MB", (denominator - wan)/1000000];
                        [self.dailyUnusedAmount countFrom:[self.dailyUnusedAmount currentValue] to:(denominator - wan)/1000000];
                    }
                    break;
                case 5:
                    self.thursProgressLabel.progressColor = color;
                    [self.thursProgressLabel setProgress:wan/denominator
                                                timing:TPPropertyAnimationTimingEaseOut
                                              duration:1.0
                                                 delay:0.0];
                    if (weekday == today) {
                        self.otherProgressLabel.progressColor = color;
                        [self.otherProgressLabel setProgress:wan/denominator
                                                    timing:TPPropertyAnimationTimingEaseOut
                                                  duration:1.0
                                                     delay:0.0];
                        //self.dailyUnusedAmount.text = [NSString stringWithFormat:@"%.1f MB", (denominator - wan)/1000000];
                        [self.dailyUnusedAmount countFrom:[self.dailyUnusedAmount currentValue] to:(denominator - wan)/1000000];
                    }
                    break;
                case 6:
                    self.friProgressLabel.progressColor = color;
                    [self.friProgressLabel setProgress:wan/denominator
                                                timing:TPPropertyAnimationTimingEaseOut
                                              duration:1.0
                                                 delay:0.0];
                    if (weekday == today) {
                        self.otherProgressLabel.progressColor = color;
                        [self.otherProgressLabel setProgress:wan/denominator
                                                    timing:TPPropertyAnimationTimingEaseOut
                                                  duration:1.0
                                                     delay:0.0];
                        //self.dailyUnusedAmount.text = [NSString stringWithFormat:@"%.1f MB", (denominator - wan)/1000000];
                        [self.dailyUnusedAmount countFrom:[self.dailyUnusedAmount currentValue] to:(denominator - wan)/1000000];
                    }
                    break;
                case 7:
                    self.satProgressLabel.progressColor = color;
                    [self.satProgressLabel setProgress:wan/denominator
                                                timing:TPPropertyAnimationTimingEaseOut
                                              duration:1.0
                                                 delay:0.0];
                    if (weekday == today) {
                        self.otherProgressLabel.progressColor = color;
                        [self.otherProgressLabel setProgress:wan/denominator
                                                      timing:TPPropertyAnimationTimingEaseOut
                                                    duration:1.0
                                                       delay:0.0];
                        //self.dailyUnusedAmount.text = [NSString stringWithFormat:@"%.1f MB", (denominator - wan)/1000000];
                        [self.dailyUnusedAmount countFrom:[self.dailyUnusedAmount currentValue] to:(denominator - wan)/1000000];
                    }
                    break;
                default:
                    break;
            }
            
        }
    }

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

- (IBAction)fillAction:(id)sender {
    [self fillWeeklyBars];
}

- (IBAction)testButton:(id)sender {
    [self resetData];
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
    
    [self calibrateTotalUsage];
    
    //float thisWan = ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]);
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

- (void)appDidBecomeActive:(NSNotification *)notification {
    NSLog(@"did become active notification");
    [self checkDate];
    
    [self.myProgressLabel setProgress:[self calculatePercentage]
                               timing:TPPropertyAnimationTimingEaseOut
                             duration:1.0
                                delay:0.0];
    [self fillWeeklyBars];
    /*
    [self.dailyUnusedAmount     countFrom:[self.dailyUnusedAmount currentValue]
                        to:(denominator - wan)/1000000];
    */
    [self.WIFILabel countFrom:[self.WIFILabel currentValue] to:([[usageData2 objectAtIndex:0] floatValue] + [[usageData2 objectAtIndex:1] floatValue])/1000000];
    [self.WANLabel countFrom:[self.WANLabel currentValue] to:[self calculateWAN]];
}

- (void)resetData{
    NSLog(@"resettingData!");
    
    [self calibrateTotalUsage];
    float totalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    [[NSUserDefaults standardUserDefaults] setFloat:0.0f forKey:@"CurrentUsage"];
    [[NSUserDefaults standardUserDefaults] setFloat:[[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue] - fmodf(totalUsage, [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) forKey:@"UsageDifference"];
    
    
    //[self calculateWAN];
}

- (void)checkDate{
    //Check date and reset if necessary
    NSDate *today = [NSDate date];
    NSDate *renewDate = [[NSUserDefaults standardUserDefaults]
                         objectForKey:@"RenewDate"];
    int dataPlan = [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataPlan"] integerValue];
    switch ([today compare:renewDate]) {
        {case NSOrderedAscending:
            NSLog(@"Launched! renewDate in the future");
            break;}
            
        {case NSOrderedDescending:
            NSLog(@"Launched! renewDate in the past");
            [self resetData];
            NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
            switch (dataPlan) {
                case 0:
                    NSLog(@"Monthly");
                    [dateComponents setMonth:1];
                    break;
                case 1:
                    NSLog(@"Weekly");
                    [dateComponents setDay:7];
                    break;
                case 2:
                    NSLog(@"30 Days");
                    [dateComponents setDay:30];
                    break;
                case 3:
                    NSLog(@"Daily");
                    [dateComponents setDay:1];
                    break;
                default:
                    break;
            }
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:today options:0];
            [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:@"RenewDate"];
            NSLog(@"Next billing date is: %@", newDate);
            break;
        }
        {case NSOrderedSame:
            NSLog(@"Launched! renewDate is now");
            [self resetData];
            NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
            switch (dataPlan) {
                case 0:
                    NSLog(@"Monthly");
                    [dateComponents setMonth:1];
                    break;
                case 1:
                    NSLog(@"Weekly");
                    [dateComponents setDay:7];
                    break;
                case 2:
                    NSLog(@"30 Days");
                    [dateComponents setDay:30];
                    break;
                case 3:
                    NSLog(@"Daily");
                    [dateComponents setDay:1];
                    break;
                default:
                    break;
            }
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:today options:0];
            [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:@"RenewDate"];
            NSLog(@"Next month date is: %@", newDate);
            break;}
    }
}

-(void) calibrateTotalUsage{
    usageData2 = [self getDataCounters];
    float currentTotalUsage = ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsageDifference"] floatValue];
    float lastTotalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    NSLog(@"Calibrating Total Usage: Current total usage is: %f and last total usage is: %f", currentTotalUsage, lastTotalUsage);
    if (currentTotalUsage < lastTotalUsage) {
        NSLog(@"Current usage is less than last time. Must calibrate!");
        float difference = lastTotalUsage - currentTotalUsage;
        [[NSUserDefaults standardUserDefaults] setFloat:difference forKey:@"totalUsageDifference"];
        currentTotalUsage = ([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsageDifference"] floatValue];
    }
    else{
        NSLog(@"Totalusage is: %f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue]);
        [[NSUserDefaults standardUserDefaults] setFloat:currentTotalUsage forKey:@"totalUsage"];
    }
    
}





@end
