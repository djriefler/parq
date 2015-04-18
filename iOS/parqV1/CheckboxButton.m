//
//  CheckboxButton.m
//  parqV1
//
//  Created by Duncan Riefler on 4/4/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "CheckboxButton.h"

@implementation CheckboxButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.adjustsImageWhenHighlighted = YES;
        self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
        self.layer.borderWidth = 1.0;
        self.layer.cornerRadius = 3.0;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
