//
//  ViewController.h
//  BellSchedule
//
//  Created by Rahman on 4/8/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UAProgressView.h"
#import "ScheduleManager.h"
#import "SlideNavigationController.h"


@interface ViewController : UIViewController <SlideNavigationControllerDelegate>{
    SlideNavigationController *slideNavigation;
    IBOutlet UILabel *classPeriod;
    IBOutlet UILabel *timeLeft;
    IBOutlet UILabel *timeRange;
    IBOutlet UAProgressView *progressView;
    ScheduleManager *sm;
}



@end

