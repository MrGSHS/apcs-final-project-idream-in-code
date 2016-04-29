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
    NSDateComponents *currentTime;
    int currentPeriod; //current period
    Schedule *currentSchedule;
}

@property (nonatomic,retain) NSArray *schedule;

- (NSString *)periodForTime;
-(float)timeRatio;
-(NSInteger)timeRemaining;
-(NSString *)getClassLength;
-(id)initWithSchool:(NSString *)s;
@end
