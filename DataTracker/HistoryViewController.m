//
//  HistoryViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-17.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryViewController.h"
#import "DataManagement.h"
#import "JBChartView.h"
#import "JBBarChartView.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HistoryViewController () <JBBarChartViewDataSource, JBBarChartViewDelegate>

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDate *today = [NSDate date];
    
    NSArray *usageData = [[DataManagement sharedInstance] CDDataUsage:[self getBeginningOfWeek] withEndDate:[self getEndOfWeek]];
    
    NSArray *usageDate = [self getDates:[self getBeginningOfWeek] withEndDate:[self getEndOfWeek]];
    
    for (NSNumber *object in usageData) {
        NSLog(@"Number is %@", object);
    }
    
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 32.0 + self.titleLabel.bounds.size.height + self.navigationController.navigationBar.frame.size.height, SCREEN_WIDTH, 200.0)];
    barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f MB",yValueParsed];
        return labelText;
    };
    //[barChart setXLabels:@[@"JAN 20",@"JAN 21",@"JAN 22",@"JAN 23",@"JAN 24",@"JAN 25",@"JAN 26"]];
    //[barChart setYValues:@[@1,  @10, @2, @6]];
    NSNumber* max = [usageData valueForKeyPath:@"@max.self"];
    [barChart setYMaxValue:10.0 * floor(([max floatValue]/10.0)+0.5)];
    [barChart setXLabels:usageDate];
    [barChart setYValues:usageData];
    [barChart strokeChart];
    [self.view addSubview:barChart];
    
    /*
    
    JBBarChartView *barChartView = [[JBBarChartView alloc] init];
    barChartView.frame = CGRectMake(0, 32.0 + self.titleLabel.bounds.size.height + self.navigationController.navigationBar.frame.size.height, SCREEN_WIDTH, 200.0);
    barChartView.dataSource = self;
    barChartView.delegate = self;
    [self.view addSubview:barChartView];
    
    [barChartView reloadData];
    */
}


-(NSMutableArray *)getDates:(NSDate *)startDate withEndDate:(NSDate *)endDate{
    
    NSInteger daysBetweenDate = [[DataManagement sharedInstance] daysBetweenDate:startDate andDate:endDate];
    NSMutableArray *dateArray = [[NSMutableArray alloc] initWithCapacity:daysBetweenDate];
    NSDate *usageDate = startDate;
    NSLog(@"CDDateUsage: daysBetweenDate is: %d", daysBetweenDate);
    for (int i = 0; i < daysBetweenDate + 1; i++) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        
        [df setDateFormat:@"dd"];
        NSString *myDayString = [df stringFromDate:usageDate];
        
        [df setDateFormat:@"MMM"];
        NSString *myMonthString = [df stringFromDate:usageDate];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:+1];
        usageDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:usageDate options:0];
        
        NSLog(@"%@ %@", myMonthString, myDayString);
        NSString *dateString = [NSString stringWithFormat:@"%@ %@", [myMonthString uppercaseString], myDayString];
        
        [dateArray addObject:dateString];
    }
    
    return dateArray;
}

-(NSDate *)getEndOfWeek{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    /*
     Create a date components to represent the number of days to subtract
     from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so
     subtract 1 from the number
     of days to subtract from the date in question.  (If today's Sunday,
     subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */
    [componentsToSubtract setDay: 7 - ([weekdayComponents weekday] - [gregorian firstWeekday] + 1)];
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the
     original date (today).
     To normalize to midnight, extract the year, month, and day components
     and create a new date from those components.
     */
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate: endOfWeek];
    endOfWeek = [gregorian dateFromComponents: components];
    return endOfWeek;
}


-(NSDate *)getBeginningOfWeek{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
    /*
     Create a date components to represent the number of days to subtract
     from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so
     subtract 1 from the number
     of days to subtract from the date in question.  (If today's Sunday,
     subtract 0 days.)
     */
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    /* Substract [gregorian firstWeekday] to handle first day of the week being something else than Sunday */
    [componentsToSubtract setDay: - ([weekdayComponents weekday] - [gregorian firstWeekday])];
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:today options:0];
    
    /*
     Optional step:
     beginningOfWeek now has the same hour, minute, and second as the
     original date (today).
     To normalize to midnight, extract the year, month, and day components
     and create a new date from those components.
     */
    NSDateComponents *components = [gregorian components: (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit)
                                                fromDate: beginningOfWeek];
    beginningOfWeek = [gregorian dateFromComponents: components];
    return beginningOfWeek;
}

- (void)dealloc
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -JBCHARTVIEW
- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return 7; // number of bars in chart
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    NSArray *usageData = [[DataManagement sharedInstance] CDDataUsage:[self getBeginningOfWeek] withEndDate:[self getEndOfWeek]];
    return [[usageData objectAtIndex:index] floatValue]; // height of bar at index
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
