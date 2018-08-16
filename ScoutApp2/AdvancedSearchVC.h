//
//  AdvancedSearchVC.h
//  ScoutApp2
//
//  Created by Matt Panzer on 1/26/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterEditVC.h"

@interface AdvancedSearchVC : UITableViewController <ConstraintProtocol>

@property (nonatomic, retain) NSMutableDictionary *constraints;
@property (nonatomic, strong) CDSheet *sheet;
@property (nonatomic, strong) NSArray *teamListForSheet;
@property (nonatomic, strong) NSMutableArray *searchRefinedList;
@property (nonatomic) BOOL sortByNumber;

@end
