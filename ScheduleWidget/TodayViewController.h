//
//  TodayViewController.h
//  ScheduleWidget
//
//  Created by Rahman on 4/9/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScheduleManager.h"

@interface TodayViewController : UIViewController {
    IBOutlet UILabel *periodLabel;
    IBOutlet UIProgressView *timeRatio;
    IBOutlet UILabel *timeRemaining;
    ScheduleManager *sm;
}

@end
