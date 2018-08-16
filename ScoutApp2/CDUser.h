//
//  CDUser.h
//  ScoutApp2
//
//  Created by Mark on 11/14/15.
//  Copyright © 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CDSheet;

@interface CDUser : NSManagedObject

@property (nonatomic, retain) NSNumber * me;
@property (nonatomic, retain) NSNumber * userID;
@property (nonatomic, retain) NSString * userKey;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *sheets;

@end

@interface CDUser (CoreDataGeneratedAccessors)

- (void)addSheetsObject:(CDSheet *)value;
- (void)removeSheetsObject:(CDSheet *)value;
- (void)addSheets:(NSSet *)values;
- (void)removeSheets:(NSSet *)values;

@end
