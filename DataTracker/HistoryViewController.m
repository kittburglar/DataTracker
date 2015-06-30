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
#import "DataManagement.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HistoryViewController () <JBBarChartViewDataSource, JBBarChartViewDelegate>

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Navigation Bar
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIFont fontWithName:@"OpenSans" size:21],
                                                                     NSFontAttributeName, nil]];
    self.navigationItem.title=@"HISTORY";

    
    
    NSDate *today = [NSDate date];
    
    //Get usage data from core data for history data
    self.usageData = [[DataManagement sharedInstance] CDDataUsage:[self getBeginningOfWeek:today] withEndDate:[self getEndOfWeek:today]];
    
    //Get usage date for history labels
    self.usageDate = [self getDateLabelsBetween:[self getBeginningOfWeek:today] withEndDate:[self getEndOfWeek:today]];
    
    for (NSNumber *object in self.usageData) {
        NSLog(@"Number is %@", object);
    }
    
    //Chart View
    float chartSize = 200.0f;
    float chartBottomSpace = 8.0f;
    float wifiToWifiLabel = 4.0f;
    self.barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(4, [[UIScreen mainScreen] bounds].size.height - chartBottomSpace - self.wifiLabel.bounds.size.height - wifiToWifiLabel - self.wifiLabelAmount.bounds.size.height - chartBottomSpace - chartSize, SCREEN_WIDTH-4, chartSize)];
    self.barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f MB",yValueParsed];
        return labelText;
    };
    NSNumber* max = [self.usageData valueForKeyPath:@"@max.self"];
    [self.barChart setYMaxValue:10.0 * floor(([max floatValue]/10.0)+0.5)];
    self.barChart.isGradientShow = NO;
    self.barChart.isShowNumbers = NO;
    self.barChart.showChartBorder = YES;
    self.barChart.xLabelSkip = 1;
    self.barChart.yLabelSum = 8;
    self.barChart.labelFont = [UIFont fontWithName:@"OpenSans" size:10.0f];
    [self.barChart setXLabels:self.usageDate];
    [self.barChart setYValues:self.usageData];
    
    
    self.usageColor = [NSMutableArray arrayWithObjects:PNGreen,PNGreen,PNGreen,PNGreen,PNGreen,PNGreen,PNGreen, nil];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    int weekday = [comps weekday];
    self.usageColor[weekday-1] = PNBlue;
    [self.barChart setStrokeColors:self.usageColor];
    //[self.barChart setStrokeColor:[[[DataManagement sharedInstance] getColors] objectAtIndex:1]];
    
    [self.barChart strokeChart];
    [self.view addSubview:self.barChart];
    
    //Other Chart View (JBBarChartView)
    /*
    JBBarChartView *barChartView = [[JBBarChartView alloc] init];
    barChartView.frame = CGRectMake(0, 32.0 + self.titleLabel.bounds.size.height + self.navigationController.navigationBar.frame.size.height, SCREEN_WIDTH, 200.0);
    barChartView.dataSource = self;
    barChartView.delegate = self;
    [self.view addSubview:barChartView];
    
    [barChartView reloadData];
    */

    //Calendar
    self.calendar = [JTCalendar new];
    [self.calendar setMenuMonthsView:self.calendarMenuView];
    [self.calendar setContentView:self.calendarContentView];
    [self.calendar setDataSource:self];
    [self.calendar reloadData];
    self.calendar.calendarAppearance.dayTextFont = [UIFont fontWithName:@"OpenSans" size:[UIFont systemFontSize]];
    self.calendar.calendarAppearance.menuMonthTextFont = [UIFont fontWithName:@"OpenSans" size:16];
    self.calendar.calendarAppearance.weekDayTextFont = [UIFont fontWithName:@"OpenSans" size:11];
    self.calendar.calendarAppearance.isWeekMode = YES;
    [self.calendar reloadAppearance];
}

#pragma mark -JTCalendar Delegate
-(void)scrollViewDidEndDecelerating:(JTCalendarContentView *)calendar
{
    NSLog(@"scrollViewDidEndDecelerating");
}

- (BOOL)calendarHaveEvent:(JTCalendar *)calendar date:(NSDate *)date
{
    return NO;
}

