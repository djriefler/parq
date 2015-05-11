//
//  ReserveTableViewCell.h
//  parqV1
//
//  Created by Duncan Riefler on 5/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReserveTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIView *mainContentView;
@property (weak, nonatomic) IBOutlet UILabel *ownerName;
@property (weak, nonatomic) IBOutlet UILabel *ownerNumber;
@property (weak, nonatomic) IBOutlet UILabel *spotAddress;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)getDirectionButtonPressed:(id)sender;

@end
