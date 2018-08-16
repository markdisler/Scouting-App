//
//  CDSheetEntry.h
//  ScoutApp2
//
//  Created by Mark on 7/24/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDSheet;

@interface CDSheetEntry : NSManagedObject

@property (nonatomic, retain) NSString * entryId;
@property (nonatomic, retain) NSNumber * entryType;
@property (nonatomic, retain) NSNumber * positionOnList;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * entryProperties;
@property (nonatomic, retain) CDSheet *parentSheet;

@end

@interface CDSheetEntry ()
- (NSDictionary *)toJSONDictionary;
@end
