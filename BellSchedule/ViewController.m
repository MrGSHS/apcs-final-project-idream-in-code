//
//  ViewController.m
//  BellSchedule
//
//  Created by Rahman on 4/8/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "ViewController.h"
#import "CalendarLoader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Load calendar
    CalendarLoader *cl = [[CalendarLoader alloc] init];
    [cl downloadCalendarForSchool:@"aeshs" andWithCH:^{
        // Start up schedule upon completion
        sm = [[ScheduleManager alloc] init];
        
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        
        [t fire];
        

    }];

    
    }

-(void)updateUI {
  //  NSLog(@"Updating UI");
    [classPeriod setText:[sm periodForTime]];
    //Progress View Config
    [progressView setBackgroundColor:[UIColor clearColor]];
    [progressView setTintColor:[UIColor blackColor]];
    [progressView setBorderWidth:5.0f];
    [progressView setLineWidth:10.0f];
    [progressView setAnimationDuration:2.0];
    [progressView setProgress:[sm timeRatio] animated:YES];
    
    //Time remaining
    [timeLeft setText:[NSString stringWithFormat:@"%i minutes remaining", [sm timeRemaining]]];
    
    //Start to end
    [timeRange setText:[sm getClassLength]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