- (void)calendarDidDateSelected:(JTCalendar *)calendar date:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSLog(@"Selected date: %@", date);
    //Get usage data from core data for history data
    self.usageData = [[DataManagement sharedInstance] CDDataUsage:[self getBeginningOfWeek:date] withEndDate:[self getEndOfWeek:date]];
    
    //Get usage date for history labels
    self.usageDate = [self getDateLabelsBetween:[self getBeginningOfWeek:date] withEndDate:[self getEndOfWeek:date]];
    
    NSNumber* max = [self.usageData valueForKeyPath:@"@max.self"];
    
    [self.barChart setYMaxValue:10.0 * floor(([max floatValue]/10.0)+0.5)];
    [self.barChart setXLabels:self.usageDate];
    [self.barChart setYValues:self.usageData];
    
    self.usageColor = [NSMutableArray arrayWithObjects:PNGreen,PNGreen,PNGreen,PNGreen,PNGreen,PNGreen,PNGreen, nil];
    
    NSLog(@"Today's date is %@", [NSDate date]);
    NSDate *today = [NSDate date];
    NSArray *datesArray = [self getDatesBetween:[self getBeginningOfWeek:date] withEndDate:[self getEndOfWeek:date]];
    
    if ([self dateInDateArray:today dateArray:datesArray]) {
        NSLog(@"Today is in the array");
        NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:today];
        int weekday = [comps weekday];
        self.usageColor[weekday-1] = PNBlue;
    }
    
    NSDateComponents *comps = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    int weekday = [comps weekday];
    NSLog(@"weekday is: %d", weekday);
    self.usageColor[weekday-1] = PNRed;
    for (UIColor *color in self.usageColor) {
        NSLog(@"Color is: %@", color);
    }
    [self.barChart setStrokeColors:self.usageColor];
    [self.barChart strokeChart];
    
    //Count up
    self.wanLabelAmount.format = @"%.01f MB";
    self.wanLabelAmount.animationDuration = 1.0;
    [self.wanLabelAmount countFrom:0.0f to:[self.usageData[weekday-1] floatValue]];
    
    
    return;
}

- (BOOL)dateInDateArray:(NSDate *)date dateArray:(NSArray *)dateArray{
    NSLog(@"dateInDateArray");
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    for (NSDate * dateObj in dateArray) {
        if ([gregorian isDate:date inSameDayAsDate:dateObj]) {
            return true;
        }
    }
    return false;
}

- (void)viewDidAppear:(BOOL)animated{
    [self.calendar reloadData];
}

- (void)viewDidLayoutSubviews
{
    [self.calendar repositionViews];
}

-(NSMutableArray *)getDateLabelsBetween:(NSDate *)startDate withEndDate:(NSDate *)endDate{
    
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

-(NSMutableArray *)getDatesBetween:(NSDate *)startDate withEndDate:(NSDate *)endDate{
    
    NSInteger daysBetweenDate = [[DataManagement sharedInstance] daysBetweenDate:startDate andDate:endDate];
    NSMutableArray *dateArray = [[NSMutableArray alloc] initWithCapacity:daysBetweenDate];
    NSDate *usageDate = startDate;
    NSLog(@"CDDateUsage: daysBetweenDate is: %d", daysBetweenDate);
    for (int i = 0; i < daysBetweenDate + 1; i++) {
        NSLog(@"getDatesBetween: date added is %@", usageDate);
        [dateArray addObject:usageDate];
        
        NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
        [dateComponents setDay:+1];
        usageDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:usageDate options:0];
    }
    
    return dateArray;
}


-(NSDate *)getEndOfWeek:(NSDate *)date{
    //NSDate *today = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
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
    NSDate *endOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
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


-(NSDate *)getBeginningOfWeek:(NSDate *)date{
    //NSDate *today = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
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
    NSDate *beginningOfWeek = [gregorian dateByAddingComponents:componentsToSubtract toDate:date options:0];
    
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
    //NSDate *today = [NSDate date];
    //NSArray *usageData = [[DataManagement sharedInstance] CDDataUsage:[self getBeginningOfWeek:today] withEndDate:[self getEndOfWeek:today]];
    return [[self.usageData objectAtIndex:index] floatValue]; // height of bar at index
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
