//
//  CurrentUserSingleton.h
//  parqV1
//
//  Created by Duncan Riefler on 3/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PQUser.h"

@interface CurrentUserSingleton : NSObject

+ (CurrentUserSingleton *) currentUser;

- (BOOL) saveChanges;

- (void) setUserDataFromJSON: (NSDictionary *) data;
- (void) setUserSignedIn: (BOOL) isSignedIn;
- (void) setEmail:(NSString *) email;
- (void) setName:(NSString *) name;
- (void) setPhoneNumber: (NSString *) phoneNumber;
- (void) setUUID:(NSString *) uuid;
- (void) setRating:(float) rating;
- (void) setReservedSpots: (NSMutableArray *) reserved;
- (void) setOwnedSpots: (NSMutableArray *) owned;
- (void) updateServer;


- (BOOL) isUserSignedIn;
- (NSString *) UUID;
- (NSString *) email;
- (NSString *) name;
- (NSString *) phoneNumber;
- (float) rating;
- (NSMutableArray *) reservedParkingSpots;
- (NSMutableArray *) ownedParkingSpots;


- (PQUser *) theUser;

@end
