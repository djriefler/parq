//
//  MapViewController.h
//  parq
//
//  Created by Duncan Riefler on 10/28/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <QuartzCore/QuartzCore.h>


@interface MapViewFindParkingTab : UIViewController<CLLocationManagerDelegate, MKMapViewDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet MKMapView * worldView;
}

@property (nonatomic, retain) IBOutlet MKMapView * worldView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic) NSArray * parkingSpots;
@property (weak, nonatomic) IBOutlet UIButton *userLocationButton;
@property (weak, nonatomic) IBOutlet UIButton *findParkingButton;
@property (weak, nonatomic) IBOutlet UIButton *addressBar;

- (IBAction)addressBarButtonTapped:(id)sender;

- (IBAction)showUserLocation:(id)sender;

- (IBAction)findParking:(id)sender;
@end
