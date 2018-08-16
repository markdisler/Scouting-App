//
//  SASlider.h
//  ScoutApp2
//
//  Created by Mark on 1/23/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SASlider : UIView

@property (nonatomic) BOOL enabled;

- (instancetype)initWithFrame:(CGRect)frame minimumValue:(float)min maximumValue:(float)max currentValue:(float)current;

- (void)setMinimumValue:(float)value;
- (void)setMaximumValue:(float)value;
- (void)setCurrentValue:(float)value;

- (void)setMinimumTrackTintColor:(UIColor *)color;
- (void)setMaximumTrackTintColor:(UIColor *)color;
- (void)setThumbTintColor:(UIColor *)color;

- (float)getSliderValue;
@end
