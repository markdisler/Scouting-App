//
//  SARoundButton.m
//  ScoutApp2
//
//  Created by Mark on 2/14/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "SARoundButton.h"

@implementation SARoundButton

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutIfNeeded];
    self.layer.cornerRadius = self.frame.size.width / 2;
}

@end
