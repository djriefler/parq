//
//  AddParkingSpotController.m
//  parq
//
//  Created by Duncan Riefler on 11/14/13.
//  Copyright (c) 2013 Duncan Riefler. All rights reserved.
//

#import "AddParkingSpotController.h"
#import "CurrentUserSingleton.h"

#define kLatestParkingSpotsURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/add"] //2
typedef enum {None,Start,End} DatePickerState;

@interface AddParkingSpotController ()
{
    DatePickerState datePickerState;
}

@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UIImageView *mapImageView;
- (IBAction)startTimeButtonPressed:(id)sender;
- (IBAction)endTimeButtonPressed:(id)sender;

@end

@implementation AddParkingSpotController
@synthesize startTimePicker, endTimePicker, addressField, submitButton, address, mapSnapshot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        datePickerState = None;
    }
    return self;
}

- (IBAction)submitDataToServer:(id)sender;
{
    NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                          address, @"address",
                          [[_startTimeButton titleLabel] text], @"startTime",
                          [[_endTimeButton titleLabel] text], @"endTime",
                          [[CurrentUserSingleton currentUser] UUID], @"user_id",
                          nil];
    
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
        NSLog(@"GOOD!");
    }
}

#pragma mark - Date Picking

- (IBAction)startTimeButtonPressed: (id)sender {
    datePickerState = Start;
    [self callDatePicker];
}

- (IBAction)endTimeButtonPressed:(id)sender {
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

// Start Time
- (void) setTheStartTime:(NSDate *) date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *stringFromDate = [formatter stringFromDate:date];
    
    [_startTimeButton setTitle:stringFromDate forState:UIControlStateNormal];
}


- (NSDate *) getStartHour {
//    int start = [[spot startTime] integerValue];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
//    [comps setHour:start];
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
    
    [_endTimeButton setTitle:stringFromDate forState:UIControlStateNormal];
}

- (void)changeDate:(UIDatePicker *)sender {
    if (datePickerState == Start){
        [self setTheStartTime:sender.date];
    }
    else if (datePickerState == End) {
        [self setTheEndTime:sender.date];
    }
    
    unsigned int unitFlags = NSHourCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *comps = [calendar components:unitFlags fromDate:start  toDate:end  options:0];
//    int hours = [comps hour];
//    NSLog(@"%ld",(long)hours);
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


- (NSString *) getStringFromDate: (NSDate *) date
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
   return [dateFormatter stringFromDate:date];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"parq"];
    [_addressLabel setText:address];
    [_mapImageView setImage:mapSnapshot];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
