//
//  MapViewListParkingTabViewController.m
//  parqV1
//
//  Created by Duncan Riefler on 3/10/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "MapViewListParkingTab.h"
#import "AddParkingSpotController.h"

@interface MapViewListParkingTab ()
{
    CLLocationManager *locationManager;
    BOOL atUserLocation;
    MKPointAnnotation * centerAnnotationPoint;
    MKPinAnnotationView * centerAnnotationView;
}
@end

@implementation MapViewListParkingTab

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Create location manager object
        locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        
        // And we want it to be as accurate as possible regardless of how much time/power it takes
        [locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        // Set to false to make sure that we zoom to users location when the view is loaded
        atUserLocation = false;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Setup address bar
    _addressBar.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _addressBar.layer.borderWidth = 1.0;
    _addressBar.layer.cornerRadius = 3.0;
    
    // Setup Map
    [self.worldView setDelegate:self];
    [self.worldView setShowsUserLocation:YES];
    [self.worldView setMapType:MKMapTypeStandard];
    
    // Arrow Button
    _userLocationButton.layer.cornerRadius = 3.0f;
    _userLocationButton.layer.shadowRadius = 3.0f;
    _userLocationButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _userLocationButton.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _userLocationButton.layer.shadowOpacity = 0.5f;
    _userLocationButton.layer.masksToBounds = NO;
    
    // Find Parking Button
    // Add corner radius
    self.listParkingButton.layer.cornerRadius = 4.0f;
    self.listParkingButton.layer.masksToBounds = NO;
    
    // Create pin
    centerAnnotationPoint = [[MKPointAnnotation alloc] init];
    centerAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation: centerAnnotationPoint reuseIdentifier:@"centerAnnotationView"];
    [self.worldView addSubview:centerAnnotationView];
    [centerAnnotationView setPinColor:MKPinAnnotationColorGreen];
    
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self moveMapAnnotationToCoordinate:self.worldView.centerCoordinate];
}

#define PIN_WIDTH_OFFSET 7.75
#define PIN_HEIGHT_OFFSET 5

- (void)moveMapAnnotationToCoordinate:(CLLocationCoordinate2D) coordinate
{
    CGPoint mapViewPoint = [self.worldView convertCoordinate:coordinate toPointToView:self.worldView];
    
    // Offset the view from to account for distance from the lower left corner to the pin head
    CGFloat xoffset = CGRectGetMidX(centerAnnotationView.bounds) - PIN_WIDTH_OFFSET;
    CGFloat yoffset = -CGRectGetMidY(centerAnnotationView.bounds) + PIN_HEIGHT_OFFSET;
    
    centerAnnotationView.center = CGPointMake(mapViewPoint.x + xoffset,
                                                   mapViewPoint.y + yoffset);
}

- (void)zoomToUserLocation:(MKUserLocation *)userLocation
{
    if (!userLocation)
        return;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 1200, 1200);
    [self.worldView setRegion:region animated:YES];
}

- (void) mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    centerAnnotationPoint.coordinate = mapView.centerCoordinate;
    [self moveMapAnnotationToCoordinate:self.worldView.centerCoordinate];
    [self updateAddressBar:mapView.centerCoordinate];
}

- (void) updateAddressBar:(CLLocationCoordinate2D) coord
{
    // Get CLLocation Object from coordinate
    CLLocation * location = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    
    CLGeocoder * geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray * placemarks, NSError * error){
//        NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
        if (error){
            NSLog(@"Geocode failed with error: %@", error);
            return;
        }
        MKPlacemark * placemark = [placemarks lastObject];

        NSString * addressString = @"";
        if ([placemark.subThoroughfare length] != 0) {
            addressString = placemark.subThoroughfare;
        }
        if ([placemark.thoroughfare length] != 0) {
            addressString = [NSString stringWithFormat:@"%@ %@", addressString, placemark.thoroughfare];
        }
        if ([placemark.postalCode length] != 0) {
            addressString = [NSString stringWithFormat:@"%@, %@", addressString, placemark.postalCode];
        }
        if ([placemark.locality length] != 0) {
            addressString = [NSString stringWithFormat:@"%@, %@", addressString, placemark.locality];
        }
        if ([placemark.administrativeArea length] != 0) {
            addressString = [NSString stringWithFormat:@"%@, %@", addressString,placemark.administrativeArea];
        }
        if ([placemark.country length] != 0) {
            addressString = [NSString stringWithFormat:@"%@, %@", addressString,placemark.country];
        }
//        NSLog(@"Address String: %@", addressString);
        NSAttributedString * attributedString;
        if (![addressString isEqualToString:@""]) {
            attributedString = [[NSAttributedString alloc] initWithString:addressString];
            [_addressBar setAttributedTitle:attributedString forState:UIControlStateNormal];
            [self.view setNeedsLayout];
        }
        else {
            attributedString = [[NSAttributedString alloc] initWithString:@"No Address Available"];
        }
        [self.view setNeedsLayout];
    }];
}

- (IBAction)listParkingButtonTapped:(id)sender {
    
    [self loadAddParkingSpotView];
}

- (void)loadAddParkingSpotView
{
    // Pushes the next view where you can add a parking spot (button on top right)
    AddParkingSpotController *apsc = [[AddParkingSpotController alloc] initWithNibName:@"AddParkingSpotController" bundle:nil];
    [[self navigationController] pushViewController:apsc animated:YES];
}

- (IBAction)updateLocationButtonPressed:(id)sender {
    [self zoomToUserLocation:self.worldView.userLocation];
}

- (IBAction)addressBarTapped:(id)sender {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
