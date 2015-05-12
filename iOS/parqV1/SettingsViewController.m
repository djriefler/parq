//
//  SettingsViewController.m
//  parqV1
//
//  Created by Christopher Lee on 4/18/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "SettingsViewController.h"
#import "CurrentUserSingleton.h"
#import "EditViewController.h"




@interface SettingsViewController ()

@end

@implementation SettingsViewController

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return indexPath.row <= 1;
//}

-(void) viewDidAppear:(BOOL)animated
{
    [self.view setNeedsDisplay];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//     self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    
    if (self)
    {
        
    }
    return self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if (!cell) {
        if (indexPath.row < 2)
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleValue2 reuseIdentifier: cellIdentifier];
        else
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: cellIdentifier];

    }
    

    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Name";
            cell.detailTextLabel.text = [[CurrentUserSingleton currentUser] name];
            //cell.detailTextLabel.text = @"Chris";

            break;
        case 1:
            cell.textLabel.text = @"Email";
            cell.detailTextLabel.text = [[CurrentUserSingleton currentUser] email];
            //cell.detailTextLabel.text = @"chris@gmail.com";
            break;
            
        case 2:
            cell.textLabel.text = @"Send Feedback";
            //cell.detailTextLabel.text = @"";
            
            break;
        case 3:
            cell.textLabel.text = @"Privacy Policy";
            //cell.detailTextLabel.text = @"";
            break;
        case 4:
            cell.textLabel.text = @"Sign Out";
            //cell.detailTextLabel.text = @"";
            break;

        default:
            break;
    }
    
    return cell;
    
}


// Tap on table Row
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath
{
    if (indexPath.row <= 1)
    {
        //open the editviewcontroller
        EditViewController * vc = [[EditViewController alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
        vc.delegate = self;
        
        if (indexPath.row == 0)
        {
            [vc setTitleText:@"Name"];
        }
        else
        {
            [vc setTitleText:@"Email"];
        }

    }
    
    if (indexPath.row == 2)
    {
        //handle feedback form
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *composeViewController = [[MFMailComposeViewController alloc] initWithNibName:nil bundle:nil];
            [composeViewController setMailComposeDelegate:self];
            [composeViewController setToRecipients:@[@"parqfeedback@gmail.com"]];
            [composeViewController setSubject:@"Parq Feedback"];
            [self presentViewController:composeViewController animated:YES completion:nil];
        }
        
        if (indexPath.row == 3)
        {
            //privacy policy
        }
        
        if (indexPath.row == 4)
        {
            //sign out
        }
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    //Add an alert in case of failure
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) doneEditing
{
    [self.tableView reloadData];
    //talk to server and update it in model call
    [[CurrentUserSingleton currentUser] updateServer];

    
}



//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}


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
