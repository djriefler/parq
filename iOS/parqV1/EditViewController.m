//
//  EditViewController.m
//  parqV1
//
//  Created by Christopher Lee on 4/18/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import "EditViewController.h"
#import "CurrentUserSingleton.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UILabel *itemText;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation EditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.saveButton setEnabled:NO];

}
- (IBAction)editingChanged:(id)sender {
    if (self.textField.text.length ==0)
    {
        [self.saveButton setEnabled:NO];
    }
    else
    {
        [self.saveButton setEnabled:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)saveButtonPressed:(id)sender {
    //Update appropriate info in Model
    if ([self.itemText.text isEqualToString:@"Name"])
    {
        //update name
        [[CurrentUserSingleton currentUser] setName:self.textField.text];
    }
    else
    {
        //update email
        [[CurrentUserSingleton currentUser] setEmail:self.textField.text];
        
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(void) setTitleText: (NSString *) text
{
    self.itemText.text = text;
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
