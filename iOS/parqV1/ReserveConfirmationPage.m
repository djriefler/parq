//
//  ReserveConfirmationPage.m
//  parqV1
//
//  Created by Duncan Riefler on 3/5/14.
//  Copyright (c) 2014 Duncan Riefler. All rights reserved.
//

#define kUpdateSpotStatusURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/status"] //2

#import "ReserveConfirmationPage.h"
#import <MapKit/MapKit.h>

@interface ReserveConfirmationPage ()

@end

@implementation ReserveConfirmationPage
@synthesize currentUser;

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

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    currentUser = user;
}

- (IBAction)checkInButtonPressed:(id)sender {
    // Send data to server
    NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [currentUser objectForKey:@"UUID"],@"id",
                          nil];
    
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        NSLog(@"request sent");
        NSString *postLength = [NSString stringWithFormat:@"%d", [jsonData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kUpdateSpotStatusURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // generates an autoreleased NSURLConnection
        [NSURLConnection connectionWithRequest:request delegate:self];
    }
    else if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    // Load confirmation page
    ReserveConfirmationPage *rcp = [[ReserveConfirmationPage alloc] initWithNibName:@"ReserveConfirmationPage" bundle:nil];
    [[self navigationController] pushViewController:rcp animated:YES];
    
}
@end
