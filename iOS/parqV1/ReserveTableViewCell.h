//
//  ReserveTableViewCell.h
//  parqV1
//
//  Created by Duncan Riefler on 5/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReserveTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;

@end
