//
//  ScheduleManager.m
//  BellSchedule
//
//  Created by Rahman on 4/8/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "ScheduleManager.h"
@implementation ScheduleManager

- (id)initWithSchool:(NSString *)s{
    self = [super init];
    if (self) {
        if ([self updateScheduleWithSchool:s]) {
            NSLog(@"Found a schedule for today!");
        }
        else {
            NSLog(@"No schedule found for today.");
        }
        
        _schedule = [currentSchedule getArray];
    }
    return self;
}

//////////////////////////////////////////
// Methods used within this class  //////
////////////////////////////////////////

// Scrapes schedule of each school
-(NSArray *)getScheduleForSchool:(NSString *)school {
    
    NSMutableArray *sched = [[NSMutableArray alloc] init];
    NSError *err = nil;
    NSString *myTxtFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://alirahm.com/schedules/%@.txt", school]] encoding:NSUTF8StringEncoding error:&err];
    
    //Split by hyphen
    NSArray<NSString *> *schedules = [myTxtFile componentsSeparatedByString:@"-"];
    
    // Iterate through schedules
    for (NSString *arr in schedules) {
        
        // Separate by new line characters
        NSMutableArray<NSString *> *components = [[arr componentsSeparatedByString:@"\n"] mutableCopy];
        
        NSString *title = @"";
        NSMutableArray *times = [[NSMutableArray alloc] init];
        for (int i =0; i <components.count; i++) {
            [components removeObject:@""];
        //        NSLog(@"%@", components[i]);
                
            if (i == 0) {
                //This is the title of schedule
                title = components[i];
            }
            else {
                NSMutableArray *startAndEnd = [[components[i] componentsSeparatedByString:@"/"] mutableCopy];
         
                NSNumber * start = [NSNumber numberWithInteger:[startAndEnd[0] integerValue] ];
                NSNumber * end = [NSNumber numberWithInteger:[startAndEnd[1] integerValue]];
                [times addObject:[[NSArray alloc] initWithObjects:start,end, nil]];
            }
        }
       [sched addObject:[[Schedule alloc] initScheduleWithTitle:title andTimes:times]];
    }
    
    return [sched copy];
}

-(BOOL)inSession {
    return (p <_schedule.count && p>=0);
}

-(BOOL)updateScheduleWithSchool:(NSString *)s {
    NSArray *schedule = [self getScheduleForSchool:s];
    
    // Grab the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/calendar.txt",
                          documentsDirectory];
    NSString *file = [[NSString alloc] initWithContentsOfFile:fileName encoding:NSStringEncodingConversionAllowLossy error:nil];
    
    // Scrape file for current date
    NSDateComponents *c = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitDay fromDate:[NSDate date]];
    
    // Split by line
    NSArray *days = [file componentsSeparatedByString:@"\n"];
    
    for (NSString *d in days) {
        
        // Break down each line into components
        NSArray *dates = [d componentsSeparatedByString:@"-"];
        
        // FORMAT: type - month - day - year
        int month = [[dates objectAtIndex:1] intValue];
        int day = [[dates objectAtIndex:2] intValue];
        int year = [[dates objectAtIndex:3] intValue];
        NSString *type = [[dates objectAtIndex:0] stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([c month] == month && [c day] == day && [c year] == year) {
            
            for (Schedule *sched in schedule) {
                if ([[sched getTitle] isEqualToString:type]) {
                    currentSchedule = sched;
                    return true;
                }
            }
            currentSchedule = [schedule objectAtIndex:0];
            return false;
        }
        
    }
    currentSchedule = [schedule objectAtIndex:0];

    return false;

}

///////////////////////////////////////
// Methods that interact w/ VC  //////
/////////////////////////////////////

// Returns current period as a string
- (NSString *)periodForTime {
    p = -1;
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps = [gregorianCal components: (NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute)
                                                  fromDate: [NSDate date]];
    
    t = (int)[dateComps hour]* 100 + (int)[dateComps minute];
    int d = (int)[dateComps weekday];
    if (d == 0 || d == 7) return @"Weekend";
    
    
    int it = 0;
    
    while (it < _schedule.count && ([_schedule[it][1] intValue] > t || [_schedule[it][2] intValue] < t)) it++;
    p = it;
    if (it == _schedule.count) {
        if ([_schedule[0][1] intValue] > t || [[_schedule lastObject][2] intValue] < t) return @"School is over.";
        else return @"Passing period.";
    }
    
    return _schedule[it][0];
}


// Returns length of class (time A - time B)
-(NSString *)getClassLength {
    if ([self inSession]) {
        int start = [_schedule[p][1] intValue];
        NSString *s = @"";
        if (start > 1200) {
            start = start - 1200;
            if (start < 100) s = [NSString stringWithFormat:@"12:%02i PM", start];
            else s = [NSString stringWithFormat:@"%i:%02i PM", start / 100, start % 100];
        }
        else {
            s = [NSString stringWithFormat:@"%i:%02i AM", start / 100, start % 100];

        }
        int end = [_schedule[p][2] intValue];
        
       // NSLog(@"Start: %i    End: %i", start,end);
        
        NSString *e = @"";
        if (end > 1200) {
            
            end = end - 1200;
            if (end < 100) e = [NSString stringWithFormat:@"12:%02i PM", end];
            else e = [NSString stringWithFormat:@"%i:%02i PM",  end/100, end %100];
        }
        else {
            e = [NSString stringWithFormat:@"%i:%02i AM", end/100, end %100];
        }
        
        return [NSString stringWithFormat:@"%@ - %@", s,e];
    }
    return @"None.";
}


////////////////////////////////////
//  Utility Methods used for UI ///
//////////////////////////////////

// Time ratio for progress bars
-(float)timeRatio {
    if (![self inSession]) {
        return 0;
    }
    return (([_schedule[p][2] intValue] -(float)t )/ ([_schedule[p][2] intValue]-[_schedule[p][1] intValue] ));
}

// Time remaining
-(int)timeRemaining {
    if ([self inSession]) {
        return ([_schedule[p][2] intValue] -(float)t);
    }
    return 0;
}

@end
