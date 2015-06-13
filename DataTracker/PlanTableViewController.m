//
//  PlanTableViewController.m
//  DataTracker
//
//  Created by kittiphong xayasane on 2015-04-30.
//  Copyright (c) 2015 Kittiphong Xayasane. All rights reserved.
//

#import "PlanTableViewController.h"
#import "ViewController.h"

@interface PlanTableViewController ()

@end

@implementation PlanTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (int section = 0; section < [self.tableView numberOfSections]; section++) {
        for (int row = 0; row < [self.tableView numberOfRowsInSection:section]; row++) {
            NSIndexPath* cellPath = [NSIndexPath indexPathForRow:row inSection:section];
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:cellPath];
            //do stuff with 'cell'
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //self.navigationItem.title = @"Plan Cycle";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 10.0f)];
    
    /*
    int dataPlan = [[[NSUserDefaults standardUserDefaults] stringForKey:@"DataPlan"] integerValue];
    NSIndexPath *path = [NSIndexPath indexPathForRow:dataPlan inSection:0];
    [self.tableView cellForRowAtIndexPath:path].accessoryType = UITableViewCellAccessoryCheckmark;
    switch (dataPlan) {
        case 0:
            NSLog(@"Stored plan was monthly");
            break;
        case 1:
            NSLog(@"Stored plan was weekly");
            break;
        case 2:
            NSLog(@"Stored plan was 30 days");
            break;
        case 3:
            NSLog(@"Stored plan was daily");
            break;
        default:
            break;
    }
     */
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
/*
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}
*/

/*
-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *oldIndex = [self.tableView indexPathForSelectedRow];
    [self.tableView cellForRowAtIndexPath:oldIndex].accessoryType = UITableViewCellAccessoryNone;
    [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    switch (indexPath.row) {
        case 0:
            NSLog(@"Monthly");
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"DataPlan"];
            break;
        case 1:
            NSLog(@"Weekly");
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"DataPlan"];
            break;
        case 2:
            NSLog(@"30 Days");
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"DataPlan"];
            break;
        case 3:
            NSLog(@"Daily");
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"DataPlan"];
            break;
        default:
            break;
    }
    return indexPath;
}
*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath   *)indexPath
{
    //[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            NSLog(@"Monthly");
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"DataPlan"];
            break;
        case 1:
            NSLog(@"Weekly");
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"DataPlan"];
            break;
        case 2:
            NSLog(@"30 Days");
            [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"DataPlan"];
            break;
        case 3:
            NSLog(@"Daily");
            [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"DataPlan"];
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



- (IBAction)testButton:(id)sender {
}




@end
