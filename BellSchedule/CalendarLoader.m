//
//  CalendarLoader.m
//  BellSchedule
//
//  Created by Rahman on 4/25/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import "CalendarLoader.h"
#import "MXLCalendarManager.h"

@implementation CalendarLoader

// http://stackoverflow.com/questions/5619719/write-a-file-on-ios //

-(void)downloadCalendarForSchool:(NSString *)school andWithCH:(void (^)(void))completion{
    // Download .ics file
    
    MXLCalendarManager *m = [[MXLCalendarManager alloc] init];
    // grab calendar file from website
    [m scanICSFileAtRemoteURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://alirahm.com/calendars/%@.ics", school]] withCompletionHandler:^(MXLCalendar *cal, NSError *e){
        
        //make a file name to write the data to using the shared app directory:
        NSString *groupURL = [[[NSFileManager defaultManager]
                           containerURLForSecurityApplicationGroupIdentifier:
                           @"group.com.alirahman.schedule"] path];
        NSString *fileName = [NSString stringWithFormat:@"%@calendar.txt",
                              groupURL];

      

        //create content - four lines of text
        NSMutableString *content = [[NSMutableString alloc] initWithString:@""];
        
        for (MXLCalendarEvent *calEv in [cal events]) {
            NSDateComponents *dc = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[calEv eventStartDate]];
            // Formatting for the file
            // Type of day - month - day - year
          //  NSLog(@"Summary: %@\nDescription:%@",[calEv eventSummary], [calEv eventDescription]);
            [content appendString:[NSString stringWithFormat:@"%@ - %@ - %@ - %@ \n", [calEv eventSummary] ,[@([dc month]) stringValue], [@([dc day]) stringValue], [@([dc year]) stringValue]]];
            
        }
        
        BOOL success = [content writeToFile:fileName
                  atomically:YES
                    encoding:NSStringEncodingConversionAllowLossy
                       error:nil];
        NSLog(@"%i",success);
        

    }];
    completion();

    
    
}



@end
