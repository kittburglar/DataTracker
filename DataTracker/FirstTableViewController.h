//
//  FirstTableViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstTableViewController : UITableViewController
- (IBAction)unwindToMenuViewController:(UIStoryboardSegue *)segue;
@property (strong, nonatomic) IBOutlet UILabel *amountLabel;

@end
