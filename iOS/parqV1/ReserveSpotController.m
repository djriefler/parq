//
//  ReserveSpotController.m
//  parqV1
//
//  Created by Duncan Riefler on 12/11/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define kLatestParkingSpotsURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/reserve"] //2

#import "ReserveSpotController.h"
#import "ReserveConfirmationPage.h"
#import "CurrentUserSingleton.h"

@interface ReserveSpotController ()
{
    PQSpot * spot;
    PQUser * user;
}
@end

@implementation ReserveSpotController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        datePickerState = None;
    }
    return self;
}

- (id) initWithMapView: (MKMapView *) currentMapView andSpot: (PQSpot *) spt {
    self = [super initWithNibName:@"ReserveSpotController" bundle:nil];
    if (self) {
        spot = spt;
        user = [spot owner];
        NSLog(@"%@", spot);
    }
    return self;
}

- (IBAction)reserveButtonPressed:(id)sender {
    
    // Disable button
    
    // Confirm the reservation with the server
    [self confirmReservationWithServer];
}

- (void) confirmReservationWithServer {
    // Send data to server
    NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                          [[CurrentUserSingleton currentUser] UUID] , @"user_id",
                          [spot spotID], @"spot_id",
                          nil];
    NSLog(@"%@", [spot spotID]);
    NSLog(@"%@", [[CurrentUserSingleton currentUser] UUID]);
    NSError *error;
    
    //convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    if (jsonData) {
        NSLog(@"request sent");
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kLatestParkingSpotsURL];
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
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSError * error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"%@", json);

    // If spot reservation is confirmed, then load confirmation controller
    if ([[json objectForKey:@"status"]  isEqual: @"confirmed"]) {
        NSString * address = [[json objectForKey:@"spots"] objectForKey:@"address"];
        NSArray * coordinates = [[json objectForKey:@"spots"] objectForKey:@"latlng"];
        ReserveConfirmationPage *rcp = [[ReserveConfirmationPage alloc] initWithAddress:address andCoordinate:coordinates];
        [[self navigationController] pushViewController:rcp animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"parq_logo_2.png"]];
    
    
    // Top Section
    [self setDrivewayPic:[self getDrivewayPic]];
    
    // Middle Section
    [self setHoursAvailable:[self getHoursAvailable]];
    [self setTheAddress:[self getAddress]];
    
    // Bottom Section
    [self setTheStartTime:[self getStartHour]];
    [self setTheEndTime:[self getEndHour]];
    
    // Reserve button
    // Add corner radius
    self.reserveButton.layer.cornerRadius = 4.0f;
    self.reserveButton.layer.masksToBounds = NO;
    
    // Create colors for a gradient
    UIColor *color1 =
    [UIColor colorWithRed:(float)62/255 green:(float)177/255 blue:(float)213/255 alpha:1.0];
    UIColor *color2 =
    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
    UIColor *color3 =
    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
    UIColor *color4 =
    [UIColor colorWithRed:(float)72/255 green:(float)200/255 blue:(float)222/255 alpha:1.0];
    UIColor *color5 =
    [UIColor colorWithRed:(float)62/255 green:(float)177/255 blue:(float)213/255 alpha:1.0];
    
    // Create the gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // Set colors
    gradient.colors = [NSArray arrayWithObjects:
                       (id)color1.CGColor,
                       (id)color2.CGColor,
                       (id)color3.CGColor,
                       (id)color4.CGColor,
                       (id)color5.CGColor,
                       nil];
    
    // Set bounds
    gradient.frame = self.reserveButton.bounds;
    gradient.cornerRadius = 4.0f;
    
    // Add the gradient to the view
    [self.reserveButton.layer insertSublayer:gradient atIndex:0];

}

- (CLLocationCoordinate2D) getPinCoordinates {
    NSArray * coords = [spot coordinates];
    return CLLocationCoordinate2DMake([[coords objectAtIndex:0] doubleValue], [[coords objectAtIndex:1] doubleValue]);
}


// ------ TOP SECTION ------//

// Driveway picture
- (NSString *) getDrivewayPic {
    return @"Driveway.jpg";
}
- (void) setDrivewayPic:(NSString *)parkingView {
    _parkingSpotView.image = [UIImage imageNamed:parkingView];
}

// ------ MIDDLE SECTION ------//

