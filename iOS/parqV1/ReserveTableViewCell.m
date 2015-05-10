//
//  ReserveTableViewCell.m
//  parqV1
//
//  Created by Duncan Riefler on 5/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "ReserveTableViewCell.h"

@implementation ReserveTableViewCell

- (void)awakeFromNib {
    CGFloat cornerRadius = 5.0f;
    [self.contentView.layer setCornerRadius:cornerRadius];
    [self.cancelButton.layer setCornerRadius:cornerRadius];
    [self.directionsButton.layer setCornerRadius:cornerRadius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
