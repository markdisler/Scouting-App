//
//  PropertyEditorVC.h
//  ScoutApp2
//
//  Created by Mark on 7/3/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PropertyCell.h"

@protocol PropertiesDelegate
- (void)usePropertyData:(NSDictionary *)dictionary;
@end

@interface PropertyEditorVC : UITableViewController
@property (nonatomic, weak) id<PropertiesDelegate> delegate;
@property (nonatomic, assign) EntryType entryType;
@property (nonatomic, strong) NSDictionary *properties;
@end
