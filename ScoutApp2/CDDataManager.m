//
//  CDDataManager.m
//  ScoutApp2
//
//  Created by Mark on 7/23/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "CDDataManager.h"
#import "AppDelegate.h"

@implementation CDDataManager

#pragma mark - Main Stuff

+ (instancetype)sharedInstance {
    static CDDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CDDataManager alloc] init];
    });
    return sharedInstance;
}

- (NSString *)randomStringWithLength:(NSInteger)length {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat:@"%C", [letters characterAtIndex:arc4random() % [letters length]]];
    }
    return randomString;
}

#pragma mark - Creating Users

- (CDUser *)createUserWithUserID:(NSInteger)userID key:(NSString *)userKey name:(NSString *)name ownerIsMe:(BOOL)me {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    CDUser *user = [NSEntityDescription insertNewObjectForEntityForName:@"CDUser" inManagedObjectContext:context];
    user.userID = [NSNumber numberWithInteger:userID];
    user.userKey = userKey;
    user.name = name;
    user.me = [NSNumber numberWithBool:me];
    [context save:nil];
    return user;
}

- (CDUser *)findMyself {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"CDUser"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(me = %@)", [NSNumber numberWithBool:YES]];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:nil];
    if (objects.count == 0) {
        return nil;
    } else {
        CDUser *match = objects[0];
        return match;
    }
}

#pragma mark - Creating and Managing a Sheet

- (CDSheet *)addSheet:(NSString *)name {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    CDSheet *sheet = [NSEntityDescription insertNewObjectForEntityForName:@"CDSheet" inManagedObjectContext:context];
    sheet.dateModified = [NSDate date];
    sheet.identifier = [NSNumber numberWithInteger:[self availableSheetID]];
    sheet.name = name;
    [context save:nil];
    return sheet;
}

- (NSInteger)availableSheetID {
    NSArray <CDSheet *> *sheetList = [self getSheetList];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"identifier" ascending:YES];
    sheetList = [sheetList sortedArrayUsingDescriptors:@[sortDesc]];
    
    if (sheetList.count == 0) {
        return 0;
    }
    
    NSInteger lastID = [sheetList lastObject].identifier.integerValue;
    return lastID + 1;
}


- (CDSheet *)getSheetWithIdentifier:(NSInteger)uniqueID {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"CDSheet"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(identifier = %@)", [NSNumber numberWithInteger:uniqueID]];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:nil];
    CDSheet *match = objects[0];
    return match;
}

- (void)updateIdentifierForSheet:(CDSheet *)sheet identifier:(NSInteger)identifier {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    sheet.identifier = [NSNumber numberWithInteger:identifier];
    [context save:nil];
}

- (void)renameSheet:(CDSheet *)sheet newName:(NSString *)name {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    sheet.name = name;
    [context save:nil];
}

- (void)setImageForSheet:(CDSheet *)sheet imageName:(NSString *)imgName {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    sheet.imageName = imgName;
    [context save:nil];
}

- (NSArray *)getSheetList {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"CDSheet"];
    NSArray *objects = [context executeFetchRequest:request error:nil];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"dateModified" ascending:NO];
    objects = [objects sortedArrayUsingDescriptors:@[sortDesc]];
    return objects;
}

- (void)setSharingStateForSheet:(CDSheet *)sheet sharingState:(BOOL)sharing {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    sheet.isSharing = [NSNumber numberWithBool:sharing];
    [context save:nil];
}

- (void)removeSheet:(CDSheet *)sheet {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    [context deleteObject:sheet];
    [context save:nil];
}

#pragma mark - Creating and Managing the Entries in Sheet

- (NSString *)addSheetEntryToSheet:(CDSheet *)sheet title:(NSString *)title entryType:(NSInteger)entryType {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    CDSheetEntry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"CDSheetEntry" inManagedObjectContext:context];
    entry.title = title;
    entry.entryType = [NSNumber numberWithInteger:entryType];
    entry.entryId = [NSString stringWithFormat:@"%ld", (long)[self availableEntryIDForSheet:sheet]];
    entry.positionOnList = [NSNumber numberWithInteger:sheet.sheetEntries.count];
    [sheet addSheetEntriesObject:entry];
    [context save:nil];
    
    return entry.entryId;
}

