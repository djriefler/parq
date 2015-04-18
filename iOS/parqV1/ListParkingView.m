//
//  ListParkingView.m
//  parqV1
//
//  Created by Duncan Riefler on 4/4/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "ListParkingView.h"
#import "CheckboxButton.h"

@implementation ListParkingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) layoutSubviews
{
    // Set up view
    [self.layer setOpacity:0.92];
    [self.layer setCornerRadius:4.0];
    
    // Create Labels
    UILabel * instructionsLabel = [UILabel new];
    UILabel * startTimeLabel= [UILabel new];
    UILabel * endTimeLabel = [UILabel new];
    
    // Add Labels to List Confirm View
    [self addSubview:instructionsLabel];
    [self addSubview:startTimeLabel];
    [self addSubview:endTimeLabel];
    
    // Set text font size
    [instructionsLabel setFont:[UIFont systemFontOfSize:12.0]];
    [startTimeLabel setFont:[UIFont systemFontOfSize:12.0]];
    [endTimeLabel setFont:[UIFont systemFontOfSize:12.0]];
    
    // Create label text
    NSString * instructionsLabelText = @"Please indicate availability for this spot:";
    NSString * startTimeLabelText = @"Start time:";
    NSString * endTimeLabelText = @"End time:";
    
    // Set text for labels
    [instructionsLabel setText:instructionsLabelText];
    [startTimeLabel setText:startTimeLabelText];
    [endTimeLabel setText:endTimeLabelText];
    
    // Create label Frames
    float instructionsLabelX = 10;
    float instructionsLabelY = 10;
    float instructionsLabelWidth = 300;
    float instructionsLabelHeight = 20;
    
    float startTimeLabelX = 10;
    float startTimeLabelY = instructionsLabelY + instructionsLabelHeight;
    float startTimeLabelWidth = 100;
    float startTimeLabelHeight = 20;
    
    float endTimeLabelX = 10;
    float endTimeLabelY = startTimeLabelY + startTimeLabelHeight;
    float endTimeLabelWidth = 100;
    float endTimeLabelHeight = 20;
    
    // Set label frames
    [instructionsLabel setFrame:CGRectMake(instructionsLabelX, instructionsLabelY, instructionsLabelWidth, instructionsLabelHeight)];
    [startTimeLabel setFrame:CGRectMake(startTimeLabelX, startTimeLabelY, startTimeLabelWidth, startTimeLabelHeight)];
    [endTimeLabel setFrame:CGRectMake(endTimeLabelX, endTimeLabelY, endTimeLabelWidth, endTimeLabelHeight)];
    
    // Create checkboxes
    float checkboxHeight = 20;
    float checkboxWidth = 20;
    float checkboxOffsetX = 5 + checkboxWidth;
    float checkboxPositionX = startTimeLabelX + startTimeLabelWidth - 60;
    float checkboxPositionY = startTimeLabelY + 1;

    CheckboxButton * mondayButton = [[CheckboxButton alloc] initWithFrame:CGRectMake(checkboxPositionX + checkboxOffsetX, checkboxPositionY, checkboxWidth, checkboxHeight)];
    [mondayButton setTitle:@"Mon" forState:UIControlStateApplication];
    
    CheckboxButton * tuesdayButton = [[CheckboxButton alloc] initWithFrame:CGRectMake(checkboxPositionX + 2*checkboxOffsetX, checkboxPositionY, checkboxWidth, checkboxHeight)];
    
    CheckboxButton * wednesdayButton = [[CheckboxButton alloc] initWithFrame:CGRectMake(checkboxPositionX + 3*checkboxOffsetX, checkboxPositionY, checkboxWidth, checkboxHeight)];
    
    CheckboxButton * thursdayButton = [[CheckboxButton alloc] initWithFrame:CGRectMake(checkboxPositionX + 4*checkboxOffsetX, checkboxPositionY, checkboxWidth, checkboxHeight)];
    
    CheckboxButton * fridayButton = [[CheckboxButton alloc] initWithFrame:CGRectMake(checkboxPositionX + 5*checkboxOffsetX, checkboxPositionY, checkboxWidth, checkboxHeight)];
    
    CheckboxButton * saturdayButton = [[CheckboxButton alloc] initWithFrame:CGRectMake(checkboxPositionX + 6*checkboxOffsetX, checkboxPositionY, checkboxWidth, checkboxHeight)];
    
    CheckboxButton * sundayButton = [[CheckboxButton alloc] initWithFrame:CGRectMake(checkboxPositionX + 7*checkboxOffsetX, checkboxPositionY, checkboxWidth, checkboxHeight)];
    
    // Add the checkboxes to the view
    [self addSubview:mondayButton];
    [self addSubview:tuesdayButton];
    [self addSubview:wednesdayButton];
    [self addSubview:thursdayButton];
    [self addSubview:fridayButton];
    [self addSubview:saturdayButton];
    [self addSubview:sundayButton];




    // PART 1

    // The times/dates available
    // Start Time - [1][2][3][4][5][6][7][8][9][10][11][12] AM [check] PM [check]
    // End Time - [1][2][3][4][5][6][7][8][9][10][11][12] AM [check] PM [check]
    // Days of the week Mon[] Tue[] Wed[] Thur[] Fri[] Sat[] Sun[]
    
    
    // PART 2
    // How should you be reached if the renter has trouble?
    // Text[] Phone Call[] Email[]
    
    // Listing Confirmed!
    // You can manage this listing in your spots manager page
}

@end
