//
//  MapTabBarController.m
//  parqV1
//
//  Created by Duncan Riefler on 3/10/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "MapTabBarController.h"
#import "MapViewFindParkingTab.h"
#import "MapViewListParkingTab.h"
#import "SettingsViewController.h"
#import "SpotMangerTableViewController.h"
#import "CurrentUserSingleton.h"

@interface MapTabBarController ()

@end

@implementation MapTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Email: %@",[[CurrentUserSingleton currentUser] getEmail]);
    NSLog(@"Name: %@",[[CurrentUserSingleton currentUser] getName]);
    NSLog(@"UUID: %@",[[CurrentUserSingleton currentUser] UUID]);
    NSLog(@"reserved spots: %@",[[CurrentUserSingleton currentUser] reservedParkingSpots]);
    NSLog(@"owned spots: %@",[[CurrentUserSingleton currentUser] ownedParkingSpots]);
    NSLog(@"rating: %f",[[CurrentUserSingleton currentUser] rating]);

    
    // Update Navbar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parq_logo_2.png"]];
    self.navigationItem.titleView.layer.frame = CGRectMake(50, 0, 125, 84);
    self.navigationItem.titleView.layer.masksToBounds = NO;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"texture3.jpg"]forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem * spotManagerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(loadSpotMangerPage)];
    [self.navigationItem setRightBarButtonItem:spotManagerButton];
    
    UIBarButtonItem * settingsButton = [[UIBarButtonItem alloc]
                                        initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                        target:self
                                        action:@selector(loadSettingsPage)];
    [settingsButton setEnabled:YES];
    [self.navigationItem setLeftBarButtonItem:settingsButton];
    
    
    // Create Tabs
    MapViewFindParkingTab * findParkingTab;
    MapViewListParkingTab * listParkingTab;
    
    findParkingTab = [[MapViewFindParkingTab alloc] initWithNibName:@"MapViewFindParkingTab" bundle:nil];
    [findParkingTab setTitle:@"Find Parking"];
    listParkingTab = [[MapViewListParkingTab alloc] initWithNibName:@"MapViewListParkingTab" bundle:nil];
    [listParkingTab setTitle:@"List Parking"];
    [self setViewControllers:[NSArray arrayWithObjects:findParkingTab, listParkingTab, nil]];
    
//    UITabBarItem * reserveItem = [UITabBarItem alloc] ini
    [self setSelectedIndex:0];
    // Dispose of any resources that can be recreated
}

- (void) loadSpotMangerPage {
    SpotMangerTableViewController * smvc = [[SpotMangerTableViewController alloc] init];
    [self.navigationController pushViewController:smvc animated:YES];
}

- (void) loadSettingsPage {
    SettingsViewController * svc = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:svc animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
