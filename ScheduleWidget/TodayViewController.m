//
//  TodayViewController.m
//  ScheduleWidget
//
//  Created by Rahman on 4/9/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolName"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue: @"adlaiestevenson" forKey:@"SchoolName"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Adlai E. Stevenson High School" forKey:@"SchoolDisplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *school = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"];
    
    sm = [[ScheduleManager alloc] initWithSchool:school];
    NSString *period = [sm periodForTime];
    NSString *timeRem = [NSString stringWithFormat:@"%i minutes",(int)[sm timeRemaining]];
    [timeRatio setProgress:1-[sm timeRatio] animated:NO];
    [periodLabel setText:period];
    [timeRemaining setText:timeRem];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    
    // Perform any setup necessary in order to update the view.
    NSString *period = [sm periodForTime];
    NSString *timeRem = [NSString stringWithFormat:@"%i minutes",(int)[sm timeRemaining]];
    [timeRatio setProgress:[sm timeRatio] animated:NO];
    if (period != periodLabel.text || timeRemaining.text != timeRem) {
        [periodLabel setText:period];
        [timeRemaining setText:timeRem];
        completionHandler(NCUpdateResultNewData);
    }
    
    /*  else if (timeRemaining != timeRem.text) {
     [timeRem setText:[timeRem]]
     }*/
    else {
        completionHandler(NCUpdateResultNoData);
    }
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.bottom = 10.0;
    margins.right = 5.0;
    return margins;
}

@end
