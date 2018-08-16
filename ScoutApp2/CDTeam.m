//
//  CDTeam.m
//  ScoutApp2
//
//  Created by Mark on 7/27/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "CDTeam.h"
#import "CDSheet.h"
#import "CDTeamAttribute.h"


@implementation CDTeam

@dynamic teamIdentifier;
@dynamic teamName;
@dynamic teamNumber;
@dynamic isFavorited;
@dynamic parentSheet;
@dynamic teamProperties;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *jsonDict = [NSMutableDictionary dictionary];

    // Add team name & number
    [jsonDict setObject:self.teamName forKey:@"name"];
    [jsonDict setObject:self.teamNumber forKey:@"teamNumber"];
    
    // Add Entry Responses
    NSArray *entryResponses = [self.teamProperties allObjects];
    NSMutableArray *responsesInDictForm = [NSMutableArray array];
    for (CDTeamAttribute *response in entryResponses) {
        [responsesInDictForm addObject:[response toJSONDictionary]];
    }
    [jsonDict setObject:[responsesInDictForm copy] forKey:@"entryResponses"];
    
    return [jsonDict copy];
}
@end
