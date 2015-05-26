//
//  DateViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Start Day";
    
    self.calendar = [JTCalendar new];
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    
    
    [self.calendar reloadData];
    [self.calendarContentView setScrollEnabled:NO];
    [self.calendarMenuView setScrollEnabled:NO];
    int dataPlan = [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataPlan"] integerValue];
    switch (dataPlan) {
        case 0:
            NSLog(@"Monthly");
            self.calendar.calendarAppearance.isWeekMode = NO;
            [self.calendar reloadAppearance];
            [self.calendarContentView setScrollEnabled:NO];
            [self.calendarMenuView setScrollEnabled:NO];
            break;
            
        default:
            NSLog(@"Weekly");
            self.calendar.calendarAppearance.isWeekMode = YES;
            [self.calendar reloadAppearance];
            [self.calendarContentView setScrollEnabled:NO];
            [self.calendarMenuView setScrollEnabled:NO];
            break;
    }

}

- (void)viewDidAppear:(BOOL)animated{
    [self.calendar reloadData];
}


- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSDate *now = [NSDate date];
    switch ([now compare:date]) {
        {case NSOrderedAscending:
            NSLog(@"Date in the future");
            [[NSUserDefaults standardUserDefaults] setObject:date forKey:@"RenewDate"];
            NSLog(@"Stored date: %@", date);
            break;}
            
        {case NSOrderedDescending:
            NSLog(@"Date in the past");
            NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
            [dateComponents setMonth:1];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
            [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:@"RenewDate"];
            NSLog(@"Next month date is: %@", newDate);
            break;
        }
        {case NSOrderedSame:
            NSLog(@"Date is now");
            NSDateComponents *dateComponents =[[NSDateComponents alloc] init];
            [dateComponents setMonth:1];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDate *newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
            [[NSUserDefaults standardUserDefaults] setObject:newDate forKey:@"RenewDate"];
            NSLog(@"Next month date is: %@", newDate);
            break;}
    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
