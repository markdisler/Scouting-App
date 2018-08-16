//
//  CDTeam.h
//  ScoutApp2
//
//  Created by Mark on 7/27/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDSheet, CDTeamAttribute;

@interface CDTeam : NSManagedObject

@property (nonatomic, retain) NSString * teamIdentifier;
@property (nonatomic, retain) NSString * teamName;
@property (nonatomic, retain) NSString * teamNumber;
@property (nonatomic, retain) NSNumber * isFavorited;
@property (nonatomic, retain) CDSheet *parentSheet;
@property (nonatomic, retain) NSSet *teamProperties;
@end

@interface CDTeam ()
- (NSDictionary *)toJSONDictionary;
@end

@interface CDTeam (CoreDataGeneratedAccessors)

- (void)addTeamPropertiesObject:(CDTeamAttribute *)value;
- (void)removeTeamPropertiesObject:(CDTeamAttribute *)value;
- (void)addTeamProperties:(NSSet *)values;
- (void)removeTeamProperties:(NSSet *)values;

@end
