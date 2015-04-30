//
//  ViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-20.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSArray *usageData = [self getDataCounters];
    //NSLog(@"%@", [usageData objectAtIndex:<#(NSUInteger)#>]);
    self.WIFILabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData objectAtIndex:0] floatValue] + [[usageData objectAtIndex:1] floatValue])/1000000];
    self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData objectAtIndex:2] floatValue] + [[usageData objectAtIndex:3] floatValue])/1000000];
    
    self.navigationItem.title=@"First View";
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Flip"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(flipView:)];
    self.navigationItem.rightBarButtonItem = flipButton;
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
    NSArray *usageData = [self getDataCounters];
    //NSLog(@"%@", [usageData objectAtIndex:<#(NSUInteger)#>]);
    self.WIFILabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData objectAtIndex:0] floatValue] + [[usageData objectAtIndex:1] floatValue])/1000000];
    self.WANLabel.text = [NSString stringWithFormat:@"%.01f MB", ([[usageData objectAtIndex:2] floatValue] + [[usageData objectAtIndex:3] floatValue])/1000000];
   
}

- (IBAction)flipView:(id)sender{
    NSLog(@"pressed flip button");
    [self performSegueWithIdentifier:@"SegueToNextPage" sender:self];
}

@end
