//
//  AppDelegate.h
//  BellSchedule
//
//  Created by Rahman on 4/8/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WatchConnectivity/WatchConnectivity.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate, WCSessionDelegate> {
    WCSession *session;
}

@property (strong, nonatomic) UIWindow *window;


@end

