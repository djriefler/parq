//
//  CurrentUserSingleton.h
//  parqV1
//
//  Created by Duncan Riefler on 3/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentUserSingleton : NSObject

+ (CurrentUserSingleton *) currentUser;
- (void) setUserDataFromJSON: (NSDictionary *) data;
- (BOOL) isUserSignedIn;
- (void) setUserSignedIn: (BOOL) isSignedIn;
- (void) setEmail:(NSString *) email;
- (void) setName:(NSString *) name;
- (NSString *) UUID;
- (NSString *) getEmail;
- (NSString *) getName;
- (void) setUUID:(NSString *) uuid;
- (void) setRating:(float) rating;
- (void) setReservedSpots: (NSMutableArray *) reserved;
- (void) setOwnedSpots: (NSMutableArray *) owned;

@end
