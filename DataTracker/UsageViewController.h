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

@interface UsageViewController : UIViewController{
    UIView *inputAccView;
    UIButton *btnMB;
    UIButton *btnGB;
    UIButton *btnDone;
}
@property (strong, nonatomic) IBOutlet UITextField *usageText;
@property (nonatomic, retain) UIView *inputAccView;
@property (nonatomic, retain) UIButton *btnDone;
@property (nonatomic, retain) UIButton *btnNext;
@property (nonatomic, retain) UIButton *btnPrev;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;
@end