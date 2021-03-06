//
//  AppDelegate.m
//  parq
//
//  Created by Duncan Riefler on 10/18/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import "AppDelegate.h"
#import <FacebookSDK/FacebookSDK.h>
#import "CurrentUserSingleton.h"
#import "MapTabBarController.h"
#import "PQSignUpViewController.h"

@implementation AppDelegate
@synthesize navController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBLoginView class];
    
    // If a user has already been logged in
//    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded ) {
    if ([[CurrentUserSingleton currentUser] isUserSignedIn] == YES) {
         // Update current user info - may need to add info from server database or app cache

        // Go straight to app
        UIViewController *mapTabBarController = [[MapTabBarController alloc] init];
        self.navController = [[UINavigationController alloc] initWithRootViewController:mapTabBarController];
        
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email"] allowLoginUI:NO completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
            // Handler for session state changes
            // Call this method EACH time the session state changes,
            //  NOT just when the session open
        }];
    }
    
    // If user has not been logged in  
    else {
        UIViewController *loginController = [[PQSignUpViewController alloc] initWithNibName:@"PQSignUpViewController" bundle:nil];
        self.navController = [[UINavigationController alloc] initWithRootViewController:loginController];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    BOOL success = [[CurrentUserSingleton currentUser] saveChanges];
    if (success) {
        NSLog(@"Saved user data");
    }
    else {
        NSLog(@"Could not save user data");
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    BOOL success = [[CurrentUserSingleton currentUser] saveChanges];
    if (success) {
        NSLog(@"Saved user data");
    }
    else {
        NSLog(@"Could not save user data");
    }
}

@end
