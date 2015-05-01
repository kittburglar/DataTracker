//
//  ViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-20.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <arpa/inet.h> 
#include <net/if.h> 
#include <ifaddrs.h> 
#include <net/if_dl.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *WANLabel;
@property (strong, nonatomic) IBOutlet UILabel *WIFILabel;
@property (strong, nonatomic) IBOutlet UILabel *percentLabel;
- (IBAction)refreshButton:(id)sender;
@end

