//
//  DateViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

@interface DateViewController : UIViewController<JTCalendarDataSource>
@property (strong, nonatomic) IBOutlet JTCalendarMenuView *calendarMenuView;
@property (strong, nonatomic) IBOutlet JTCalendarContentView *calendarContentView;

@property (strong, nonatomic) IBOutlet UIButton *nextButtonOutlet;
@property (strong, nonatomic) JTCalendar *calendar;
- (IBAction)backButton:(id)sender;
- (IBAction)nextButton:(id)sender;
@end
