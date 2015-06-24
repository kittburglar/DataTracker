//
//  HistoryViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-17.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HistoryViewController.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface HistoryViewController ()
@end

@implementation HistoryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    PNBarChart * barChart = [[PNBarChart alloc] initWithFrame:CGRectMake(0, 135.0, SCREEN_WIDTH, 200.0)];
    barChart.yLabelFormatter = ^(CGFloat yValue){
        CGFloat yValueParsed = yValue;
        NSString * labelText = [NSString stringWithFormat:@"%1.f",yValueParsed];
        return labelText;
    };
    [barChart setXLabels:@[@"SEP 1",@"SEP 2",@"SEP 3",@"SEP 4",@"SEP 5",@"SEP 6",@"SEP 7",@"SEP 8",@"SEP 9",@"SEP 10",@"SEP 11",@"SEP 12",@"SEP 13",@"SEP 14",@"SEP 15",@"SEP 16",@"SEP 17",@"SEP 18",@"SEP 19",@"SEP 20",@"SEP 21",@"SEP 22",@"SEP 23",@"SEP 24",@"SEP 25",@"SEP 26",@"SEP 27",@"SEP 28",@"SEP 29",@"SEP 30",@"SEP 31"]];
    [barChart setYValues:@[@1,  @10, @2, @6, @3,@1,  @10, @2, @6, @3,@1,  @10, @2, @6, @3,@1,  @10, @2, @6, @3,@1,  @10, @2, @6, @3,@1,  @10, @2, @6, @3,@1]];
    [barChart strokeChart];

    [self.view addSubview:barChart];
    
    }

- (void)dealloc
{
    
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
