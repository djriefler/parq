//
//  PQSignUpViewController.m
//  parqV1
//
//  Created by Duncan Riefler on 4/21/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kServerURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/users"] //2


#import "PQSignUpViewController.h"
#import "MapTabBarController.h"
#import "CurrentUserSingleton.h"

@interface PQSignUpViewController ()
{
    BOOL receivedFBInfo;
}
@end

@implementation PQSignUpViewController

@synthesize navController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        receivedFBInfo = NO;
    }
    return self;
}

- (void) loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    
}

// This method gives you access to a user's fb info
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    NSLog(@"1");
    if ([[CurrentUserSingleton currentUser] isUserSignedIn] == NO && receivedFBInfo == NO) {
        receivedFBInfo = YES;
        NSLog(@"2");

        // UI updates
        self.lblEmail.text = [user objectForKey:@"email"];
        
        // Prepare request for server to see if user already exists
        NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                             user.name, @"name",
                              user[@"email"], @"email",
                              user[@"id"], @"UUID", nil];
        
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

        }
        else if (error) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if ([[CurrentUserSingleton currentUser] isUserSignedIn] == NO) {
        NSError * error;
        NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        NSLog(@"%@", json);
        
        // enter their information into the Singleton
        [[CurrentUserSingleton currentUser] setUserDataFromJSON:json];
        [[CurrentUserSingleton currentUser] setUserSignedIn:YES];
        NSLog(@"%@", [[CurrentUserSingleton currentUser] UUID]);

        
        // If the user already exists, run the app normally
        if ([[json objectForKey:@"status"]  isEqual: @"existing user"]) {
            NSLog(@"%@", json);
            UIViewController *mapTabBarController = [[MapTabBarController alloc] init];
            self.navController = [[UINavigationController alloc] initWithRootViewController:mapTabBarController];
            [[UIApplication sharedApplication]delegate].window.rootViewController = navController;
        }
        
        // The user doesn't exist, onboard them
        else {
            UIViewController *mapTabBarController = [[MapTabBarController alloc] init];
            self.navController = [[UINavigationController alloc] initWithRootViewController:mapTabBarController];
            [[UIApplication sharedApplication]delegate].window.rootViewController = navController;
        }
    }
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
