//
//  ScoutingDataCell.h
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SASlider.h"
#import "SAStepper.h"

@interface ScoutingDataCell : UITableViewCell
- (void)setInputElement:(EntryType)type properties:(NSDictionary *)properties value:(NSString *)val;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *inputArea;
@end
