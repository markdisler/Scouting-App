//
//  CDSheetEntry.m
//  ScoutApp2
//
//  Created by Mark on 7/24/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "CDSheetEntry.h"
#import "CDSheet.h"


@implementation CDSheetEntry

@dynamic entryId;
@dynamic entryType;
@dynamic positionOnList;
@dynamic title;
@dynamic entryProperties;
@dynamic parentSheet;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setObject:self.entryType forKey:@"type"];
    [jsonDict setObject:self.entryProperties forKey:@"entryProperties"];
    [jsonDict setObject:self.positionOnList forKey:@"position"];
    [jsonDict setObject:self.title forKey:@"title"];
    return [jsonDict copy];
}

@end
