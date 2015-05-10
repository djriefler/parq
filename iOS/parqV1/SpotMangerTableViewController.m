//
//  SpotMangerTableViewController.m
//  parqV1
//
//  Created by Duncan Riefler on 4/18/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "SpotMangerTableViewController.h"
#import "CurrentUserSingleton.h"
#import "ReserveTableViewCell.h"
#import "OwnedTableViewCell.h"

@interface SpotMangerTableViewController ()

@end

@implementation SpotMangerTableViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReserveTableViewCell" bundle:nil] forCellReuseIdentifier:@"ReservedCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"OwnedTableViewCell" bundle:nil] forCellReuseIdentifier:@"OwnedCell"];
//    [self.tableView registerClass: [ReserveTableViewCell class] forCellReuseIdentifier:@"ReservedCell"];
//    [self.tableView registerClass: [OwnedTableViewCell class] forCellReuseIdentifier:@"OwnedCell"];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.sectionFooterHeight = 0.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    
    // Section 0 represents reserved spots
    if (section == 0) {
        return 4;
//        return [[[CurrentUserSingleton currentUser] reservedParkingSpots] count];
    }
    
    // Section 1 represents owned spots
    else if (section == 1) {
        return 3;
//        return [[[CurrentUserSingleton currentUser] ownedParkingSpots] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellType = indexPath.section;
    
    NSString * reservedCellIdentifier = @"ReservedCell";
    NSString * ownedCellIdentifier = @"OwnedCell";

    // Reserved Spot
    if (cellType == 0) {
        ReserveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reservedCellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[ReserveTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reservedCellIdentifier];
        }
        return cell;
    }
    
    // Owned Spot
    else if (cellType == 1) {
        OwnedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ownedCellIdentifier forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[OwnedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ownedCellIdentifier];
        }
        return cell;
    }
    
    return nil;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Reserved Spot
    if (indexPath.section == 0) {
        return 200;
    }
    if (indexPath.section == 1) {
        return 200;
    }
    return 0;
}

#pragma mark - Section Headers

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 20)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    [view setBackgroundColor:[UIColor colorWithRed:15.0/255.0 green:223.0/255.0f blue:221.0/255.0f alpha:1.0f]];;

    if (section == 0) {
        [label setText:@"Reserved Spots"];
        [label setFrame:CGRectMake(0, 5, tableView.frame.size.width, 20)];
    }
    else if (section == 1) {
        [label setText:@"Owned Spots"];
        [label setFrame:CGRectMake(0, 5, tableView.frame.size.width, 20)];

    }
    [view addSubview:label];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}


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

@end
