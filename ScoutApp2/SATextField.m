//
//  SATextField.m
//  ScoutApp2
//
//  Created by Mark on 2/13/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "SATextField.h"

@implementation SATextField

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect relativeFrame = self.bounds;
    UIEdgeInsets hitTestEdgeInsets = UIEdgeInsetsMake(-15, -15, -15, -15);
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets);
    return CGRectContainsPoint(hitFrame, point);
}

@end
