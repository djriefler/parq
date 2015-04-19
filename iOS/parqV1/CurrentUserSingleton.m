//
//  CurrentUserSingleton.m
//  parqV1
//
//  Created by Duncan Riefler on 3/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "CurrentUserSingleton.h"
#import "PQUser.h"

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

- (NSString *)userDataArchivePath {
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"userData.archive"];
}

- (BOOL) saveChanges
{
    NSString * path = [self userDataArchivePath];
    PQUser * user = [[PQUser alloc] init];
    [user setReservedSpots:reservedParkingSpots];
    [user setOwnedSpots:ownedParkingSpots];
    [user setRating:rating];
    [user setName:name];
    [user setEmail:email];
    [user setUUID:UUID];
    return [NSKeyedArchiver archiveRootObject:user toFile:path];
}

- (NSString *) UUID
{
    return  UUID;
}

- (void) setUserDataFromJSON:(NSDictionary *)data
{
    if ([data objectForKey:@"UUID"]) {
        UUID = [data objectForKey:@"UUID"];
    }
    if ([data objectForKey:@"name"]) {
        name = [data objectForKey:@"name"];
    }
    if ([data objectForKey:@"email"]) {
        email = [data objectForKey:@"email"];
    }
    if ([data objectForKey:@"rating"]) {
        rating = [[data objectForKey:@"rating"] floatValue];
    }
    if ([data objectForKey:@"reserved"]) {
        reservedParkingSpots = [data objectForKey:@"reserved"];
    }
    if ([data objectForKey:@"owned"]) {
        ownedParkingSpots = [data objectForKey:@"owned"];
    }
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

- (NSMutableArray *) reservedParkingSpots {
    return reservedParkingSpots;
}

- (NSMutableArray *) ownedParkingSpots {
    return ownedParkingSpots;
}
@end
