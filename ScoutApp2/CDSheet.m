//
//  CDSheet.m
//  ScoutApp2
//
//  Created by Mark on 7/27/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "CDSheet.h"
#import "CDSheetEntry.h"
#import "CDTeam.h"


@implementation CDSheet

@dynamic dateModified;
@dynamic imageName;
@dynamic identifier;
@dynamic name;
@dynamic isSharing;
@dynamic author;
@dynamic teams;
@dynamic sheetEntries;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];
    
    // Add name
    [jsonDict setObject:self.name forKey:@"name"];
    
    // Add Entries
    NSArray *entries = [self.sheetEntries allObjects];
    NSMutableArray *entriesInDictForm = [NSMutableArray array];
    for (CDSheetEntry *entry in entries) {
        [entriesInDictForm addObject:[entry toJSONDictionary]];
    }
    [jsonDict setObject:[entriesInDictForm copy] forKey:@"entries"];
    
    // Add Teams
    NSArray *teams = [self.teams allObjects];
    NSMutableArray *teamsInDictForm = [NSMutableArray array];
    for (CDTeam *team in teams) {
        [teamsInDictForm addObject:[team toJSONDictionary]];
    }
    [jsonDict setObject:[teamsInDictForm copy] forKey:@"teams"];
    
    return [jsonDict copy];
}

@end
