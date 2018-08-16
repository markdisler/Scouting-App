//
//  NewEntityself.m
//  ScoutApp2
//
//  Created by Mark on 7/19/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "NewEntityCell.h"
#import "UIColor+CCColors.h"

@implementation NewEntityCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
}


- (void)setInputElement:(EntryType)type properties:(NSDictionary *)properties {

    for (UIView *sv in self.inputArea.subviews) {
        [sv removeFromSuperview];
    }
    
    switch (type) {
        case EntryTypeSegmentedControl:{
            NSString *choice1 = [properties valueForKey:KEYS_ENTRYTYPE_SEGMENT_FIRST];
            NSString *choice2 = [properties valueForKey:KEYS_ENTRYTYPE_SEGMENT_SECOND];
            NSString *choice3 = [properties valueForKey:KEYS_ENTRYTYPE_SEGMENT_THIRD];
            NSString *choice4 = [properties valueForKey:KEYS_ENTRYTYPE_SEGMENT_FOURTH];
            NSMutableArray *allChoices = [NSMutableArray array];
            if (choice1 && ![choice1 isEqualToString:@""])  [allChoices addObject:choice1];
            if (choice2 && ![choice2 isEqualToString:@""])  [allChoices addObject:choice2];
            if (choice3 && ![choice3 isEqualToString:@""])  [allChoices addObject:choice3];
            if (choice4 && ![choice4 isEqualToString:@""])  [allChoices addObject:choice4];

            UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:[allChoices copy]];
            seg.translatesAutoresizingMaskIntoConstraints = NO;
            seg.frame = CGRectMake(20, 20, self.inputArea.frame.size.width - 40, 30);
        
            seg.tintColor = [[GlobalAsset sharedInstance] coreUIComponentColor];
        
            [self.inputArea addSubview:seg];
            
            self.inputArea.translatesAutoresizingMaskIntoConstraints = NO;
            
            [seg.leftAnchor constraintEqualToAnchor:self.inputArea.leftAnchor constant:10.0].active = YES;
            [seg.rightAnchor constraintEqualToAnchor:self.inputArea.rightAnchor constant:-10.0].active = YES;
            [seg.centerYAnchor constraintEqualToAnchor:self.inputArea.centerYAnchor].active = YES;
            [seg.heightAnchor constraintEqualToConstant:seg.frame.size.height];
            
            break;
        }
        case EntryTypeSlider: {
            float minValue = [[properties valueForKey:KEYS_ENTRYTYPE_SLIDER_MINVALUE] floatValue];
            float maxValue = [[properties valueForKey:KEYS_ENTRYTYPE_SLIDER_MAXVALUE] floatValue];
            
            SASlider *slider = [[SASlider alloc] initWithFrame:self.inputArea.frame minimumValue:minValue maximumValue:maxValue currentValue:minValue + (maxValue - minValue)/2];
            [slider setMinimumTrackTintColor:[[GlobalAsset sharedInstance] coreUIComponentColor]];
            [self.inputArea addSubview:slider];
            
            self.inputArea.translatesAutoresizingMaskIntoConstraints = NO;
            
            [slider.leftAnchor constraintEqualToAnchor:self.inputArea.leftAnchor].active = YES;
            [slider.rightAnchor constraintEqualToAnchor:self.inputArea.rightAnchor].active = YES;
            [slider.topAnchor constraintEqualToAnchor:self.inputArea.topAnchor].active = YES;
            [slider.bottomAnchor constraintEqualToAnchor:self.inputArea.bottomAnchor].active = YES;
            
            break;
        }
        case EntryTypeStepper: {
            float minValue = [[properties valueForKey:KEYS_ENTRYTYPE_STEPPER_MINVALUE] floatValue];
            float maxValue = [[properties valueForKey:KEYS_ENTRYTYPE_STEPPER_MAXVALUE] floatValue];
            float currentVal = minValue + (maxValue - maxValue)/2;
            
            SAStepper *stepper = [[SAStepper alloc] initWithFrame:self.inputArea.frame minimumValue:minValue maximumValue:maxValue currentValue:currentVal];
    
            [stepper setStepperTintColor:[[GlobalAsset sharedInstance] coreUIComponentColor]];
        
            
            [self.inputArea addSubview:stepper];
            
            self.inputArea.translatesAutoresizingMaskIntoConstraints = NO;
            
            [stepper.leftAnchor constraintEqualToAnchor:self.inputArea.leftAnchor].active = YES;
            [stepper.rightAnchor constraintEqualToAnchor:self.inputArea.rightAnchor].active = YES;
            [stepper.topAnchor constraintEqualToAnchor:self.inputArea.topAnchor].active = YES;
            [stepper.bottomAnchor constraintEqualToAnchor:self.inputArea.bottomAnchor].active = YES;
            break;
        }
        case EntryTypeTextField:{
            NSString *placeholder = [properties valueForKey:KEYS_ENTRYTYPE_TEXTFIELD_PLACEHOLDER];
            UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.inputArea.frame.size.width - 40, 30)];
            text.translatesAutoresizingMaskIntoConstraints = NO;
            text.textAlignment = NSTextAlignmentCenter;
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.placeholder = placeholder;
            [self.inputArea addSubview:text];
            
            self.inputArea.translatesAutoresizingMaskIntoConstraints = NO;
            
            [text.leftAnchor constraintEqualToAnchor:self.inputArea.leftAnchor constant:10.0].active = YES;
            [text.rightAnchor constraintEqualToAnchor:self.inputArea.rightAnchor constant:-10.0].active = YES;
            [text.centerYAnchor constraintEqualToAnchor:self.inputArea.centerYAnchor].active = YES;
            [text.heightAnchor constraintEqualToConstant:text.frame.size.height].active = YES;
            break;
        }
        case EntryTypeToggle:{
            UISwitch *toggle = [[UISwitch alloc] init];
            toggle.translatesAutoresizingMaskIntoConstraints = NO;
            toggle.onTintColor = [[GlobalAsset sharedInstance] coreUIComponentColor];
            toggle.tintColor = [[GlobalAsset sharedInstance] coreUIComponentColor];
            toggle.on = YES;
            [self.inputArea addSubview:toggle];
            
            self.inputArea.translatesAutoresizingMaskIntoConstraints = NO;
            
            [toggle.centerXAnchor constraintEqualToAnchor:self.inputArea.centerXAnchor].active = YES;
            [toggle.centerYAnchor constraintEqualToAnchor:self.inputArea.centerYAnchor].active = YES;
            [toggle.widthAnchor constraintEqualToConstant:toggle.frame.size.width].active = YES;
            [toggle.heightAnchor constraintEqualToConstant:toggle.frame.size.height].active = YES;
            
            break;
        }
        default:
            break;
    }
    self.inputArea.userInteractionEnabled = NO;
}

@end
