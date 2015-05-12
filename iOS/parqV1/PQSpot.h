//
//  PQSpot.h
//  parqV1
//
//  Created by Duncan Riefler on 3/7/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PQUser.h"

@interface PQSpot : NSObject <NSCoding>

@property NSString * spotID;
@property PQUser * owner;
@property NSString * ownerName;
@property NSString * address;
@property NSArray * coordinates;
@property NSString * price;
@property NSString * startTime;
@property NSString * endTime;

- (void) setInfoWithJSON:(NSDictionary *) data;
+ (PQSpot *) createSpotFromJSON: (NSDictionary *) data;
@end
