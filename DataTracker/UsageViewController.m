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
#import "ViewController.h"
#import "AppDelegate.h"

NSArray *usageData;

@interface UsageViewController ()

@end

@implementation UsageViewController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize inputAccView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"dataPlan is:%ld, renewDate is:%@, dataAmount is:%f", (long)self.dataPlan, self.renewDate, self.dataAmount);
    ViewController *vc = [[ViewController alloc] init];
    usageData = [self getDataCounters];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Current Usage";
    //FIXME: textfield unexpected behaviour when data limit is changed
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"UnitType2"]  isEqual: @"MB"]) {
        self.usageText.text = [NSString stringWithFormat:@"%.1f", [vc calculateWAN]];
        self.dataTypeSegment.selectedSegmentIndex = 0;
        
    }
    else if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"UnitType2"]  isEqual: @"GB"]){
        //self.usageText.text = [NSString stringWithFormat:@"%.1f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue]/1000000000];
        self.usageText.text = [NSString stringWithFormat:@"%.1f", [vc calculateWAN]];
        self.dataTypeSegment.selectedSegmentIndex = 1;
    }
    
    //[self createInputAccessoryView];
    int dataPlan = [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataPlan"] integerValue];
    switch (dataPlan) {
        case 0:
            NSLog(@"Monthly");
            [self.instrLabel setText:@"Last step!\nPlease enter the amount of data already consumed this period."];
            break;
            
        case 1:
            NSLog(@"Weekly");
            [self.instrLabel setText:@"Last step!\nPlease enter the amount of data already consumed this period."];
            break;
        case 2:
            NSLog(@"30 Days");
            [self.instrLabel setText:@"Last step!\nPlease enter the amount of data already consumed this period."];
            break;
        case 3:
            NSLog(@"Daily");
            [self.instrLabel setText:@"Last step!\nPlease enter the amount of data already consumed this period."];
            break;
    }

    //core data
    AppDelegate *appdelegate = [[UIApplication sharedApplication] delegate];
    managedObjectContext = [appdelegate managedObjectContext];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.usageText resignFirstResponder];
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



- (IBAction)nextButton:(id)sender {
    //convert MB or GB to bytes
    float currentUsage = 0.0f;
    if (self.dataTypeSegment.selectedSegmentIndex == 0) {
        currentUsage = [self.usageText.text floatValue]*1000000;
        [[NSUserDefaults standardUserDefaults] setFloat:currentUsage forKey:@"CurrentUsage"];
        [[NSUserDefaults standardUserDefaults] setObject:@"MB" forKey:@"UnitType2"];
    }
    else if (self.dataTypeSegment.selectedSegmentIndex == 1){
        currentUsage = [self.usageText.text floatValue]*1000000000;
        [[NSUserDefaults standardUserDefaults] setFloat:currentUsage forKey:@"CurrentUsage"];
        [[NSUserDefaults standardUserDefaults] setObject:@"GB" forKey:@"UnitType2"];
    }
    
    //Do plan, date and amount
    [[NSUserDefaults standardUserDefaults] setInteger:self.dataPlan forKey:@"DataPlan"];
    [[NSUserDefaults standardUserDefaults] setObject:self.renewDate forKey:@"RenewDate"];
    [[NSUserDefaults standardUserDefaults] setFloat:self.dataAmount forKey:@"DataAmount"];
    
    //save total usage
    float totalUsage = [[[NSUserDefaults standardUserDefaults] stringForKey:@"totalUsage"] floatValue];
    [[NSUserDefaults standardUserDefaults] setFloat:[[[NSUserDefaults standardUserDefaults] stringForKey:@"CurrentUsage"] floatValue] - fmodf(totalUsage, [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]) forKey:@"UsageDifference"];
    
    
    
    
    
    //Update core data value for today
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dt = [[NSDateFormatter alloc] init];
    [dt setDateFormat:@"dd/MM/yyyy"];
    NSString *dateString = [dt stringFromDate:currentDate];
    NSDate *date = [dt dateFromString:dateString];
    NSPredicate *currentPartPredicate = [NSPredicate predicateWithFormat:@"date == %@", date];
    NSEntityDescription *entitydesc = [NSEntityDescription entityForName:@"Usage" inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entitydesc];
    [request setPredicate:currentPartPredicate];
    NSError *error;
    NSArray *matchingData = [managedObjectContext executeFetchRequest:request error:&error];
    if (matchingData.count <=0) {
        NSLog(@"No dates match in core data. let's create one");
        NSManagedObject *newUsage = [[NSManagedObject alloc] initWithEntity:entitydesc insertIntoManagedObjectContext:managedObjectContext];
        [newUsage setValue:date forKey:@"date"];
        [newUsage setValue:[NSNumber numberWithFloat:currentUsage] forKey:@"wan"];
        [newUsage setValue:[NSNumber numberWithFloat:0.0f] forKey:@"wifi"];
        
        NSError *error;
        [managedObjectContext save:&error];
    }
    else{
        NSLog(@"Date in core data matched to today. lets update!");
        NSManagedObject *obj = [[managedObjectContext executeFetchRequest:request error:&error] objectAtIndex:0];
        NSNumber *wan = [NSNumber numberWithInt:currentUsage];
        [obj setValue:wan forKey:@"wan"];
        NSLog(@"wan Count is: %@ for date: %@", [obj valueForKey:@"wan"], [obj valueForKey:@"date"]);
        [managedObjectContext save:&error];
    }
}
@end
