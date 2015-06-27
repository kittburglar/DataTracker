//
//  HistoryViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-17.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PNChart.h>
#import "JBChartView.h"
#import "JBBarChartView.h"
#import <JTCalendar.h>

@interface HistoryViewController : UIViewController<JTCalendarDataSource>
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;
@property (strong, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) JTCalendar *calendar;
@property (strong, nonatomic) IBOutlet UICountingLabel *wifiLabelAmount;
@property (strong, nonatomic) IBOutlet UILabel *wifiLabel;
@property (strong, nonatomic) IBOutlet UICountingLabel *wanLabelAmount;
@property (strong, nonatomic) IBOutlet UILabel *wanLabel;
@property (strong, nonatomic) IBOutlet PNBarChart *barChart;
@property (strong, nonatomic) NSArray *usageData;
@property (strong, nonatomic) NSArray *usageDate;
@property (strong, nonatomic) NSMutableArray *usageColor;

@end
