//
//  Pin.m
//  parq
//
//  Created by Duncan Riefler on 10/18/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import "MapPin.h"

@implementation MapPin
@synthesize coordinate, title, UUID;

// Test to see if works with just a coordinate
- (id)initWithCoord: (CLLocationCoordinate2D) coord andUUID: (NSString *) uuid andAddress:(NSString *)address andRating: (int)rating andRate: (float) rate andStartTime: (int) strt andEndTime: (int) end
{
    self = [super init];
    if (self) {
        _rating = rating;
        _rate = rate;
        _startHour = strt;
        _endHour = end;
        UUID = uuid;
        coordinate = coord;
        title = [self cropAddress: address];
        
        _subtitle = [NSString stringWithFormat:@"Hours: %@", [self convertToAMPMFromStart:strt andEnd:end]];
    }
    return self;
}

- (NSString *) cropAddress:(NSString *) addr
{
    NSString * croppedString = @"";
    NSScanner * scanner = [NSScanner scannerWithString:addr];
    [scanner scanUpToString:@"," intoString:&croppedString];
    NSLog(@"%@", croppedString);
    return croppedString;
}

- (NSString *) convertToAMPMFromStart: (int) start andEnd: (int) end {
    NSString * startStr;
    NSString * endStr;
    if (start < 12) {
        startStr = [NSString stringWithFormat:@"%dam",start];
    } else {
        if (start != 12) {
            start -= 12;
        }
        startStr = [NSString stringWithFormat:@"%dpm",start];
    }
    if (end < 12) {
        endStr = [NSString stringWithFormat:@"%dam",end];
    }
    else {
        if (end != 12) {
            end -= 12;
        }
        endStr = [NSString stringWithFormat:@"%dpm",end];
    }
    return [NSString stringWithFormat:@"%@-%@",startStr,endStr];
}

- (NSString *) getUUID
{
    return UUID;
}
@end
