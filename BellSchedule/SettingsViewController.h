//
//  SettingsViewController.h
//  BellSchedule
//
//  Created by Rahman on 5/3/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPGTextField.h"

@interface SettingsViewController : UITableViewController <MPGTextFieldDelegate, UITextFieldDelegate> {
    IBOutlet MPGTextField *schoolField;
    NSArray *schools;
    UITapGestureRecognizer *tapBackground;
    CGFloat textFieldCellHeight;
}

-(IBAction)setColorScheme:(id)sender;
-(IBAction)togglePushNotifications:(id)sender;

@end
