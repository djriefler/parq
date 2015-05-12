//
//  AddParkingSpotConfirmationPageViewController.m
//  parqV1
//
//  Created by Duncan Riefler on 5/10/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "AddParkingSpotConfirmationPageViewController.h"
#import "CurrentUserSingleton.h"

@interface AddParkingSpotConfirmationPageViewController ()
{
    NSString * address;
}
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
- (IBAction)okButtonPressed:(id)sender;
@end

@implementation AddParkingSpotConfirmationPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self addressLabel] setText:address];
    [[self phoneLabel ] setText:[[CurrentUserSingleton currentUser] phoneNumber]];
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setAddress:(NSString *)addr
{
    address = addr;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okButtonPressed:(id)sender {
    [self.delegate doneWithConfirmation];
}
@end
