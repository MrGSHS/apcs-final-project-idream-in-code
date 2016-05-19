//
//  AppDelegate.m
//  BellSchedule
//
//  Created by Rahman on 4/8/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "AppDelegate.h"
#import "ScheduleListViewController.h"
#import "SlideNavigationController.h"
#import "CalendarLoader.h"
#import "ScheduleManager.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // If watch connectivity is necessary...
    
    if ([WCSession isSupported]) {
        session = [WCSession defaultSession];
        [session setDelegate:self];
        [session activateSession];
    }
    
    
    // Set up left "drawer"
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [[NSUserDefaults standardUserDefaults] setValue:@(NO) forKey:@"_UIConstraintBasedLayoutLogUnsatisfiable"];
    ScheduleListViewController *leftMenu = (ScheduleListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"scheduleList"];
    [SlideNavigationController sharedInstance].leftMenu = leftMenu;
    
    // http://stackoverflow.com/questions/24100313/ask-for-user-permission-to-receive-uilocalnotifications-in-ios-8
    
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


-(void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    
    NSString *school = [[NSUserDefaults standardUserDefaults] valueForKey:@"SchoolName"];
    
    // Start up schedule upon completion (downloads schedule)
    ScheduleManager *sm = [[ScheduleManager alloc] initWithSchool:school];
    replyHandler(@{@"period": sm.periodForTime, @"length":[sm getClassLength], @"duration": [NSNumber numberWithInteger:[sm timeRemaining]], @"ratio": [NSNumber numberWithFloat:[sm timeRatio]]});
    
}


@end
