//
//  AddParkingSpotController.h
//  parq
//
//  Created by Duncan Riefler on 11/14/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddParkingSpotConfirmationPageViewController.h"

@interface AddParkingSpotController : UIViewController <UITextFieldDelegate, ListingConfirmationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *addressField;
@property (weak, nonatomic) IBOutlet UIDatePicker *startTimePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endTimePicker;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
- (IBAction)submitDataToServer:(id)sender;

@property (nonatomic) NSString * address;
@property (nonatomic) UIImage * mapSnapshot;

@end
