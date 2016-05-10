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
    
    NSString *school = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"];
    if (school == nil || [school isEqualToString: @""]) {
        school = @"adlaiestevenson";
    }
    sm = [[ScheduleManager alloc] initWithSchool:school];
    NSString *period = [sm periodForTime];
    NSString *timeRem = [NSString stringWithFormat:@"%i minutes",(int)[sm timeRemaining]];
    [timeRatio setProgress:1-[sm timeRatio] animated:NO];
    [periodLabel setText:period];
    [timeRemaining setText:timeRem];
    
    NSLog(@"view did load");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    NSLog(@"updating widget");

    // Perform any setup necessary in order to update the view.
    NSString *period = [sm periodForTime];
    NSString *timeRem = [NSString stringWithFormat:@"%i minutes",(int)[sm timeRemaining]];
    [timeRatio setProgress:[sm timeRatio] animated:NO];
    [periodLabel setText:period];
    [timeRemaining setText:timeRem];
    completionHandler(NCUpdateResultNewData);
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)margins
{
    margins.bottom = 5.0;
    margins.right = 5.0;
    return margins;
}

@end
