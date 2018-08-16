//
//  Constants.h
//  ScoutApp2
//
//  Created by Mark on 7/23/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EntryType) {
    EntryTypeSlider,
    EntryTypeStepper,
    EntryTypeToggle,
    EntryTypeTextField,
    EntryTypeSegmentedControl,
    EntryTypeNone
};

@interface Constants : NSObject

#pragma mark - App View Controller Titles
extern NSString *const VIEWCONTROLLER_TITLES_CREATESHEET;
extern NSString *const VIEWCONTROLLER_TITLES_SHEETSETTINGS;
extern NSString *const VIEWCONTROLLER_TITLES_ENTITYEDITOR;
extern NSString *const VIEWCONTROLLER_TITLES_PROPERTYEDITOR;
extern NSString *const VIEWCONTROLLER_TITLES_SHEETLIST;
extern NSString *const VIEWCONTROLLER_TITLES_COMPETITIONLIST;
extern NSString *const VIEWCONTROLLER_TITLES_TEAMLIST;
extern NSString *const VIEWCONTROLLER_TITLES_ADDTEAM;
extern NSString *const VIEWCONTROLLER_TITLES_SCOUTINGDATALIST;
extern NSString *const VIEWCONTROLLER_TITLES_APPSETTINGS;
extern NSString *const VIEWCONTROLLER_TITLES_THEMESELECTOR;

#pragma mark - Entry Type Keys
extern NSString *const KEYS_ENTRYTYPE_STEPPER_MINVALUE;
extern NSString *const KEYS_ENTRYTYPE_STEPPER_MAXVALUE;
extern NSString *const KEYS_ENTRYTYPE_SLIDER_MINVALUE;
extern NSString *const KEYS_ENTRYTYPE_SLIDER_MAXVALUE;

extern NSString *const KEYS_ENTRYTYPE_SEGMENT_FIRST;
extern NSString *const KEYS_ENTRYTYPE_SEGMENT_SECOND;
extern NSString *const KEYS_ENTRYTYPE_SEGMENT_THIRD;
extern NSString *const KEYS_ENTRYTYPE_SEGMENT_FOURTH;

extern NSString *const KEYS_ENTRYTYPE_TEXTFIELD_PLACEHOLDER;

#pragma mark - Design Strings
extern NSString *const DESIGN_FONTS_MAINFONT;
extern NSString *const DESIGN_FONTS_MAINFONT_MEDIUM;

@end
