//
//  ReserveConfirmationPage.h
//  parqV1
//
//  Created by Duncan Riefler on 3/5/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ReserveConfirmationPage : UIViewController<FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *startHour;
@property (weak, nonatomic) IBOutlet UILabel *endHour;
@property (nonatomic) id<FBGraphUser> currentUser;

- (IBAction)getDirectionsPressed:(id)sender;
- (IBAction)checkInButtonPressed:(id)sender;

@end
