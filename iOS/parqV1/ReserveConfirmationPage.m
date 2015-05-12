//
//  ReserveConfirmationPage.m
//  parqV1
//
//  Created by Duncan Riefler on 3/5/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#import "ReserveConfirmationPage.h"
#import <MapKit/MapKit.h>

@interface ReserveConfirmationPage ()
{
    NSString * addressText;
    CLLocationCoordinate2D spotCoordinates;
}
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ReserveConfirmationPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithAddress:(NSString *)address andCoordinate:(NSArray *)coordinates{
    self = [super init];
    if (self) {
        addressText = address;
        NSNumber * latNum =[coordinates objectAtIndex:0];
        NSNumber * lonNum = [coordinates objectAtIndex:1];
        double lat = [latNum doubleValue];
        double lon = [lonNum doubleValue];
        spotCoordinates = CLLocationCoordinate2DMake(lat, lon);
    }
    return self;
}

//- (void) setInfoWithSpot:(PQSpot *)spot
//{
//    [[self address] setText:[spot address]];
//}

- (void) setAddress:(NSString *)address
{
    [[self addressLabel] setText:address];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self addressLabel] setText:addressText];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getDirectionsPressed:(id)sender {
    [self.delegate reservePageDismissed];
    
    Class mapClass = [MKMapItem class];
    if (mapClass && [mapClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {

        MKPlacemark * placemark = [[MKPlacemark alloc] initWithCoordinate:spotCoordinates addressDictionary:nil];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        
        MKMapItem * destination = [[MKMapItem alloc] initWithPlacemark:placemark];
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];

        [MKMapItem openMapsWithItems:@[currentLocationMapItem, destination] launchOptions:launchOptions];
    }
}

@end
