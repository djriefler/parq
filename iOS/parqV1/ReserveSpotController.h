//
//  ReserveSpotController.h
//  parqV1
//
//  Created by Duncan Riefler on 12/11/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PQSpot.h"

typedef enum {None,Start,End} DatePickerState;

@interface ReserveSpotController : UIViewController<MKMapViewDelegate>
{
    DatePickerState datePickerState;
}

// Top Part
@property (weak, nonatomic) IBOutlet UIImageView *ProfPic;
@property (weak, nonatomic) IBOutlet UIImageView *parkingSpotView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numPrevParkers;

// Middle Part
@property (weak, nonatomic) IBOutlet UILabel *numHours;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet MKMapView *parkingMapView;


// Bottom Part
@property (weak, nonatomic) IBOutlet UILabel *totalWantedHours;
@property (weak, nonatomic) IBOutlet UILabel *totalAmount;
@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UIButton *reserveButton;

- (id) initWithMapView: (MKMapView *) currentMapView andSpot: (PQSpot *) spot;
- (IBAction)reserveButtonPressed:(id)sender;



@end
