//
//  SwipeViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-06-10.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SwipeView.h"

@interface SwipeViewController : UIViewController <SwipeViewDataSource, SwipeViewDelegate>

@property (nonatomic, weak) IBOutlet SwipeView *swipeView;
@property (nonatomic, strong) NSMutableArray *items;
@property (strong, nonatomic) IBOutlet UIView *firstView;

@end
