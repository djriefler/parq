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

@interface MapTabBarController ()

@end

@implementation MapTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Update Navbar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parq_logo_2.png"]];
    self.navigationItem.titleView.layer.frame = CGRectMake(50, 0, 125, 84);
    self.navigationItem.titleView.layer.masksToBounds = NO;
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"texture3.jpg"]forBarMetrics:UIBarMetricsDefault];
    
    UIBarButtonItem * spotManagerButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"spotManagerIcon.png"] style:UIBarButtonItemStylePlain target:self action:@selector(loadSpotMangerPage)];
    [self.navigationController.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:spotManagerButton, nil]  animated:NO];
    
    // Create Tabs
    MapViewFindParkingTab * findParkingTab;
    MapViewListParkingTab * listParkingTab;
    
    findParkingTab = [[MapViewFindParkingTab alloc] initWithNibName:@"MapViewFindParkingTab" bundle:nil];
    [findParkingTab setTitle:@"Find Parking"];
    listParkingTab = [[MapViewListParkingTab alloc] initWithNibName:@"MapViewListParkingTab" bundle:nil];
    [listParkingTab setTitle:@"List Parking"];
    [self setViewControllers:[NSArray arrayWithObjects:findParkingTab, listParkingTab, nil]];
    
    [self setSelectedIndex:0];
    // Dispose of any resources that can be recreated
}

- (void) loadSpotMangerPage {
    
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
