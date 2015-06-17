//
//  HistoryViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-17.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JBChartView.h>
#import <JBBarChartView.h>
#import <JBLineChartView.h>

@interface HistoryViewController : UIViewController <JBChartViewDataSource, JBChartViewDelegate, JBBarChartViewDataSource, JBBarChartViewDelegate>
@property (strong, nonatomic) IBOutlet JBBarChartView *barChartView;
@property (nonatomic, strong) NSArray *chartData;

@end
