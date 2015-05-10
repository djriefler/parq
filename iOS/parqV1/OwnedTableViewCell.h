//
//  OwnedTableViewCell.h
//  parqV1
//
//  Created by Duncan Riefler on 5/10/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OwnedTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *directionsButton;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@end
