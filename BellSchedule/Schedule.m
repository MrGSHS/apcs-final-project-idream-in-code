//
//  Schedule.m
//  BellSchedule
//
//  Created by Rahman on 4/20/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "Schedule.h"

@implementation Schedule

-(id)initScheduleWithTitle:(NSString *)name andTimes:(NSArray<NSArray *> *)time {
    self = [super init];
    if (self) {
        title = name;
        times = time;
    }
    return  self;
}

-(NSString *)getTitle {
    return title;
}

-(NSArray <NSArray *> *)getTimes {
    return times;
}

-(NSArray *)getArray {
    
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < times.count; i++)
        [arr addObject:[[NSArray alloc] initWithObjects:[NSString stringWithFormat:@"Period %i", i+1], times[i][0], times[i][1], nil]];
    
    return arr;
}

@end
