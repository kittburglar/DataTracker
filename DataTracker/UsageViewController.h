//
//  UsageViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <ifaddrs.h>
#include <net/if_dl.h>
#import <CoreData/CoreData.h>

@interface UsageViewController : UIViewController{
    UIView *inputAccView;
    UIButton *btnMB;
    UIButton *btnGB;
    UIButton *btnDone;
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}
@property (strong, nonatomic) IBOutlet UILabel *instrLabel;
@property (strong, nonatomic) IBOutlet UITextField *usageText;
@property (nonatomic, retain) UIView *inputAccView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *dataTypeSegment;
@property (strong, nonatomic) NSDate* renewDate;
@property (assign, nonatomic) NSInteger dataPlan;
@property (assign, nonatomic) float dataAmount;

- (IBAction)nextButton:(id)sender;

#pragma mark - Core Data
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@end
