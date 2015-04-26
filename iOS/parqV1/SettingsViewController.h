//
//  SettingsViewController.h
//  parqV1
//
//  Created by Christopher Lee on 4/18/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditViewController.h"
#import <MessageUI/MessageUI.h>


@class EditViewController;

@interface SettingsViewController : UITableViewController <MFMailComposeViewControllerDelegate, EditViewControllerDelegate>

- (id)initWithStyle:(UITableViewStyle)style;


@end
