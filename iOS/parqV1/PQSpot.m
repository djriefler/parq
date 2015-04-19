//
//  PQSpot.m
//  parqV1
//
//  Created by Duncan Riefler on 3/7/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "PQSpot.h"

#define kAddressKey @"address"
#define kOwnerKey @"owner"
#define kSpotIDKey @"spotID"
#define kCoordinatesKey @"coordinates"
#define kStartTimeKey @"startTime"
#define kEndTimeKey @"endTime"
#define kLatitudeKey @"latitude"
#define kLongitudeKey @"longitude"

@interface PQSpot()

@property (nonatomic) float latitude;
@property (nonatomic) float longitude;


@end

@implementation PQSpot
@synthesize address, owner, spotID, coordinates, startTime, endTime, latitude, longitude;

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        [self setAddress:[aDecoder decodeObjectForKey:kAddressKey]];
        [self setOwner:[aDecoder decodeObjectForKey:kOwnerKey]];
        [self setSpotID:[aDecoder decodeObjectForKey:kSpotIDKey]];
        [self setStartTime:[aDecoder decodeObjectForKey:kStartTimeKey]];
        [self setEndTime:[aDecoder decodeObjectForKey:kEndTimeKey]];
        [self setLatitude:[aDecoder decodeFloatForKey:kLatitudeKey]];
        [self setLatitude:[aDecoder decodeFloatForKey:kLongitudeKey]];

        [self setCoordinates:[NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:[self latitude]],
                              [NSNumber numberWithFloat:[self longitude]],
                              nil]];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:address forKey:kAddressKey];
    [aCoder encodeObject:owner forKey:kOwnerKey];
    [aCoder encodeObject:spotID forKey:kSpotIDKey];
    [aCoder encodeObject:startTime forKey:kStartTimeKey];
    [aCoder encodeObject:endTime forKey:kEndTimeKey];
    [aCoder encodeFloat:latitude forKey:kLatitudeKey];
    [aCoder encodeFloat:longitude forKey:kLongitudeKey];
}

- (void) setInfoWithJSON:(NSDictionary *)data
{
    address = [data objectForKey:@"address"];
    coordinates = [data objectForKey:@"latlng"];
    spotID = [data objectForKey:@"USID"];
}

@end
