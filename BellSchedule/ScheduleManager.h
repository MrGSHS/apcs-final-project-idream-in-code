//
//  ScheduleManager.h
//  BellSchedule
//
//  Created by Rahman on 4/8/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Schedule.h"

@interface ScheduleManager : NSObject {
    int t; //current time
    int p; //current period
    Schedule *currentSchedule;
}

@property (nonatomic,retain) NSArray *schedule;

- (NSString *)periodForTime;
-(float)timeRatio;
-(int)timeRemaining;
-(NSString *)getClassLength;

@end
