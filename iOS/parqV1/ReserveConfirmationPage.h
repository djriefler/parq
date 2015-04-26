//
//  ReserveConfirmationPage.h
//  parqV1
//
//  Created by Duncan Riefler on 3/5/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PQSpot.h"

@interface ReserveConfirmationPage : UIViewController

//- (void) setInfoWithSpot:(PQSpot *) spot;
- (void) setAddress:(NSString *) address;
- (id) initWithAddress:(NSString *) address andCoordinate:(NSArray *) coordinates;
@end
