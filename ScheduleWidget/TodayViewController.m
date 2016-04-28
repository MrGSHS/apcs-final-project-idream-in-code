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
    sm = [[ScheduleManager alloc] init];
    NSString *period = [sm periodForTime];
    [timeRemaining setProgress:[sm timeRatio] animated:NO];
    [periodLabel setText:period];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    NSString *period = [sm periodForTime];
    [timeRemaining setProgress:[sm timeRatio] animated:NO];
    if (period != periodLabel.text) {
        [periodLabel setText:period];
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