//
//  ViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-20.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAProgressLabel.h"
#include <arpa/inet.h> 
#include <net/if.h> 
#include <ifaddrs.h> 
#include <net/if_dl.h>


@interface ViewController : UIViewController{
    #define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
}
@property (strong, nonatomic) IBOutlet UILabel *WANLabel;
@property (strong, nonatomic) IBOutlet UILabel *WIFILabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
@property (strong, nonatomic) IBOutlet KAProgressLabel *myProgressLabel;
- (IBAction)refreshButton:(id)sender;
@end

