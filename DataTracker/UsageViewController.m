//
//  UsageViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "UsageViewController.h"

@interface UsageViewController ()

@end

@implementation UsageViewController
@synthesize inputAccView;
@synthesize btnDone;
@synthesize btnNext;
@synthesize btnPrev;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"Current Usage";
    self.usageText.keyboardType = UIKeyboardTypeNumberPad;
    [self.usageText becomeFirstResponder];
    [self createInputAccessoryView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)createInputAccessoryView{
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [inputAccView setBackgroundColor:[UIColor lightGrayColor]];
    [inputAccView setAlpha: 0.8];
    btnMB = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnMB setFrame: CGRectMake(0.0, 0.0, 80.0, 40.0)];
    [btnMB setTitle: @"MB" forState: UIControlStateNormal];
    [btnMB setBackgroundColor: [UIColor blueColor]];
    [btnMB addTarget: self action: @selector(MBButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    
    btnGB = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnGB setFrame: CGRectMake(85.0f, 0.0f, 80.0f, 40.0f)];
    [btnGB setTitle: @"GB" forState: UIControlStateNormal];
    [btnGB setBackgroundColor: [UIColor blueColor]];
    [btnGB addTarget: self action: @selector(GBButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(240.0, 0.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    [btnDone setBackgroundColor:[UIColor greenColor]];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccView addSubview:btnMB];
    [inputAccView addSubview:btnGB];
    [inputAccView addSubview:btnDone];
    
    [self.usageText setInputAccessoryView:inputAccView];
}

-(void)MBButtonPressed{
    NSLog(@"MBButtonPressed");
    self.unitLabel.text = @"MB";
}

-(void)GBButtonPressed{
    NSLog(@"GBButtonPressed");
    self.unitLabel.text = @"GB";
}

-(void)doneTyping{
    NSLog(@"DoneButtonPressed2");
    
    if ([self.unitLabel.text  isEqual: @"MB"]) {
        [[NSUserDefaults standardUserDefaults] setFloat:[self.usageText.text floatValue]*1000000 forKey:@"CurrentUsage"];
        
    }
    else if ([self.unitLabel.text  isEqual: @"GB"]){
        [[NSUserDefaults standardUserDefaults] setFloat:[self.usageText.text floatValue]*1000000000 forKey:@"CurrentUsage"];
    }
    
    [self.usageText resignFirstResponder];
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
