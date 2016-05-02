//
//  ScheduleListViewController.h
//  BellSchedule
//
//  Created by Rahman on 4/29/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleManager.h"

@interface ScheduleListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    ScheduleManager *scheduleManager;
}
-(IBAction)openSettings;

@end
