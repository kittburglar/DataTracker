//
//  UsageViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "UsageViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FirstTableViewController.h"

NSArray *usageData;

@interface UsageViewController ()

@end

@implementation UsageViewController
@synthesize inputAccView;
@synthesize btnDone;
@synthesize btnNext;
@synthesize btnPrev;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    usageData = [self getDataCounters];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Current Usage";
    self.usageText.keyboardType = UIKeyboardTypeNumberPad;
    [self.usageText becomeFirstResponder];
    
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"UnitType2"]  isEqual: @"MB"]) {
        //self.usageText.text = [NSString stringWithFormat:@"%f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue]/1000000];
        //self.usageText.text = [NSString stringWithFormat:@"%f", fmodf([[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue] + ([[usageData objectAtIndex:2] floatValue] + [[usageData objectAtIndex:3] floatValue]), [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]/1000000)];
        self.unitLabel.text = @"MB";
    }
    else if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"UnitType2"]  isEqual: @"GB"]){
        //self.usageText.text = [NSString stringWithFormat:@"%f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue]/1000000000];
        //self.usageText.text = [NSString stringWithFormat:@"%f", fmodf([[[NSUserDefaults standardUserDefaults] stringForKey:@"UsageDifference"] floatValue] + ([[usageData objectAtIndex:2] floatValue] + [[usageData objectAtIndex:3] floatValue]), [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]/1000000000)];
        self.unitLabel.text = @"GB";
    }
    
    
    [self createInputAccessoryView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createInputAccessoryView{
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [inputAccView setBackgroundColor:[UIColor whiteColor]];
    [inputAccView setAlpha: 0.8];
    btnMB = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnMB setFrame: CGRectMake(0.0, 0.0, 80.0, 40.0)];
    [btnMB setTitle: @"MB" forState: UIControlStateNormal];
    //[btnMB setBackgroundColor: [UIColor blueColor]];
    [btnMB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMB addTarget: self action: @selector(MBButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    
    btnGB = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnGB setFrame: CGRectMake(85.0f, 0.0f, 80.0f, 40.0f)];
    [btnGB setTitle: @"GB" forState: UIControlStateNormal];
    //[btnGB setBackgroundColor: [UIColor blueColor]];
    [btnGB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnGB addTarget: self action: @selector(GBButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(240.0, 0.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    //[btnDone setBackgroundColor:[UIColor greenColor]];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccView addSubview:btnMB];
    [inputAccView addSubview:btnGB];
    [inputAccView addSubview:btnDone];
    
    [self.usageText setInputAccessoryView:inputAccView];
}

-(void)MBButtonPressed{
    NSLog(@"MBButtonPressed");
    self.unitLabel.text = @"MB";
}

-(void)GBButtonPressed{
    NSLog(@"GBButtonPressed");
    self.unitLabel.text = @"GB";
}

-(void)doneTyping{
    NSLog(@"DoneButtonPressed2");
    
    if ([self.unitLabel.text  isEqual: @"MB"]) {
        [[NSUserDefaults standardUserDefaults] setFloat:[self.usageText.text floatValue]*1000000 forKey:@"CurrentUsage"];
        [[NSUserDefaults standardUserDefaults] setObject:@"MB" forKey:@"UnitType2"];
    }
    else if ([self.unitLabel.text  isEqual: @"GB"]){
        [[NSUserDefaults standardUserDefaults] setFloat:[self.usageText.text floatValue]*1000000000 forKey:@"CurrentUsage"];
        [[NSUserDefaults standardUserDefaults] setObject:@"MB" forKey:@"UnitType2"];
    }
    
    float totalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    [[NSUserDefaults standardUserDefaults] setFloat:[[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue] - fmodf(totalUsage, [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) forKey:@"UsageDifference"];
    
    
    //difference = [[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue] - fmodf(([[usageData objectAtIndex:2] floatValue] + [[usageData objectAtIndex:3] floatValue]), [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]);
    
    [self.usageText resignFirstResponder];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
