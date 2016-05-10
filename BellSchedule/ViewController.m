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
#import <WatchConnectivity/WatchConnectivity.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"View did load");
    [self config];
}

-(void)config {
    
    // Grab default color
    //http://stackoverflow.com/questions/1275662/saving-uicolor-to-and-loading-from-nsuserdefaults

    // Main Color
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"mainColor"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:self.view.backgroundColor] forKey:@"mainColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSData *mainColorData =[[NSUserDefaults standardUserDefaults] objectForKey:@"mainColor"];
        UIColor *mainColor = [NSKeyedUnarchiver unarchiveObjectWithData:mainColorData];
        [[[SlideNavigationController sharedInstance] view] setBackgroundColor:mainColor];
        [self.view setBackgroundColor:mainColor];
    }
    
    // Secondary Color
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"secondaryColor"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:[[[SlideNavigationController sharedInstance] navigationBar] barTintColor]] forKey:@"secondaryColor"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
        NSData *secondaryColorData =[[NSUserDefaults standardUserDefaults] objectForKey:@"secondaryColor"];
        UIColor *secondaryColor = [NSKeyedUnarchiver unarchiveObjectWithData:secondaryColorData];
        [[[SlideNavigationController sharedInstance] navigationBar] setBarTintColor:secondaryColor];
    }
    
    // School defaults
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SchoolName"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue: @"adlaiestevenson" forKey:@"SchoolName"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Adlai E. Stevenson High School" forKey:@"SchoolDisplay"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    NSString *school = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"];
    NSString *schoolName = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolDisplay"];
    [[[[SlideNavigationController sharedInstance] navigationBar]topItem] setTitle:schoolName];
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
    ScheduleListViewController *slvc = (ScheduleListViewController *)[[SlideNavigationController sharedInstance] leftMenu];
    [slvc updateTable];
    NSLog(@"View Will Appear");
}

-(void)updateUI {
    
    
    // Return period text
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
