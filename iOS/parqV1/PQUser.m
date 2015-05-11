//
//  PQUser.m
//  parqV1
//
//  Created by Duncan Riefler on 4/21/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import "PQUser.h"

@interface PQUser()

@end

@implementation PQUser

@synthesize UUID, email, name, ownedSpots, reservedSpots, rating, phoneNumber;

- (id)init
{
    self = [super init];
    if (self) {
        ownedSpots = [[NSMutableArray alloc] init];
        reservedSpots = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        UUID = [aDecoder decodeObjectForKey:@"UUIDKey"];
        name = [aDecoder decodeObjectForKey:@"nameKey"];
        email = [aDecoder decodeObjectForKey:@"emailKey"];
        ownedSpots = [aDecoder decodeObjectForKey:@"ownedSpotsKey"];
        reservedSpots = [aDecoder decodeObjectForKey:@"reservedSpotsKey"];
        rating = [aDecoder decodeFloatForKey:@"ratingKey"];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:email forKey:@"emailKey"];
    [aCoder encodeObject:UUID forKey:@"UUIDKey"];
    [aCoder encodeObject:name forKey:@"nameKey"];
    [aCoder encodeFloat:rating forKey:@"ratingKey"];
    [aCoder encodeObject:reservedSpots forKey:@"reservedSpotsKey"];
    [aCoder encodeObject:ownedSpots forKey:@"ownedSpotsKey"];
}
@end
