//
//  PQSpot.m
//  parqV1
//
//  Created by Duncan Riefler on 3/7/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "PQSpot.h"

@implementation PQSpot
@synthesize address, owner, spotID, coordinates, startTime, endTime;

- (void) setInfoWithJSON:(NSDictionary *)data
{
    address = [data objectForKey:@"address"];
    coordinates = [data objectForKey:@"latlng"];
    spotID = [data objectForKey:@"UUID"];
}

@end
