//
//  SAStepper.m
//  ScoutApp2
//
//  Created by Mark on 1/23/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "SAStepper.h"

@interface SAStepper ()
@property (nonatomic, strong) UIStepper *stepper;
@property (nonatomic, strong) UILabel *minLbl;
@property (nonatomic, strong) UILabel *maxLbl;
@property (nonatomic, strong) UILabel *currentLbl;
@end

@implementation SAStepper

- (instancetype)initWithFrame:(CGRect)frame minimumValue:(float)min maximumValue:(float)max currentValue:(float)current {
    self = [super initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //Initialize components
        
        self.stepper = [[UIStepper alloc] initWithFrame:CGRectMake(0, 5, 120, 30)];
        self.stepper.translatesAutoresizingMaskIntoConstraints = NO;
        [self.stepper addTarget:self action:@selector(valueChanged) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.stepper];
        
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
        [self setCurrentValue:1000];
        
        //Size properly
        [self.minLbl sizeToFit];
        [self.maxLbl sizeToFit];
        [self.currentLbl sizeToFit];
        
        [self setCurrentValue:current];
        
        //Constraints
        [self.stepper.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [self.stepper.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [self.stepper.widthAnchor constraintEqualToConstant:self.stepper.frame.size.width].active = YES;
        [self.stepper.heightAnchor constraintEqualToConstant:self.stepper.frame.size.height].active = YES;
        
        [self.currentLbl.bottomAnchor constraintEqualToAnchor:self.stepper.topAnchor constant:0.0].active = YES;
        [self.currentLbl.centerXAnchor constraintEqualToAnchor:self.stepper.centerXAnchor constant:0.0].active = YES;
        [self.currentLbl.widthAnchor constraintEqualToConstant:self.currentLbl.frame.size.width].active = YES;
        [self.currentLbl.heightAnchor constraintEqualToConstant:self.currentLbl.frame.size.height].active = YES;
        
        [self.minLbl.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:2.0].active = YES;
        [self.minLbl.rightAnchor constraintEqualToAnchor:self.stepper.leftAnchor constant:-8.0].active = YES;
        [self.minLbl.widthAnchor constraintEqualToConstant:self.minLbl.frame.size.width].active = YES;
        [self.minLbl.heightAnchor constraintEqualToConstant:self.minLbl.frame.size.height].active = YES;
        
        [self.maxLbl.centerYAnchor constraintEqualToAnchor:self.centerYAnchor constant:2.0].active = YES;
        [self.maxLbl.leftAnchor constraintEqualToAnchor:self.stepper.rightAnchor constant:8.0].active = YES;
        [self.maxLbl.widthAnchor constraintEqualToConstant:self.maxLbl.frame.size.width].active = YES;
        [self.maxLbl.heightAnchor constraintEqualToConstant:self.maxLbl.frame.size.height].active = YES;

      //  [self.bottomAnchor constraintEqualToAnchor:self.stepper.bottomAnchor constant:0.0].active = YES;
        
    }
    return self;
}

- (void)valueChanged {
    [self setCurrentValue:self.stepper.value];
}

- (void)setMinimumValue:(float)value {
    self.stepper.minimumValue = value;
    [self.minLbl setText:[NSString stringWithFormat:@"%g", value]];
    
}

- (void)setMaximumValue:(float)value {
    self.stepper.maximumValue = value;
    [self.maxLbl setText:[NSString stringWithFormat:@"%g", value]];
    
}

- (void)setCurrentValue:(float)value {
    self.stepper.value = value;
    [self.currentLbl setText:[NSString stringWithFormat:@"%g", value]];
}

- (void)setStepperTintColor:(UIColor *)color {
    self.stepper.tintColor = color;
    self.minLbl.textColor = color;
    self.maxLbl.textColor = color;
    self.currentLbl.textColor = color;
}

- (float)getStepperValue {
    return self.stepper.value;
}

- (void)setEnabled:(BOOL)enabled {
    self.userInteractionEnabled = enabled;
    self.stepper.enabled = enabled;
    self.minLbl.enabled = enabled;
    self.maxLbl.enabled = enabled;
    self.currentLbl.enabled = enabled;
}

@end
