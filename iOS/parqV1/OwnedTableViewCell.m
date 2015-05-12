//
//  OwnedTableViewCell.m
//  parqV1
//
//  Created by Duncan Riefler on 5/10/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "OwnedTableViewCell.h"

@implementation OwnedTableViewCell

- (void)awakeFromNib {
    CGFloat cornerRadius = 5.0f;
    [self.mainContentView.layer setCornerRadius:cornerRadius];
    [self.cancelButton.layer setCornerRadius:cornerRadius];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)removeListingPressed:(id)sender {
    
}

@end
