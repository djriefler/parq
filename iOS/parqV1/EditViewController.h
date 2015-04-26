//
//  EditViewController.h
//  parqV1
//
//  Created by Christopher Lee on 4/18/15.
//  Copyright (c) 2015 Duncan Riefler. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SettingsViewController;

@protocol EditViewControllerDelegate

-(void) doneEditing;

@end

@interface EditViewController : UIViewController

-(void) setTitleText: (NSString *) text;
@property id delegate;

@end
