//
//  MapViewListParkingTabViewController.h
//  parqV1
//
//  Created by Duncan Riefler on 3/10/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ListParkingView.h"

@interface MapViewListParkingTab : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *worldView;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *listParkingButton;
@property (weak, nonatomic) IBOutlet ListParkingView *listConfirmView;
@property (weak, nonatomic) IBOutlet UIButton *addressBar;

- (IBAction)listParkingButtonTapped:(id)sender;
- (IBAction)updateLocationButtonPressed:(id)sender;
- (IBAction)addressBarTapped:(id)sender;

@end
