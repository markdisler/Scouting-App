//
//  CDDataManager.h
//  ScoutApp2
//
//  Created by Mark on 7/23/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CDSheet;
@class CDCompetition;
@class CDUser;
@class CDTeam;
@class CDSheetEntry;
@class CDTeamAttribute;

@interface CDDataManager : NSObject

+ (instancetype)sharedInstance;

- (CDUser *)createUserWithUserID:(NSInteger)userID key:(NSString *)userKey name:(NSString *)name ownerIsMe:(BOOL)me;
- (CDUser *)findMyself;

#pragma mark - Creating and Managing a Sheet
- (CDSheet *)addSheet:(NSString *)name;
//- (CDSheet *)getSheetWithIdentifier:(NSInteger)uniqueID;
- (void)updateIdentifierForSheet:(CDSheet *)sheet identifier:(NSInteger)identifier;
- (void)renameSheet:(CDSheet *)sheet newName:(NSString *)name;
- (void)setImageForSheet:(CDSheet *)sheet imageName:(NSString *)imgName;
- (NSArray *)getSheetList;
- (void)setSharingStateForSheet:(CDSheet *)sheet sharingState:(BOOL)sharing;
- (void)removeSheet:(CDSheet *)sheet;

#pragma mark - Creating and Managing the Entries in Sheet
- (NSString *)addSheetEntryToSheet:(CDSheet *)sheet title:(NSString *)title entryType:(NSInteger)entryType;
- (NSArray *)getEntryListForSheet:(CDSheet *)sheet;
- (void)changePositionOnListOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet newPosition:(NSInteger)pos;
- (void)changeTitleOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet newTitle:(NSString *)title;
- (void)changeTypeOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet newType:(NSInteger)type;
- (void)setPropertiesOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet properties:(NSString *)propStr;
- (void)removeEntryFromSheet:(CDSheet *)sheet entry:(NSString *)entryID;
- (CDSheetEntry *)getEntry:(NSString *)entryID sheet:(CDSheet *)sheet;

#pragma mark - Teams
- (NSArray *)getFavoritedTeamListForSheet:(CDSheet *)sheet;
- (void)setFavoritedTeam:(NSString *)teamID favorited:(BOOL)isFavoried;
- (NSString *)addTeamToSheet:(CDSheet *)sheet teamName:(NSString *)name teamNumber:(NSString *)number;
- (NSArray *)getTeamListForSheet:(CDSheet *)sheet;
- (void)removeTeamFromSheet:(CDSheet *)sheet teamID:(NSString *)teamID;
- (CDTeam *)getTeam:(NSString *)teamID inSheet:(CDSheet *)sheet;

#pragma mark - Team Attribute
- (NSArray *)getAttributesForTeam:(NSString *)teamID sheet:(CDSheet *)sheet;
- (void)updateAttribute:(NSString *)entryIdentifier withValue:(NSString *)val forTeam:(NSString *)teamID sheet:(CDSheet *)sheet;
- (CDTeamAttribute *)getAttributeWithIdentifier:(NSString *)attribID forTeam:(NSString *)teamID sheet:(CDSheet *)sheet;

@end
