//
//  PQSignUpViewController.m
//  parqV1
//
//  Created by Duncan Riefler on 4/21/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import "PQSignUpViewController.h"

@interface PQSignUpViewController ()

@end

@implementation PQSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

// This method gives you access to a user's fb info
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    // CREATE A NEW PARQ USER HERE
    // Create an instance of a PQUser and set their first name, last name, and email.
    

    // Onboard users if this is their first time
    // Otherwise just log in 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginView.readPermissions = @[@"basic_info", @"email"];
    self.loginView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
