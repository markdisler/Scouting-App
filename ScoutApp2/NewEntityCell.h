//
//  NewEntityCell.h
//  ScoutApp2
//
//  Created by Mark on 7/19/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryButton.h"
#import "SASlider.h"
#import "SAStepper.h"

@interface NewEntityCell : UICollectionViewCell
- (void)setInputElement:(EntryType)type properties:(NSDictionary *)properties;
@property (strong, nonatomic) IBOutlet UIView *headingArea;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIView *inputArea;
@property (strong, nonatomic) IBOutlet EntryButton *dragButton;
@property (strong, nonatomic) IBOutlet EntryButton *editButton;
@end
