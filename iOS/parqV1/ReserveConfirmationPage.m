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
@property (weak, nonatomic) IBOutlet UILabel *address;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getDirectionsPressed:(id)sender {
    Class mapClass = [MKMapItem class];
    if (mapClass && [mapClass respondsToSelector:@selector(openMapsWithItems:launchOptions:)]) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(34.0205, 118.2856);
        MKPlacemark * placemark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
        NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
        
        MKMapItem * destination = [[MKMapItem alloc] initWithPlacemark:placemark];
        MKMapItem *currentLocationMapItem = [MKMapItem mapItemForCurrentLocation];

        [MKMapItem openMapsWithItems:@[currentLocationMapItem, destination] launchOptions:launchOptions];
    }
}

- (IBAction)checkInButtonPressed:(id)sender {

    
}
@end
