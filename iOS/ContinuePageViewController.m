//
//  ContinuePageViewController.m
//  parqV1
//
//  Created by Christopher Lee on 5/11/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "ContinuePageViewController.h"
#import "MapTabBarController.h"
#define kServerURL [NSURL URLWithString:@"http://intense-hollows-4714.herokuapp.com/setPhone"]

@interface ContinuePageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNumField;

@end

@implementation ContinuePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.phoneNumField.delegate = self;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)continueButtonPressed:(id)sender {
    
    NSDictionary* info = [[NSDictionary alloc] initWithObjectsAndKeys:
                          self.phoneNumField.text, @"phoneNum",
                          [[CurrentUserSingleton currentUser] UUID], @"uuid",
                           nil];
    
    NSError *error;
    
    // Convert object to data
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    // Send request to server
    if (jsonData) {
        // Create request
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:kServerURL];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:jsonData];
        
        // Send request
        [NSURLConnection connectionWithRequest:request delegate:self];
        
    }
    else if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    
    
    
    MapTabBarController * mbc = [[MapTabBarController alloc] init];
    [[self navigationController] pushViewController:mbc animated:YES];
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
