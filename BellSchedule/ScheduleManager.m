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
                NSArray *startAndEnd = [components[i] componentsSeparatedByString:@"/"];
                
                int firstHour = [[[startAndEnd[0] componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
                int firstMinute = [[[startAndEnd[0] componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
                int secondHour = [[[startAndEnd[1] componentsSeparatedByString:@":"] objectAtIndex:0] intValue];
                int secondMinute = [[[startAndEnd[1] componentsSeparatedByString:@":"] objectAtIndex:1] intValue];
                NSDateComponents *start = [[NSDateComponents alloc] init];
                [start setHour:firstHour];
                [start setMinute:firstMinute];
                NSDateComponents *end = [[NSDateComponents alloc] init];
                [end setHour:secondHour];
                [end setMinute:secondMinute];
                
                [times addObject:[[NSArray alloc] initWithObjects:start,end, nil]];
            }
        }
        [sched addObject:[[Schedule alloc] initScheduleWithTitle:title andTimes:times]];
    }
    
    return [sched copy];
}

-(BOOL)inSession {
    return (currentPeriod <_schedule.count && currentPeriod>=0);
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
        if (dates.count == 4) {
            
            
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
            }
    
        }
        
    }
    currentSchedule = [schedule objectAtIndex:0];
    currentPeriod = -1;

    return false;
}

-(void)updatePeriod {
    // Get current time
    currentPeriod = -1;
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    currentTime = [gregorianCal components: (NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute)
                                  fromDate: [NSDate date]];
    
    
   
    NSInteger hr = [currentTime hour];
    NSInteger min = [currentTime minute];
    
    
    for (int period = 0; period < _schedule.count; period++) {
        NSInteger startMin = [_schedule[period][1] minute];
        NSInteger startHr = [_schedule[period][1] hour];
        NSInteger endMin = [_schedule[period][2] minute];
        NSInteger endHr = [_schedule[period][2] hour];
      //  NSLog(@"%i:%i, %i:%i, %i:%i", (int)hr, (int)min, (int)startHr, (int)startMin,(int) endHr, (int)endMin);
        
        // Current time is between a classes start and end...
        if ([self aDateComponent:currentTime isBetween:_schedule[period][1] and:_schedule[period][2]] == 1) {
            currentPeriod = period;
        }
        
    }
}

-(int)aDateComponent:(NSDateComponents *)a isBetween:(NSDateComponents *)b and:(NSDateComponents *)c {
    
    // If 1: yes
    // If -1: no
    // If 0: on one of the borders
    
    if (([a hour] > [b hour] || ([a hour] == [b hour] && [a minute] > [b minute]))
        &&
        ([a hour] < [c hour] || ([a hour] == [c hour] && [a minute] < [c minute])))
    {
        return 1;
    }
    
    else {
        return -1;
    }
    
}

// Returns current period as a string
- (NSString *)periodForTime {
    [self updatePeriod];
    if ([self isWeekend]) return @"Weekend";
    
       if (currentPeriod == -1) {
        if ([self aDateComponent:currentTime isBetween:_schedule[0][1] and:_schedule[_schedule.count-1][2]] == 1) {
            return @"Passing period";
        }
        else return @"School is over";
    }
    
    return _schedule[currentPeriod][0];
}


// Returns length of class (time A - time B)
-(NSString *)getClassLength {
    
    
    if ([self inSession]) {
        int startHour = (int)[_schedule[currentPeriod][1] hour];
        int startMinute = (int)[_schedule[currentPeriod][1] minute];
        
        NSString *s = @"";
        if (startHour > 12) {
            startHour = startHour - 12;
            if (startHour == 0) s = [NSString stringWithFormat:@"12:%02i PM", startHour ];
            else s = [NSString stringWithFormat:@"%i:%02i PM", startHour, startMinute];
        }
        else {
            s = [NSString stringWithFormat:@"%i:%02i AM", startHour, startMinute];
            
        }
        int endHour = (int)[_schedule[currentPeriod][2] hour];
        int endMinute = (int)[_schedule[currentPeriod][2] minute];
        // NSLog(@"Start: %i    End: %i", start,end);
        
        NSString *e = @"";
        if (endHour > 12) {
            
            endHour = endHour - 12;
            if (endHour == 0) e = [NSString stringWithFormat:@"12:%02i PM", endHour];
            else e = [NSString stringWithFormat:@"%i:%02i PM",  endHour, endMinute];
        }
        else {
            e = [NSString stringWithFormat:@"%i:%02i AM", endHour, endMinute];
        }
        
        return [NSString stringWithFormat:@"%@ - %@", s,e];
    }
    return @"None.";
}

-(NSString *)getClassLengthOf:(NSInteger)period {
        if ([self inSession] && (period >= 0 && period <_schedule.count)) {
            int startHour = (int)[_schedule[period][1] hour];
            int startMinute = (int)[_schedule[period][1] minute];
            
            NSString *s = @"";
            if (startHour > 12) {
                startHour = startHour - 12;
                if (startHour == 0) s = [NSString stringWithFormat:@"12:%02i PM", startHour ];
                else s = [NSString stringWithFormat:@"%i:%02i PM", startHour, startMinute];
            }
            else {
                s = [NSString stringWithFormat:@"%i:%02i AM", startHour, startMinute];
                
            }
            int endHour = (int)[_schedule[period][2] hour];
            int endMinute = (int)[_schedule[period][2] minute];
            // NSLog(@"Start: %i    End: %i", start,end);
            
            NSString *e = @"";
            if (endHour > 12) {
                
                endHour = endHour - 12;
                if (endHour == 0) e = [NSString stringWithFormat:@"12:%02i PM", endHour];
                else e = [NSString stringWithFormat:@"%i:%02i PM",  endHour, endMinute];
            }
            else {
                e = [NSString stringWithFormat:@"%i:%02i AM", endHour, endMinute];
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
    [self updatePeriod];
    
    if (![self inSession]) {
        return 0;
    }
    NSInteger houri = [[_schedule[currentPeriod] objectAtIndex:2] hour];
    NSInteger minutei = [[_schedule[currentPeriod] objectAtIndex:2] minute];
    NSInteger hourf = [[_schedule[currentPeriod] objectAtIndex:1] hour];
    NSInteger minutef = [[_schedule[currentPeriod] objectAtIndex:1] minute];

    //  return ([_schedule[currentPeriod][2] intValue] -(float)t);
    // NSLog(@"h: %i, h2: %i, m: %i, m2: %i", hour,hour2,minute,min2);
    float totalClass =  ((houri - hourf)*60 + (minutei - minutef));

    
    
    return (1-([self timeRemaining]/ totalClass));
}

// Time remaining
-(NSInteger)timeRemaining {
    [self updatePeriod];
    if ([self inSession]) {
        // Convert back to components
        NSInteger houri = [[_schedule[currentPeriod] objectAtIndex:2] hour];
        NSInteger minutei = [[_schedule[currentPeriod] objectAtIndex:2] minute];
        NSInteger hourf = [currentTime hour];
        NSInteger minutef = [currentTime minute];
        //  return ([_schedule[currentPeriod][2] intValue] -(float)t);
        // NSLog(@"h: %i, h2: %i, m: %i, m2: %i", hour,hour2,minute,min2);
        return ((houri - hourf)*60 + (minutei - minutef));
        
    }
    return 0;
}

-(BOOL)isWeekend {
    int d = (int)[currentTime weekday];
    return (d  == 1 || d == 7);
    
}

@end
