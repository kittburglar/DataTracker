//
//  AmountViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "AmountViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "FirstTableViewController.h"

@interface AmountViewController ()

@end

@implementation AmountViewController
@synthesize inputAccView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
    // Do any additional setup after loading the view.
    
    //self.navigationItem.title = @"Data Amount";
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"UnitType"]  isEqual: @"MB"]) {
        self.amountText.text = [NSString stringWithFormat:@"%.1f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]/1000000];
        self.dataTypeSegment.selectedSegmentIndex = 0;
    }
    else if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"UnitType"]  isEqual: @"GB"]){
        self.amountText.text = [NSString stringWithFormat:@"%.1f", [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataAmount"] floatValue]/1000000000];
        self.dataTypeSegment.selectedSegmentIndex = 1;
    }
    //self.amountText.text = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults]
    //                        stringForKey:@"DataAmount"]];
    //[self.amountText becomeFirstResponder];
    
    //[self createInputAccessoryView];
    
    [self checkEmpty];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)checkEmpty{
    if ([[self.amountText text] length] == 0) {
        self.nextButtonOutlet.hidden = YES;
    }
    else{
        self.nextButtonOutlet.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self checkEmpty];
    [self.amountText resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)createInputAccessoryView{
    inputAccView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 310.0, 40.0)];
    [inputAccView setBackgroundColor:[UIColor whiteColor]];
    [inputAccView setAlpha: 0.8];
    btnMB = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnMB setFrame: CGRectMake(0.0, 0.0, 80.0, 40.0)];
    [btnMB setTitle: @"MB" forState: UIControlStateNormal];
    //[btnMB setBackgroundColor: [UIColor blueColor]];
    [btnMB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnMB addTarget: self action: @selector(MBButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    
    btnGB = [UIButton buttonWithType: UIButtonTypeCustom];
    [btnGB setFrame: CGRectMake(85.0f, 0.0f, 80.0f, 40.0f)];
    [btnGB setTitle: @"GB" forState: UIControlStateNormal];
    //[btnGB setBackgroundColor: [UIColor blueColor]];
    [btnGB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnGB addTarget: self action: @selector(GBButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    
    btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnDone setFrame:CGRectMake(240.0, 0.0f, 80.0f, 40.0f)];
    [btnDone setTitle:@"Done" forState:UIControlStateNormal];
    //[btnDone setBackgroundColor:[UIColor greenColor]];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDone addTarget:self action:@selector(doneTyping) forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccView addSubview:btnMB];
    [inputAccView addSubview:btnGB];
    [inputAccView addSubview:btnDone];
    
    [self.amountText setInputAccessoryView:inputAccView];
}

-(void)doneTyping{
    NSLog(@"DoneButtonPressed");
    if (self.dataTypeSegment.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:[self.amountText.text floatValue]*1000000 forKey:@"DataAmount"];
        [[NSUserDefaults standardUserDefaults] setObject:@"MB" forKey:@"UnitType"];
    }
    else if (self.dataTypeSegment.selectedSegmentIndex == 1){
        [[NSUserDefaults standardUserDefaults] setFloat:[self.amountText.text floatValue]*1000000000 forKey:@"DataAmount"];
        [[NSUserDefaults standardUserDefaults] setObject:@"GB" forKey:@"UnitType"];
    }
    [self.amountText resignFirstResponder];
}

/*
- (IBAction)segmentValueChanged:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:[self.amountText.text floatValue]*1000000 forKey:@"DataAmount"];
        [[NSUserDefaults standardUserDefaults] setObject:@"MB" forKey:@"UnitType"];
    }
    else{
        [[NSUserDefaults standardUserDefaults] setFloat:[self.amountText.text floatValue]*1000000000 forKey:@"DataAmount"];
        [[NSUserDefaults standardUserDefaults] setObject:@"GB" forKey:@"UnitType"];
    }
}
*/
- (IBAction)nextButton:(id)sender {
    if (self.dataTypeSegment.selectedSegmentIndex == 0) {
        [[NSUserDefaults standardUserDefaults] setFloat:[self.amountText.text floatValue]*1000000 forKey:@"DataAmount"];
        [[NSUserDefaults standardUserDefaults] setObject:@"MB" forKey:@"UnitType"];
    }
    else if (self.dataTypeSegment.selectedSegmentIndex == 1){
        [[NSUserDefaults standardUserDefaults] setFloat:[self.amountText.text floatValue]*1000000000 forKey:@"DataAmount"];
        [[NSUserDefaults standardUserDefaults] setObject:@"GB" forKey:@"UnitType"];
    }
}
@end
