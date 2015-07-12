//
//  PlanViewController.m
//  DataTracker 
//
//  Created by kittiphong xayasane on 2015-06-13.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "PlanViewController.h"
#import "DataManagement.h"

@interface PlanViewController ()

@end

@implementation PlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Navigation Bar
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIFont fontWithName:@"OpenSans" size:21],
                                                                     NSFontAttributeName, nil]];
    self.navigationItem.title=@"PLAN CYCLE";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)nextAction:(id)sender {
}
- (IBAction)testButton:(id)sender {
    NSLog(@"DataManagment object is: %@", [[DataManagement sharedInstance] object]);
}
@end
