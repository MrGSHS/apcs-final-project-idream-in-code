//
//  Schedule.h
//  BellSchedule
//
//  Created by Rahman on 4/20/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Schedule : NSObject {
    NSString *title;
    NSArray *times;
}

-(id)initScheduleWithTitle:(NSString *)name andTimes:(NSArray <NSArray *> *)times;
-(NSString *)getTitle;
-(NSArray <NSArray *> *)getTimes;
-(NSArray *)getArray;

@end
