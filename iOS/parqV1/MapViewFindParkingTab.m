//
//  MapViewController.m
//  parq
//
//  Created by Duncan Riefler on 10/28/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestParkingSpotsURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/spots"] //2


#import "MapViewFindParkingTab.h"
#import "MapPin.h"
#import "ReserveSpotController.h"
#import <CoreLocation/CoreLocation.h>


@interface MapViewFindParkingTab()
{
    CLLocationManager *locationManager;
    
    // contains a list of pins with info on them
    NSMutableArray * _parkingSpots;
    
    // used to store the results from the forward geocoding of the given address
    NSArray * _searchPlacemarksCache;
    
    // used to make sure the map doesnt keep zooming in on the users location after finding it
    BOOL atUserLocation;
    
    // used to keep track of which pin is currently selected
    NSString * selectedSpotUUID;
    
    MapPin * desiredParkingPin;
}

@end

@implementation MapViewFindParkingTab
@synthesize parkingSpots, worldView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        // And we want it to be as accurate as possible regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Set to false to make sure that we zoom to users location when the view is loaded
        atUserLocation = false;
        
        _parkingSpots = [[NSMutableArray alloc] init];
        
        desiredParkingPin = [[MapPin alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Map Stuff
    [self.worldView setDelegate:self];
    [self.worldView setShowsUserLocation:YES];
    [self.worldView setMapType:MKMapTypeStandard];
    
    // Setup address bar
    _addressBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _addressBar.layer.borderWidth = 1.0;
    _addressBar.layer.cornerRadius = 3.0;
    
    // Arrow Button
    _userLocationButton.layer.cornerRadius = 3.0f;
    _userLocationButton.layer.shadowRadius = 3.0f;
    _userLocationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _userLocationButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _userLocationButton.layer.shadowOpacity = 0.5f;
    _userLocationButton.layer.masksToBounds = NO;
    
    // Find Parking Button
    // Add corner radius
    self.findParkingButton.layer.cornerRadius = 4.0f;
    self.findParkingButton.layer.masksToBounds = NO;
    self.findParkingButton.layer.borderWidth = 1.0f;
    self.findParkingButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Search Methods

- (IBAction)addressBarButtonTapped:(id)sender {
    SearchViewControllerNew * svc = [[SearchViewControllerNew alloc] initWithMapViewController:self];
    svc.delegate = self;
    [[self navigationController] presentViewController:svc animated:YES completion:nil];
}

- (void) searchOptionSelected:(MKMapItem *) mapItem
{
    [[self navigationController] dismissViewControllerAnimated:YES completion:nil];
    NSString * thoroughfare = [[mapItem placemark] thoroughfare];
    NSString * subthoroughfare = [[mapItem placemark] subThoroughfare];
    NSString * addr = [NSString stringWithFormat:@"%@ %@", subthoroughfare, thoroughfare];
    [[self addressBar] setTitle:addr forState:UIControlStateNormal];
    [self updateDesiredParkingPinLocation:[[mapItem placemark] coordinate] andTitle:addr];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(desiredParkingPin.coordinate, 1200, 1200);
    [self.worldView setRegion:region animated:YES];
    
}

#pragma mark - Server Methods

- (IBAction)findParking:(id)sender
{
    NSMutableArray * spotAnnotations = [[NSMutableArray alloc] initWithArray:worldView.annotations];
    [spotAnnotations removeObject:desiredParkingPin];
    [spotAnnotations removeObject:[worldView userLocation]];
    [worldView removeAnnotations:spotAnnotations];
    // Get nearest parking spots
    [self requestNearestParkingSpots];
}

- (void) requestNearestParkingSpots {
    // Request parking spot data

        double longitude = [desiredParkingPin coordinate].longitude;
        double latitude = [desiredParkingPin coordinate].latitude;
        
        // Prepare request for server to see if parking spots are available near user
        NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat:longitude], @"longitude",
                              [NSNumber numberWithFloat:latitude], @"latitude", nil];
        
        NSError *error;
        
        // Convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        // Create POST request
        NSString *postLength = [NSString stringWithFormat:@"%d", [jsonData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kLatestParkingSpotsURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // Send request
        [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError * error;

    NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];

    // If there are parking spots available, fill map with them
    if (data != nil) {
        [self performSelectorOnMainThread:@selector(fetchedData:)
                               withObject:data waitUntilDone:YES];
    }
    else {
        NSLog(@"NO DATA! Check internet connection or server connection");
    }

    NSLog(@"%@", json);
        
}

- (void)fetchedData:(NSData *)responseData {
    // Pings the server and asks for the parking spot data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    if ([json objectForKey:@"spots"]) {
        parkingSpots = [json objectForKey:@"spots"];
        if (parkingSpots != NULL) {
            [self populateMap];
        }
    }
    else if ([[json objectForKey:@"status"]  isEqual: @"no_spots"]) {
        NSString * message = @"We are sorry, there are no spots available in this area.";
        NSString * title = @"No Spots Available";
        NSString * cancelButtonTitle = @"OK";
        UIAlertView * noSpotsAlert = [[UIAlertView alloc]
                                      initWithTitle:title
                                      message:message
                                      delegate:self
                                      cancelButtonTitle:cancelButtonTitle
                                      otherButtonTitles:nil,
                                      nil];
        [noSpotsAlert show];
    }
    else {
        NSLog(@"No available parking spots");
    }
}

- (void) populateMap
{
    // Iterates through the parking spots array (which gets populated when the find parking button is pressed and fetchedData is called
    for (NSDictionary* spot in parkingSpots) {
        int price = 0;
        int start = 0;
        int end = 0;
        NSString * uuid = @"";
        NSArray * coordinates = [NSArray new];
        NSString * address = @"";
        if ([[spot objectForKey:@"price"] integerValue]) {
            price = [[spot objectForKey:@"price"] integerValue];
        }
        if ([spot objectForKey:@"latlng"]) {
            coordinates = [spot objectForKey:@"latlng"];
        }
        if ([[spot objectForKey:@"startTime"] integerValue]) {
            start = [[spot objectForKey:@"startTime"] integerValue];
        }
        if ([[spot objectForKey:@"endTime"] integerValue]) {
            end = [[spot objectForKey:@"endTime"] integerValue];
        }
        if ([spot objectForKey:@"USID"]) {
            uuid = [spot objectForKey:@"USID"];
        }
        if ([spot objectForKey:@"address"]) {
            address = [spot objectForKey:@"address"];
        }
        
        // Creates a pin that gets added to the map
        MapPin * pin = [[MapPin alloc] initWithCoord:CLLocationCoordinate2DMake([[coordinates objectAtIndex:0] doubleValue], [[coordinates objectAtIndex:1] doubleValue])
                                             andUUID:uuid
                                          andAddress:address
                                           andRating:5
                                             andRate:price
                                        andStartTime:start
                                          andEndTime:end];
        [worldView addAnnotation:pin];
    }
}

- (void) loadReserveSpotView
{
    NSDictionary * spotData;
    for (NSDictionary* spot in parkingSpots) {
        if ([spot objectForKey:@"USID"] == selectedSpotUUID) {
            spotData = [NSDictionary dictionaryWithDictionary:spot];
        }
    }
    
    NSLog(@"%@",spotData);
    
    PQSpot * selectedSpot = [PQSpot createSpotFromJSON:spotData];
    
    // Pushes the next view where you can add a parking spot (button on top right)
    ReserveSpotController *rsc = [[ReserveSpotController alloc] initWithMapView:worldView andSpot:selectedSpot];
    rsc.modalTransitionStyle = UIModalTransitionStyleCoverVertical ;
    [[self navigationController] pushViewController:rsc animated:YES];
}

#pragma mark - Map Methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // If the pin is on the users location, don't display it
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *pinView;
    NSString * desiredParkingIdentifier = @"DesiredParkingLocation";
    NSString * parkingSpotIdentifier = @"ParkingSpot";
    
    if (annotation == desiredParkingPin) {
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:desiredParkingIdentifier];
    }
    else {
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:parkingSpotIdentifier];
    }
    
    if (!pinView) {
        if (annotation == desiredParkingPin) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:desiredParkingIdentifier];
            [pinView setPinColor:MKPinAnnotationColorRed];
        }
        else {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingSpotIdentifier];
            [pinView setPinColor:MKPinAnnotationColorPurple];

            // Add a button as the right item on the pin bubble
            UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [moreButton addTarget:self action:@selector(loadReserveSpotView) forControlEvents:UIControlEventTouchUpInside];
            pinView.rightCalloutAccessoryView = moreButton;
        }
        pinView.animatesDrop = YES;
        pinView.canShowCallout = YES;
    }
    else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void) addFakePinToMap {
    MapPin * pin = [[MapPin alloc] initWithCoord:CLLocationCoordinate2DMake((double)34.1205,(double)-118.2856)
                                         andUUID:@"fasdf43f"
                                      andAddress:@"FAkes "
                                       andRating:5
                                         andRate:0.5
                                    andStartTime:2
                                      andEndTime:8];
    [worldView addAnnotation:pin];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // Only called when the app is first opened
    if (atUserLocation == false) {
        [self zoomToUserLocation:userLocation];
        [self updateDesiredParkingPinLocation:[userLocation coordinate] andTitle:@"Current Location"];
        [[self addressBar] setTitle:@"Current Location" forState:UIControlStateNormal];
        [worldView addAnnotation:desiredParkingPin];
        atUserLocation = true;
    }
}

- (void) updateDesiredParkingPinLocation:(CLLocationCoordinate2D) coord andTitle:(NSString *) title
{
    [desiredParkingPin setCoordinate:coord];
    [desiredParkingPin setTitle:title];
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    selectedSpotUUID = (NSString *)[(MapPin *)view.annotation getUUID];
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1200, 1200);
    [self updateDesiredParkingPinLocation:[userLocation coordinate] andTitle:@"Current Location"];
    [[self addressBar] setTitle:@"Current Location" forState:UIControlStateNormal];
    [self.worldView setRegion:region animated:YES];
}

- (IBAction)showUserLocation:(id)sender
{
    [self zoomToUserLocation:self.worldView.userLocation];
}


/***************
   ACCESORS/ETC
 ****************/
- (NSArray *) parkingSpots {
    parkingSpots = _parkingSpots;
    return parkingSpots;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc
{
    // Tell the location manager to stop sending us messages
    [locationManager setDelegate:nil];
}

@end
