//
//  EntryTypeAssistant.m
//  ScoutApp2
//
//  Created by Mark on 2/15/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "EntryTypeAssistant.h"

@implementation EntryTypeAssistant


+ (NSString *)getValueFromView:(UIView *)inputView ofEntryType:(EntryType)entryType {
    NSString *value = @"";
    switch (entryType) {
        case EntryTypeSegmentedControl:{
            UISegmentedControl *seg = (UISegmentedControl *)inputView;
            value = [NSString stringWithFormat:@"%ld", (long)seg.selectedSegmentIndex];
            break;
        }
        case EntryTypeSlider: {
            SASlider *slider = (SASlider *)inputView;
            value = [NSString stringWithFormat:@"%f", [slider getSliderValue]];
            break;
        }
        case EntryTypeStepper: {
            SAStepper *stepper = (SAStepper *)inputView;
            value = [NSString stringWithFormat:@"%f", [stepper getStepperValue]];
            break;
        }
        case EntryTypeTextField:{
            UITextField *field = (UITextField *)inputView;
            value = field.text;
            break;
        }
        case EntryTypeToggle:{
            UISwitch *toggle = (UISwitch *)inputView;
            value = toggle.isOn ? @"1" : @"0";
            break;
        }
        case EntryTypeNone:{
            break;
        }
    }
    return value;
}

+ (NSString *)getDefaultValueForEntryType:(EntryType)entryType {
    NSString *value = @"";
    switch (entryType) {
        case EntryTypeSegmentedControl:{
            value = @"0";
            break;
        }
        case EntryTypeSlider: {
            value = @"0";
            break;
        }
        case EntryTypeStepper: {
            value = @"0";
            break;
        }
        case EntryTypeTextField:{
            value = @"";
            break;
        }
        case EntryTypeToggle:{
            value = @"0";
            break;
        }
        case EntryTypeNone:{
            break;
        }
    }
    return value;
}

@end
