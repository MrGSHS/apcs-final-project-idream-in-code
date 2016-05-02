//
//  ViewController.m
//  BellSchedule
//
//  Created by Rahman on 4/8/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "ViewController.h"
#import "CalendarLoader.h"
#import "ScheduleListViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View did load");
    [self config];
    }
-(void)config {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolName"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue: @"adlaiestevenson" forKey:@"SchoolName"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Adlai E. Stevenson High School" forKey:@"SchoolDisplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *school = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"];
    CalendarLoader *cl = [[CalendarLoader alloc] init];
    [cl downloadCalendarForSchool:school andWithCH:^{
        // Start up schedule upon completion (downloads schedule)
        sm = [[ScheduleManager alloc] initWithSchool:school];
        
        
        [[SlideNavigationController sharedInstance] setEnableSwipeGesture:YES];
        NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(updateUI) userInfo:nil repeats:YES];
        
        [t fire];
        
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self config];
    NSLog(@"View Will Appear");
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
    [timeLeft setText:[NSString stringWithFormat:@"%i minutes remaining", (int)[sm timeRemaining]]];
    
    //Start to end
    [timeRange setText:[sm getClassLength]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}


@end
