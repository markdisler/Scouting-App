//
//  CDTeamAttribute.m
//  ScoutApp2
//
//  Created by Mark on 7/23/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "CDTeamAttribute.h"
#import "CDTeam.h"

@implementation CDTeamAttribute

@dynamic entryId;
@dynamic value;
@dynamic parentTeam;

- (NSDictionary *)toJSONDictionary {
    
    CDSheetEntry *entry = [[CDDataManager sharedInstance] getEntry:self.entryId sheet:self.parentTeam.parentSheet];
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    [jsonDict setObject:self.value forKey:@"value"];
    [jsonDict setObject:entry.positionOnList forKey:@"parentEntry"];  //@(self.entryId.integerValue)
    return [jsonDict copy];
}

@end