- (NSInteger)availableEntryIDForSheet:(CDSheet *)sheet {
    NSArray <CDSheetEntry *> *entryList = [self getEntryListForSheet:sheet];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"entryId" ascending:YES];
    entryList = [entryList sortedArrayUsingDescriptors:@[sortDesc]];
    
    if (entryList.count == 0) {
        return 0;
    }
    
    NSInteger lastID = [entryList lastObject].entryId.integerValue;
    return lastID + 1;
}
                     
- (NSArray *)getEntryListForSheet:(CDSheet *)sheet {
    NSArray *objects = [sheet.sheetEntries allObjects];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"positionOnList" ascending:YES];
    objects = [objects sortedArrayUsingDescriptors:@[sortDesc]];
    return objects;
}

- (void)changePositionOnListOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet newPosition:(NSInteger)pos {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray *allEntriesInSheet = [self getEntryListForSheet:sheet];
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", entryID];
    CDSheetEntry *entryToMove = [allEntriesInSheet filteredArrayUsingPredicate:pred][0];
    NSLog(@"%@", entryToMove.title);
    NSInteger oldLocation = entryToMove.positionOnList.integerValue;
    entryToMove.positionOnList = [NSNumber numberWithInteger:pos];
    
    NSMutableArray *mutableEntries = [NSMutableArray arrayWithArray:allEntriesInSheet];
    [mutableEntries exchangeObjectAtIndex:oldLocation withObjectAtIndex:pos];
    allEntriesInSheet = [mutableEntries copy];
    
    for (NSInteger i = 0; i < allEntriesInSheet.count; i++) {
        CDSheetEntry *entry = [allEntriesInSheet objectAtIndex:i];
        entry.positionOnList = [NSNumber numberWithInteger:i];
    }
    
    [context save:nil];
}

