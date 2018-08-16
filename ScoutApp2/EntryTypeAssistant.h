//
//  EntryTypeAssistant.h
//  ScoutApp2
//
//  Created by Mark on 2/15/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SASlider.h"
#import "SAStepper.h"

@interface EntryTypeAssistant : NSObject
+ (NSString *)getValueFromView:(UIView *)inputView ofEntryType:(EntryType)entryType;
+ (NSString *)getDefaultValueForEntryType:(EntryType)entryType;
@end
