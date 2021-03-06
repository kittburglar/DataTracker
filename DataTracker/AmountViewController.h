//
//  AmountViewController.h
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmountViewController : UIViewController{
    UIView *inputAccView;
    UIButton *btnMB;
    UIButton *btnGB;
    UIButton *btnDone;
}
@property (strong, nonatomic) IBOutlet UITextField *amountText;
@property (nonatomic, retain) UIView *inputAccView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *dataTypeSegment;
@property (strong, nonatomic) IBOutlet UILabel *instrLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButtonOutlet;
@property (strong, nonatomic) NSDate* renewDate;
@property (assign, nonatomic) NSInteger dataPlan;
@property (assign, nonatomic) float dataAmount;

- (IBAction)segmentValueChanged:(UISegmentedControl *)sender;
- (IBAction)nextButton:(id)sender;


@end
