//
//  SheetCell.m
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "SheetCell.h"

@implementation SheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sharingIndicator.layer.cornerRadius = self.sharingIndicator.frame.size.width/2;
}

@end
