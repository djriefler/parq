//
//  PQSignUpViewController.m
//  parqV1
//
//  Created by Duncan Riefler on 4/21/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#define kServerURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/users"] //2


#import "PQSignUpViewController.h"
#import "MapViewController.h"
#import "PQUser.h"

@interface PQSignUpViewController ()
@end

@implementation PQSignUpViewController

@synthesize currentUser, navController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        currentUser = NULL;
    }
    return self;
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

// This method gives you access to a user's fb info
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    if (currentUser == NULL) {
        self.lblEmail.text = [user objectForKey:@"email"];
        NSNumber * rating = [NSNumber numberWithFloat:5.0];
        NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                             user.name, @"name",
                              user[@"email"], @"email",
                              rating, @"rating",
                              user[@"id"], @"UUID", nil];
        NSLog(@"%@", user[@"objectID"]);
        currentUser = user;
        NSError *error;
        
        // Convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        // Send request to server
        if (jsonData) {
            // Create request
            NSString *postLength = [NSString stringWithFormat:@"%d", [jsonData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kServerURL];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:jsonData];
            
            // Send request
            [NSURLConnection connectionWithRequest:request delegate:self];
            NSLog(@"request sent");

            // Open map
            UIViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
            self.navController = [[UINavigationController alloc] initWithRootViewController:mapViewController];

            [[UIApplication sharedApplication]delegate].window.rootViewController = navController;
        }
        else if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
    
    // Go to main map view
  

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
