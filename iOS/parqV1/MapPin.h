//
//  Pin.h
//  parq
//
//  Created by Duncan Riefler on 10/18/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapPin : NSObject<MKAnnotation>
{
    // rating out of 5 stars
    int _rating;
    // Hourly rate that seller is charging
    float _rate;
    // Times the spot is available
    int _startHour;
    int _endHour;
    CLPlacemark *_location;
}

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, readonly, copy) NSString * subtitle;
@property NSString * UUID;

- (NSString *) getUUID;
- (id)initWithCoord: (CLLocationCoordinate2D) coord andUUID: (NSString *) uuid andAddress: (NSString *) address andRating: (int)rating andRate: (float) rate andStartTime: (int) strt andEndTime: (int) end;

@end
