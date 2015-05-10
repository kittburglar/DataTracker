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
    percentage = (([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) - (floorf(([[usageData2 objectAtIndex:2] floatValue] + [[usageData2 objectAtIndex:3] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) * [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) + [[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue]) / [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue];
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

@end
