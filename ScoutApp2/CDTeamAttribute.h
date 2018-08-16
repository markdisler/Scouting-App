//
//  CDTeamAttribute.h
//  ScoutApp2
//
//  Created by Mark on 7/23/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDTeam;

@interface CDTeamAttribute : NSManagedObject

@property (nonatomic, retain) NSString * entryId;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) CDTeam *parentTeam;

@end

@interface CDTeamAttribute ()
- (NSDictionary *)toJSONDictionary;
@end
