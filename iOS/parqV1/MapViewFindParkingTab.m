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
#import "SearchViewControllerNew.h"

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
    int selectedSpotUUID;
    
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
    
    // Gradient
//    // Create colors for a gradient
//    UIColor *color1 =
//    [UIColor colorWithRed:(float)62/255 green:(float)177/255 blue:(float)213/255 alpha:1.0];
//    UIColor *color2 =
//    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
//    UIColor *color3 =
//    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
//    UIColor *color4 =
//    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
//    UIColor *color5 =
//    [UIColor colorWithRed:(float)62/255 green:(float)177/255 blue:(float)213/255 alpha:1.0];
//    
//    // Create the gradient
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    
//    // Set colors
//    gradient.colors = [NSArray arrayWithObjects:
//                       (id)color1.CGColor,
//                       (id)color2.CGColor,
//                       (id)color3.CGColor,
//                       (id)color4.CGColor,
//                       (id)color5.CGColor,
//                       nil];
//    
//    // Set bounds
//    gradient.frame = self.findParkingButton.bounds;
//    gradient.cornerRadius = 4.0f;
//    
//    // Add the gradient to the view
//    [self.findParkingButton.layer insertSublayer:gradient atIndex:0];
    
    // Bottom view
    UIImage *background =[UIImage imageNamed:@"texture3.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    [_bottomView addSubview:imageView];
    [_bottomView sendSubviewToBack:imageView ];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self zoomToUserLocation:self.worldView.userLocation];
}

- (void)fetchedData:(NSData *)responseData {
    // Pings the server and asks for the parking spot data
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    parkingSpots = [json objectForKey:@"spots"];
    
    if (parkingSpots != NULL) {
        [self populateMap];
    }
    else {
        NSLog(@"No available parking spots");
    }
}

- (void) populateMap
{
    // Iterates through the parking spots array (which gets populated when the find parking button is pressed and fetchedData is called
    for (NSDictionary* spot in parkingSpots) {
        NSArray *coordinates = [spot objectForKey:@"latlng"];
        int price = [[spot objectForKey:@"price"] integerValue];
        int start = [[spot objectForKey:@"startTime"] integerValue];
        int end = [[spot objectForKey:@"endTime"] integerValue];
        NSString * name = [spot objectForKey:@"name"];
        int uuid = [[spot objectForKey:@"USID"] integerValue];

        // Creates a pin that gets added to the map
        MapPin * pin = [[MapPin alloc] initWithCoord:CLLocationCoordinate2DMake([[coordinates objectAtIndex:0] doubleValue], [[coordinates objectAtIndex:1] doubleValue])
                                             andUUID:uuid
                                             andName:name
                                           andRating:5
                                             andRate:price
                                        andStartTime:start
                                          andEndTime:end];
        [worldView addAnnotation:pin];
    }
}


- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1200, 1200);
    [self.worldView setRegion:region animated:YES];
}

- (void) loadReserveSpotView
{
    NSDictionary * spotData;
    for (NSDictionary* spot in parkingSpots) {
        if ([[spot objectForKey:@"USID"] integerValue] == selectedSpotUUID) {
            spotData = [NSDictionary dictionaryWithDictionary:spot];
        }
    }
    
    NSLog(@"%@",spotData);
    
    PQSpot * selectedSpot = [[PQSpot alloc] init];
    [selectedSpot setInfoWithJSON:spotData];
    
    // Pushes the next view where you can add a parking spot (button on top right)
    ReserveSpotController *rsc = [[ReserveSpotController alloc] initWithMapView:worldView andSpot:selectedSpot];
    rsc.modalTransitionStyle = UIModalTransitionStyleCoverVertical ;
    [[self navigationController] pushViewController:rsc animated:YES];
}

/******************************************
 IBACTIONS (CALLED WHEN BUTTONS ARE PRESSED)
 ********************************************/

- (IBAction)searchBarButtonPressed:(id)sender {
    SearchViewControllerNew * svc = [[SearchViewControllerNew alloc] initWithMapViewController:self];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition
                                                forKey:kCATransition];
    
    [[self navigationController] pushViewController:svc animated:NO];
}

- (IBAction)addressBarButtonTapped:(id)sender {
}

- (IBAction)showUserLocation:(id)sender
{
    
    [self zoomToUserLocation:self.worldView.userLocation];
}

- (IBAction)findParking:(id)sender
{
    // Get nearest parking spots
    [self requestNearestParkingSpots];
    
    // HACK to put pins on map
    [self addFakePinToMap];
}

- (void) requestNearestParkingSpots {
    // Request parking spot data
        NSLog(@"in hurr");
        float longitude = [[locationManager location] coordinate].longitude;
        float latitude = [[locationManager location] coordinate].latitude;
        
        // Prepare request for server to see if user already exists
        NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                              [NSNumber numberWithFloat:longitude], @"longitude",
                              [NSNumber numberWithFloat:latitude], @"latitude", nil];
        
        NSError *error;
        
        // Convert object to data
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        // Create POST request
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kLatestParkingSpotsURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // Send request
        [NSURLConnection connectionWithRequest:request delegate:self];
        

}

- (void) addFakePinToMap {
    MapPin * pin = [[MapPin alloc] initWithCoord:CLLocationCoordinate2DMake((double)34.1205,(double)-118.2856)
                                         andUUID:1
                                         andName:@"DJ"
                                       andRating:5
                                         andRate:0.5
                                    andStartTime:2
                                      andEndTime:8];
    [worldView addAnnotation:pin];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSError * error;
    NSDictionary* json = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
    
    NSLog(@"got response");
    
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

/****************************
 MKMAP VIEW DELEGATE METHODS
 ****************************/
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    // If the pin is on the users location, don't display it
    if (annotation == mapView.userLocation) {
        return nil;
    }
    NSString * parkingSpotIdentifier = @"ParkingSpot"; // identifier used for parking spot pins, makes pins reusable to save memory
    
    // The view that will be displayed when a user taps on a pin
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:parkingSpotIdentifier];
    
    
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:parkingSpotIdentifier];
        [pinView setPinColor:MKPinAnnotationColorGreen];
        pinView.animatesDrop = YES; // animates the pin dropping
        pinView.canShowCallout = YES; // can display a text bubble when tapped on
        
        // Setting the image to be an image of me hehe
        UIImage *originalImage = [UIImage imageNamed:@"Driveway.jpg"];
        CGSize destinationSize = CGSizeMake(40, 40);
        UIGraphicsBeginImageContext(destinationSize);
        [originalImage drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Adding the image as the left item on the pin bubble
        UIImageView * hostPicture = [[UIImageView alloc] initWithImage:newImage];
        pinView.leftCalloutAccessoryView = hostPicture;
        
        // Add a button as the right item on the pin bubble
        UIButton * moreButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [moreButton addTarget:self action:@selector(loadReserveSpotView) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = moreButton;
    }
    else {
        pinView.annotation = annotation;
    }
    
    return pinView;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (atUserLocation == false) {
        [self zoomToUserLocation:userLocation];
        atUserLocation = true;
    }
}

- (void) mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    selectedSpotUUID = (int)[(MapPin *)view.annotation getUUID];
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
