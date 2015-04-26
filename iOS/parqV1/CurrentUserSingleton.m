//
//  CurrentUserSingleton.m
//  parqV1
//
//  Created by Duncan Riefler on 3/3/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "CurrentUserSingleton.h"
#import "PQUser.h"
#define settingsURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/settings"]


@implementation CurrentUserSingleton
{
    BOOL userSignedIn;
    PQUser * currentUser;
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

- (id) init
{
    self = [super init];
    if (self) {
        NSString * path = [self userDataArchivePath];
        currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // User has not logged in on this phone before
        if (!currentUser) {
            currentUser = [[PQUser alloc] init];
            currentUser.rating = 5.0;
            currentUser.ownedSpots = [[NSMutableArray alloc] init];
            currentUser.reservedSpots = [[NSMutableArray alloc] init];
            userSignedIn = NO;
        }
        else {
            userSignedIn = YES;
        }
    }
    return self;
}

// Caching

- (NSString *)userDataArchivePath {
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documentDirectory = [documentDirectories objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:@"userData.archive"];
}

- (BOOL) saveChanges
{
    NSString * path = [self userDataArchivePath];
    return [NSKeyedArchiver archiveRootObject:currentUser toFile:path];
    NSLog(@"Saved changes");
}

// Setters

- (void) setUserDataFromJSON:(NSDictionary *)json
{
    NSDictionary * data = [json objectForKey:@"data"];

    if ([data objectForKey:@"UUID"]) {
        currentUser.UUID = [data objectForKey:@"UUID"];
    }
    if ([data objectForKey:@"name"]) {
        currentUser.name = [data objectForKey:@"name"];
    }
    if ([data objectForKey:@"email"]) {
        currentUser.email = [data objectForKey:@"email"];
    }
    if ([data objectForKey:@"rating"] != NULL) {
        currentUser.rating = [[data objectForKey:@"rating"] floatValue];
    }
    if ([data objectForKey:@"reserved"]) {
        currentUser.reservedSpots = [data objectForKey:@"reserved"];
    }
    if ([data objectForKey:@"owned"]) {
        currentUser.ownedSpots = [data objectForKey:@"owned"];
    }
}

- (void) setUserSignedIn:(BOOL)isSignedIn {
    userSignedIn = isSignedIn;
}

- (BOOL) isUserSignedIn {
    return userSignedIn;
}

- (void) setUUID:(NSString *)uuid
{
    currentUser.UUID = uuid;
}

- (void) setName:(NSString *)name
{
    currentUser.name = name;
}

- (void) setEmail:(NSString *)email
{
    currentUser.email = email;
}

- (void) setRating:(float)rating
{
    currentUser.rating = rating;
}

- (void) setReservedSpots:(NSMutableArray *)reserved
{
    currentUser.reservedSpots = reserved;
}

- (void) setOwnedSpots:(NSMutableArray *)owned
{
    currentUser.ownedSpots = owned;
}

// Getters

- (NSString *) getEmail
{
    return currentUser.email;
}
- (NSString *) getName
{
    return currentUser.name;
}

- (NSString *) UUID
{
    return  currentUser.UUID;
}

- (float) rating
{
    return currentUser.rating;
}

- (NSMutableArray *) reservedParkingSpots {
    return currentUser.reservedSpots;
}

- (NSMutableArray *) ownedParkingSpots {
    return currentUser.ownedSpots;
}

- (PQUser *) theUser
{
    return currentUser;
}

- (void) updateServer
{
    // Convert object to data
    
    NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
    [data setObject:currentUser.name forKey:@"name"];
    [data setObject:currentUser.email forKey:@"email"];
    [data setObject:currentUser.UUID forKey:@"UUID"];
    
//    NSData* postData = [NSKeyedArchiver archivedDataWithRootObject:data ];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL: settingsURL];
//    [request setHTTPMethod:@"POST"];
//    [request setHTTPBody:postData];
//
//    NSURLResponse *requestResponse;
//    NSData *requestHandler = [NSURLConnection sendSynchronousRequest:request returningResponse:&requestResponse error:nil];
//    
//    NSString *requestReply = [[NSString alloc] initWithBytes:[requestHandler bytes] length:[requestHandler length] encoding:NSASCIIStringEncoding];
//    NSLog(@"requestReply: %@", requestReply);
//    
//    
    NSError *error;

    
    // Convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    // Create POST request
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:settingsURL];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    // Send request
    [NSURLConnection connectionWithRequest:request delegate:self];
}








@end