// Hours Available
- (NSString *) getHoursAvailable {
    int start = [[spot startTime] integerValue];
    int end = [[spot endTime] integerValue];
    NSString * startStr;
    NSString * endStr;
    if (start < 12) {
        startStr = [NSString stringWithFormat:@"%dam",start];
    } else {
        if (start != 12) {
            start -= 12;
        }
        startStr = [NSString stringWithFormat:@"%dpm",start];
    }
    if (end < 12) {
        endStr = [NSString stringWithFormat:@"%dam",end];
    }
    else {
        if (end != 12) {
            end -= 12;
        }
        endStr = [NSString stringWithFormat:@"%dpm",end];
    }
    return [NSString stringWithFormat:@"%@-%@",startStr,endStr];
}

- (void) setHoursAvailable:(NSString *) hours {
    _numHours.text = hours;
}

// Address
- (NSString *) getAddress {
    return [spot address];
}
- (void) setTheAddress:(NSString *) addr {
    _address.text = addr;
}

// ------ BOTTOM SECTION ------//

// Start Time
- (void) setTheStartTime:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];

    [_startTime setTitle:stringFromDate forState:UIControlStateNormal];
}


- (NSDate *) getStartHour {
    int start = [[spot startTime] integerValue];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:start];
    [comps setDay:18];
    [comps setMonth:12];
    [comps setYear:2013];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *startTime = [gregorian dateFromComponents:comps];
    return startTime;
}

// End Time
- (void) setTheEndTime:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    [_endTime setTitle:stringFromDate forState:UIControlStateNormal];
}

- (NSDate *) getEndHour {
    int end = [[spot endTime] integerValue];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setHour:end];
    [comps setDay:18];
    [comps setMonth:12];
    [comps setYear:2013];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *endTime = [gregorian dateFromComponents:comps];
    return endTime;
}

// DATEPICKER STUFF

- (IBAction)startButtonPressed:(id)sender {
    datePickerState = Start;
    [self callDatePicker];
}

- (IBAction)endButtonPressed:(id)sender {
    datePickerState = End;
    [self callDatePicker];
}

- (void) callDatePicker
{
    if ([self.view viewWithTag:9]) {
        return;
    }
    // Create the frames for toolbar and datepicker
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height-216-44, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height-216, 320, 216);
    
    // Add a light dark overlay to the screen
    UIView *darkView = [[UIView alloc] initWithFrame:self.view.bounds] ;
    darkView.alpha = 0;
    darkView.backgroundColor = [UIColor blackColor];
    darkView.tag = 9;
    
    // Make it so that when you tap on this dark overlay, the date picker is dismissed
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDatePicker:)];
    [darkView addGestureRecognizer:tapGesture];
    [self.view addSubview:darkView];
    
    // Create the date picker
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height+44, 320, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker setDatePickerMode:UIDatePickerModeTime];
    [datePicker setMinuteInterval:30];
    [datePicker setMinimumDate:[self getStartHour]];
    [datePicker setMaximumDate:[self getEndHour]];
    datePicker.tag = 10;
    [datePicker addTarget:self action:@selector(changeDate:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    // Create the toolbar
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, 320, 44)];
    toolBar.tag = 11;
    toolBar.barStyle = UIBarStyleDefault;
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] ;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissDatePicker:)] ;
    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
//    [self.view addSubview:toolBar];
    
    // Make the datepicker appear with animation
    [UIView beginAnimations:@"MoveIn" context:nil];
    toolBar.frame = toolbarTargetFrame;
    datePicker.frame = datePickerTargetFrame;
    darkView.alpha = 0.6;
    [UIView commitAnimations];
}

- (void)changeDate:(UIDatePicker *)sender {
    if (datePickerState == Start){
        [self setTheStartTime:sender.date];
    }
    else if (datePickerState == End) {
        [self setTheEndTime:sender.date];
    }
    
    // Calculate new price
    NSDate *start = [self getStartHour];
    NSDate *end = [self getEndHour];
    
    unsigned int unitFlags = NSHourCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:start  toDate:end  options:0];
    int hours = [comps hour];
    NSLog(@"%ld",(long)hours);
}

- (void)removeViews:(id)object {
    [[self.view viewWithTag:9] removeFromSuperview];
    [[self.view viewWithTag:10] removeFromSuperview];
    [[self.view viewWithTag:11] removeFromSuperview];
}

- (void)dismissDatePicker:(id)sender {
    CGRect toolbarTargetFrame = CGRectMake(0, self.view.bounds.size.height, 320, 44);
    CGRect datePickerTargetFrame = CGRectMake(0, self.view.bounds.size.height+44, 320, 216);
    [UIView beginAnimations:@"MoveOut" context:nil];
    [self.view viewWithTag:9].alpha = 0;
    [self.view viewWithTag:10].frame = datePickerTargetFrame;
    [self.view viewWithTag:11].frame = toolbarTargetFrame;
    datePickerState = None;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeViews:)];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
