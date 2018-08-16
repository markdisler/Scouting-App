//
//  CDSheet.h
//  ScoutApp2
//
//  Created by Mark on 7/27/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDSheetEntry, CDTeam;

@interface CDSheet : NSManagedObject

@property (nonatomic, retain) NSDate * dateModified;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isSharing;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSSet *teams;
@property (nonatomic, retain) NSSet *sheetEntries;
@end

@interface CDSheet ()
- (NSDictionary *)toJSONDictionary;
@end

@interface CDSheet (CoreDataGeneratedAccessors)

- (void)addTeamsObject:(CDTeam *)value;
- (void)removeTeamsObject:(CDTeam *)value;
- (void)addTeams:(NSSet *)values;
- (void)removeTeams:(NSSet *)values;

- (void)addSheetEntriesObject:(CDSheetEntry *)value;
- (void)removeSheetEntriesObject:(CDSheetEntry *)value;
- (void)addSheetEntries:(NSSet *)values;
- (void)removeSheetEntries:(NSSet *)values;

@end
