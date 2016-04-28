//
//  CalendarLoader.h
//  BellSchedule
//
//  Created by Rahman on 4/25/16.
//  Copyright © 2016 AliRahman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalendarLoader : NSObject <NSURLConnectionDataDelegate>
-(void)downloadCalendarForSchool:(NSString *)school andWithCH:(void (^)(void))completion;
@end
