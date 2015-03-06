//
//  CurrentUserSingleton.m
//  parqV1
//
//  Created by Duncan Riefler on 3/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "CurrentUserSingleton.h"

@implementation CurrentUserSingleton
{
    BOOL userSignedIn;
    NSMutableArray * reservedParkingSpots;
    NSMutableArray * ownedParkingSpots;
    NSString * name;
    NSString * email;
    NSString * UUID;
    float rating;
}

- (id) init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (id)initForFirstTime
{
    self = [super init];
    if (self) {
        reservedParkingSpots = [[NSMutableArray alloc] init];
        ownedParkingSpots = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initForExistingUser
{
    self = [super init];
    if (self) {
        reservedParkingSpots = [[NSMutableArray alloc] init];
        ownedParkingSpots = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (CurrentUserSingleton *) currentUser
{
    static CurrentUserSingleton * _currentUser = nil;
    
    static dispatch_once_t once_predicate;
    
    dispatch_once(&once_predicate, ^{
        _currentUser = [[CurrentUserSingleton alloc] init];
    });
    
    return _currentUser;
}

- (BOOL) isUserSignedIn {
    return userSignedIn;
}

- (void) setUserSignedIn:(BOOL)isSignedIn {
    userSignedIn = isSignedIn;
}
@end
