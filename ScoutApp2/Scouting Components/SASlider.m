//
//  SASlider.m
//  ScoutApp2
//
//  Created by Mark on 1/23/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "SASlider.h"

@interface SASlider ()
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *minLbl;
@property (nonatomic, strong) UILabel *maxLbl;
@property (nonatomic, strong) UILabel *currentLbl;
@end

@implementation SASlider

- (instancetype)initWithFrame:(CGRect)frame minimumValue:(float)min maximumValue:(float)max currentValue:(float)current {
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //Initialize components
           
        self.slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 5, 110, 30)];
        self.slider.translatesAutoresizingMaskIntoConstraints = NO;
        self.slider.maximumTrackTintColor = [UIColor lightGrayColor];
        self.slider.continuous = YES;
        [self.slider addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.slider];
        
        self.minLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.minLbl.font = [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:16.0];
        self.minLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.minLbl];
        
        self.maxLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.maxLbl.font = [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:16.0];
        self.maxLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.maxLbl];
        
        self.currentLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.currentLbl.font = [UIFont fontWithName:DESIGN_FONTS_MAINFONT_MEDIUM size:18.0];
        self.currentLbl.textAlignment = NSTextAlignmentCenter;
        self.currentLbl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.currentLbl];
        
        //Set values
        [self setMinimumValue:min];
        [self setMaximumValue:max];
        [self setCurrentValue:current];
        
        //Size properly
        [self.minLbl sizeToFit];
        [self.maxLbl sizeToFit];
        [self.currentLbl sizeToFit];
        
        //Constraints
        [self.minLbl.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:12.0].active = YES;
        [self.minLbl.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:10.0].active = YES;
        [self.minLbl.widthAnchor constraintEqualToConstant:self.minLbl.frame.size.width].active = YES;
        [self.minLbl.heightAnchor constraintEqualToConstant:self.minLbl.frame.size.height].active = YES;
        
        [self.maxLbl.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:12.0].active = YES;
        [self.maxLbl.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-10.0].active = YES;
        [self.maxLbl.widthAnchor constraintEqualToConstant:self.maxLbl.frame.size.width].active = YES;
        [self.maxLbl.heightAnchor constraintEqualToConstant:self.maxLbl.frame.size.height].active = YES;

        [self.slider.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:12.0].active = YES;
        [self.slider.leftAnchor constraintEqualToAnchor:self.minLbl.rightAnchor constant:4.0].active = YES;
        [self.slider.rightAnchor constraintEqualToAnchor:self.maxLbl.leftAnchor constant:-4.0].active = YES;
        
        [self.currentLbl.topAnchor constraintEqualToAnchor:self.topAnchor constant:6.0].active = YES;
        [self.currentLbl.widthAnchor constraintEqualToConstant:self.currentLbl.frame.size.width+20].active = YES;
        [self.currentLbl.heightAnchor constraintEqualToConstant:self.currentLbl.frame.size.height].active = YES;
        [self.currentLbl.centerXAnchor constraintEqualToAnchor:self.slider.centerXAnchor constant:0.0].active = YES;
        
        [self.bottomAnchor constraintEqualToAnchor:self.slider.bottomAnchor constant:4.0].active = YES;
        
        
    }
    return self;
}

- (void)valueChanged {
    int discreteValue = roundl(self.slider.value); // Rounds float to an integer
    [self.slider setValue:(float)discreteValue];
    [self setCurrentValue:self.slider.value];
}

- (void)setMinimumValue:(float)value {
    self.slider.minimumValue = value;
    [self.minLbl setText:[NSString stringWithFormat:@"%g", value]];
    
}

- (void)setMaximumValue:(float)value {
    self.slider.maximumValue = value;
    [self.maxLbl setText:[NSString stringWithFormat:@"%g", value]];
    
}

- (void)setCurrentValue:(float)value {
    self.slider.value = value;
    [self.currentLbl setText:[NSString stringWithFormat:@"%g", value]];
}

- (void)setMinimumTrackTintColor:(UIColor *)color {
    self.slider.minimumTrackTintColor = color;
    self.minLbl.textColor = color;
    self.maxLbl.textColor = color;
    self.currentLbl.textColor = color;
}

- (void)setMaximumTrackTintColor:(UIColor *)color {
    self.slider.maximumTrackTintColor = color;
}

- (void)setThumbTintColor:(UIColor *)color {
    self.slider.thumbTintColor = color;
}

- (float)getSliderValue {
    return self.slider.value;
}

- (void)setEnabled:(BOOL)enabled {
    self.userInteractionEnabled = enabled;
    self.slider.enabled = enabled;
    self.minLbl.enabled = enabled;
    self.maxLbl.enabled = enabled;
    self.currentLbl.enabled = enabled;
}

@end