- (void)changeTitleOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet newTitle:(NSString *)title {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray *allEntriesInSheet = [self getEntryListForSheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", entryID];
    CDSheetEntry *entry = [allEntriesInSheet filteredArrayUsingPredicate:pred][0];
    entry.title = title;
    [context save:nil];
}

- (void)changeTypeOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet newType:(NSInteger)type {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray *allEntriesInSheet = [self getEntryListForSheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", entryID];
    CDSheetEntry *entry = [allEntriesInSheet filteredArrayUsingPredicate:pred][0];
    entry.entryType = [NSNumber numberWithInteger:type];
    [context save:nil];
}

- (void)setPropertiesOfEntry:(NSString *)entryID onSheet:(CDSheet *)sheet properties:(NSString *)propStr {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray *allEntriesInSheet = [self getEntryListForSheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", entryID];
    CDSheetEntry *entry = [allEntriesInSheet filteredArrayUsingPredicate:pred][0];
    entry.entryProperties = propStr;
    [context save:nil];
}

- (void)removeEntryFromSheet:(CDSheet *)sheet entry:(NSString *)entryID {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray *allEntries = [self getEntryListForSheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", entryID];
    CDSheetEntry *entry = [allEntries filteredArrayUsingPredicate:pred][0];
    [context deleteObject:entry];
    
    NSArray *allEntriesInSheet = [self getEntryListForSheet:sheet];
    for (NSInteger i = 0; i < allEntriesInSheet.count; i++) {
        CDSheetEntry *entry = [allEntriesInSheet objectAtIndex:i];
        entry.positionOnList = [NSNumber numberWithInteger:i];
    }
    
    [context save:nil];
}

- (CDSheetEntry *)getEntry:(NSString *)entryID sheet:(CDSheet *)sheet {
    NSArray *allEntries = [self getEntryListForSheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", entryID];
    CDSheetEntry *entry = [allEntries filteredArrayUsingPredicate:pred][0];
    return entry;
}

#pragma mark - Teams

- (NSString *)addTeamToSheet:(CDSheet *)sheet teamName:(NSString *)name teamNumber:(NSString *)number {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    CDTeam *team = [NSEntityDescription insertNewObjectForEntityForName:@"CDTeam" inManagedObjectContext:context];
    team.teamIdentifier = [self randomStringWithLength:8];
    team.teamName = name;
    team.teamNumber = number;
    team.isFavorited = [NSNumber numberWithBool:NO];
    [sheet addTeamsObject:team];
    [context save:nil];
    return team.teamIdentifier;
}

- (NSArray *)getFavoritedTeamListForSheet:(CDSheet *)sheet {
    NSArray *objects = [sheet.teams allObjects];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(isFavorited == %@)", [NSNumber numberWithBool:YES]];
    NSArray *result = [objects filteredArrayUsingPredicate:pred];
    return result;
}

- (void)setFavoritedTeam:(NSString *)teamID favorited:(BOOL)isFavoried {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"CDTeam"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(teamIdentifier = %@)", teamID];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:nil];
    CDTeam *match = objects[0];
    match.isFavorited = [NSNumber numberWithBool:isFavoried];
    [context save:nil];
}

- (NSArray *)getTeamListForSheet:(CDSheet *)sheet {
    NSArray *objects = [sheet.teams allObjects];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"teamNumber" ascending:YES];
    objects = [objects sortedArrayUsingDescriptors:@[sortDesc]];
    return objects;
}

- (void)removeTeamFromSheet:(CDSheet *)sheet teamID:(NSString *)teamID {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSArray *allTeams = [self getTeamListForSheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(teamIdentifier = %@)", teamID];
    CDTeam *team = [allTeams filteredArrayUsingPredicate:pred][0];
    [context deleteObject:team];
    [context save:nil];
}

- (CDTeam *)getTeam:(NSString *)teamID inSheet:(CDSheet *)sheet {
    NSArray *allTeams = [self getTeamListForSheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(teamIdentifier = %@)", teamID];
    CDTeam *team = [allTeams filteredArrayUsingPredicate:pred][0];
    return team;
}

#pragma mark - Team Attribute

- (NSArray *)getAttributesForTeam:(NSString *)teamID sheet:(CDSheet *)sheet {
    CDTeam *team = [self getTeam:teamID inSheet:sheet];
    NSArray *objects = [team.teamProperties allObjects];
    return objects;
}

- (CDTeamAttribute *)getAttributeWithIdentifier:(NSString *)attribID forTeam:(NSString *)teamID sheet:(CDSheet *)sheet {
    NSArray *allAttributes = [self getAttributesForTeam:teamID sheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", attribID];
    NSArray *refinedAttrib = [allAttributes filteredArrayUsingPredicate:pred];
    if (refinedAttrib.count > 0 )
        return [refinedAttrib objectAtIndex:0];
    else
        return nil;
}

- (void)updateAttribute:(NSString *)entryId withValue:(NSString *)val forTeam:(NSString *)teamID sheet:(CDSheet *)sheet {
    NSArray *allAttributes = [self getAttributesForTeam:teamID sheet:sheet];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(entryId = %@)", entryId];
    NSArray *refinedAttrib = [allAttributes filteredArrayUsingPredicate:pred];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    if (refinedAttrib.count == 0) {
        //THIS ATTRIB DOESNT EXIST YET, CREATE IT
        CDTeam *team = [self getTeam:teamID inSheet:sheet];
        CDTeamAttribute *teamAttrib = [NSEntityDescription insertNewObjectForEntityForName:@"CDTeamAttribute" inManagedObjectContext:context];
        teamAttrib.entryId = entryId;
        teamAttrib.value = val;
        [team addTeamPropertiesObject:teamAttrib];
        [context save:nil];
    } else {
        //Attribute Exists - edit it
        CDTeamAttribute *attribToEdit = refinedAttrib[0];
        attribToEdit.value = val;
        [context save:nil];
    }

}

@end
