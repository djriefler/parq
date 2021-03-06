//
//  AddParkingSpotConfirmationPageViewController.h
//  parqV1
//
//  Created by Duncan Riefler on 5/10/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddParkingSpotConfirmationPageViewController : UIViewController

- (void) setAddress: (NSString *) addr;
@property id delegate;

@end

@protocol ListingConfirmationDelegate

- (void) doneWithConfirmation;

@end