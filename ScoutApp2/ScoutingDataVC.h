//
//  ScoutingDataVC.h
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASlider.h"
#import "SAStepper.h"
#import "EntryTypeAssistant.h"

@interface ScoutingDataVC : UITableViewController
- (void)reloadData;
@property (nonatomic, strong) CDSheet *sheet;
@property (nonatomic, strong) CDTeam *team;
@end
