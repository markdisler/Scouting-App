//
//  ParameterEditVC.m
//  ScoutApp2
//
//  Created by Matt Panzer on 1/27/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "ParameterEditVC.h"
#import "PropertyParser.h"
#import "SASlider.h"
#import "SAStepper.h"

@interface ParameterEditVC ()
@property (nonatomic, strong) NSArray *operatorSearchOptions;
@end

@implementation ParameterEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Edit Parameter";
    self.parameterToggle.tintColor = [[GlobalAsset sharedInstance] coreTheme];
    self.parameterToggle.onTintColor = [[GlobalAsset sharedInstance] coreTheme];
    
    EntryType entryType = (EntryType)self.sheetEntry.entryType.integerValue;
    if (entryType == EntryTypeTextField) {
         self.operatorSearchOptions = @[@"Starts With", @"Contains", @"Equals"];
    } else if ((entryType == EntryTypeStepper)||(entryType == EntryTypeSlider)) {
        self.operatorSearchOptions = @[@"≤", @"=", @"≥", @"≠"];
    }
    
    self.parameterInfo = [self.constraints objectForKey:self.sheetEntry.entryId];
}

- (void)viewWillDisappear:(BOOL)animated {
    //Package all of the data we'll need for Advanced Search
    //TODO: put in separate method
    NSMutableDictionary *dict = [self.constraints mutableCopy];
    NSMutableDictionary *subDict = [NSMutableDictionary dictionary];
    EntryType type = self.sheetEntry.entryType.integerValue;
    if (type == EntryTypeSegmentedControl) {
        UISegmentedControl *control = [self.entryTypeContainer.subviews objectAtIndex:0];
        [subDict setObject:[NSNumber numberWithInteger:control.selectedSegmentIndex] forKey:@"value"];
    }else if (type == EntryTypeSlider) {
        SASlider *control = [self.entryTypeContainer.subviews objectAtIndex:0];
        [subDict setObject:[NSNumber numberWithInteger:[control getSliderValue]] forKey:@"value"];
        [subDict setObject:[NSNumber numberWithInteger:self.operatorSegment.selectedSegmentIndex] forKey:@"operator"];
    }else if (type == EntryTypeStepper) {
        SAStepper *control = [self.entryTypeContainer.subviews objectAtIndex:0];
        [subDict setObject:[NSNumber numberWithInteger:[control getStepperValue]] forKey:@"value"];
        [subDict setObject:[NSNumber numberWithInteger:self.operatorSegment.selectedSegmentIndex] forKey:@"operator"];
    }else if (type == EntryTypeTextField) {
        UITextField *control = [self.entryTypeContainer.subviews objectAtIndex:0];
        [subDict setObject:control.text forKey:@"value"];
        [subDict setObject:[NSNumber numberWithInteger:self.operatorSegment.selectedSegmentIndex] forKey:@"operator"];
    }else if (type == EntryTypeToggle) {
        UISwitch *control = [self.entryTypeContainer.subviews objectAtIndex:0];
        [subDict setObject:[NSNumber numberWithBool:control.on] forKey:@"value"];
    }
    //Is this constraint active?
    [subDict setObject:[NSNumber numberWithBool:self.parameterToggle.on] forKey:@"active"];
    [dict setObject:subDict forKey:self.sheetEntry.entryId];
    [self.delegate useConstraintWithDictionary:[dict copy]];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            EntryType entryType = (EntryType)self.sheetEntry.entryType.integerValue;
            NSDictionary *propDict = [PropertyParser parseDictionaryForProperties:self.sheetEntry.entryProperties];
            NSString *value;
            id val = [self.parameterInfo objectForKey:@"value"];
            if (val != nil) value = [NSString stringWithFormat:@"%@", val];
            [self setInputElement:entryType properties:propDict value:value];
        } else if (indexPath.row == 1) {
            self.operatorSegment.tintColor = [[GlobalAsset sharedInstance] coreTheme];
            for (NSInteger i = 0; i < self.operatorSearchOptions.count; i++) {
                [self.operatorSegment insertSegmentWithTitle:[self.operatorSearchOptions objectAtIndex:i] atIndex:i animated:YES];
            }
            [self.operatorSegment removeSegmentAtIndex:self.operatorSearchOptions.count+1 animated:NO];
            [self.operatorSegment removeSegmentAtIndex:self.operatorSearchOptions.count animated:NO];
            NSNumber *index = (NSNumber*)[self.parameterInfo objectForKey:@"operator"];
            [self.operatorSegment setSelectedSegmentIndex: index.integerValue];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        EntryType entryType = (EntryType)self.sheetEntry.entryType.integerValue;
        if (entryType == EntryTypeSegmentedControl) return 1;
        if (entryType == EntryTypeToggle) return 1;
        if (entryType == EntryTypeSlider) return 2;
        if (entryType == EntryTypeStepper) return 2;
        if (entryType == EntryTypeTextField) return 2;
        else return 1;
    }else{
        return 0;
    }
}

- (void)setInputElement:(EntryType)type properties:(NSDictionary *)properties value:(NSString *)val {
    
    for (UIView *sv in self.entryTypeContainer.subviews) {
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
            seg.frame = CGRectMake(20, 20, self.entryTypeContainer.frame.size.width - 40, 30);
            seg.tintColor = [[GlobalAsset sharedInstance] coreTheme];
            [self.entryTypeContainer addSubview:seg];
            
            self.entryTypeContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            [seg.leftAnchor constraintEqualToAnchor:self.entryTypeContainer.leftAnchor constant:10.0].active = YES;
            [seg.rightAnchor constraintEqualToAnchor:self.entryTypeContainer.rightAnchor constant:-10.0].active = YES;
            [seg.centerYAnchor constraintEqualToAnchor:self.entryTypeContainer.centerYAnchor].active = YES;
            [seg.heightAnchor constraintEqualToConstant:seg.frame.size.height];
            
            if (![val isEqualToString:@""]) seg.selectedSegmentIndex = val.integerValue;
            break;
        }
        case EntryTypeSlider: {
            float minValue = [[properties valueForKey:KEYS_ENTRYTYPE_SLIDER_MINVALUE] floatValue];
            float maxValue = [[properties valueForKey:KEYS_ENTRYTYPE_SLIDER_MAXVALUE] floatValue];
            
            SASlider *slider = [[SASlider alloc] initWithFrame:self.entryTypeContainer.frame minimumValue:minValue maximumValue:maxValue currentValue:minValue + (maxValue - minValue)/2];
            [slider setMinimumTrackTintColor:[[GlobalAsset sharedInstance] coreTheme]];
            [self.entryTypeContainer addSubview:slider];
            
            self.entryTypeContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            [slider.leftAnchor constraintEqualToAnchor:self.entryTypeContainer.leftAnchor].active = YES;
            [slider.rightAnchor constraintEqualToAnchor:self.entryTypeContainer.rightAnchor].active = YES;
            [slider.topAnchor constraintEqualToAnchor:self.entryTypeContainer.topAnchor].active = YES;
            [slider.bottomAnchor constraintEqualToAnchor:self.entryTypeContainer.bottomAnchor].active = YES;
            
            if (![val isEqualToString:@""])
                [slider setCurrentValue:val.floatValue];
            break;
        }
        case EntryTypeStepper: {
            float minValue = [[properties valueForKey:KEYS_ENTRYTYPE_STEPPER_MINVALUE] floatValue];
            float maxValue = [[properties valueForKey:KEYS_ENTRYTYPE_STEPPER_MAXVALUE] floatValue];
            
            SAStepper *stepper = [[SAStepper alloc] initWithFrame:self.entryTypeContainer.frame minimumValue:minValue maximumValue:maxValue currentValue:0];
            [stepper setStepperTintColor:[[GlobalAsset sharedInstance] coreTheme]];
            [self.entryTypeContainer addSubview:stepper];
            
            self.entryTypeContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            [stepper.leftAnchor constraintEqualToAnchor:self.entryTypeContainer.leftAnchor].active = YES;
            [stepper.rightAnchor constraintEqualToAnchor:self.entryTypeContainer.rightAnchor].active = YES;
            [stepper.topAnchor constraintEqualToAnchor:self.entryTypeContainer.topAnchor].active = YES;
            [stepper.bottomAnchor constraintEqualToAnchor:self.entryTypeContainer.bottomAnchor].active = YES;
            if (![val isEqualToString:@""])
                [stepper setCurrentValue:val.floatValue];
            break;
        }
        case EntryTypeTextField:{
            NSString *placeholder = [properties valueForKey:KEYS_ENTRYTYPE_TEXTFIELD_PLACEHOLDER];
            UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.entryTypeContainer.frame.size.width - 40, 30)];
            text.translatesAutoresizingMaskIntoConstraints = NO;
            text.textAlignment = NSTextAlignmentCenter;
            text.borderStyle = UITextBorderStyleRoundedRect;
            text.placeholder = placeholder;
            [self.entryTypeContainer addSubview:text];
            
            self.entryTypeContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            [text.leftAnchor constraintEqualToAnchor:self.entryTypeContainer.leftAnchor constant:10.0].active = YES;
            [text.rightAnchor constraintEqualToAnchor:self.entryTypeContainer.rightAnchor constant:-10.0].active = YES;
            [text.centerYAnchor constraintEqualToAnchor:self.entryTypeContainer.centerYAnchor].active = YES;
            [text.heightAnchor constraintEqualToConstant:text.frame.size.height].active = YES;
            
            if (![val isEqualToString:@""])
                text.text = val;
            break;
        }
        case EntryTypeToggle:{
            UISwitch *toggle = [[UISwitch alloc] init];
            toggle.translatesAutoresizingMaskIntoConstraints = NO;
            toggle.tintColor = [[GlobalAsset sharedInstance] coreTheme];
            toggle.onTintColor = [[GlobalAsset sharedInstance] coreTheme];
            [self.entryTypeContainer addSubview:toggle];
            
            self.entryTypeContainer.translatesAutoresizingMaskIntoConstraints = NO;
            
            [toggle.centerXAnchor constraintEqualToAnchor:self.entryTypeContainer.centerXAnchor].active = YES;
            [toggle.centerYAnchor constraintEqualToAnchor:self.entryTypeContainer.centerYAnchor].active = YES;
            [toggle.widthAnchor constraintEqualToConstant:toggle.frame.size.width].active = YES;
            [toggle.heightAnchor constraintEqualToConstant:toggle.frame.size.height].active = YES;
            
            if (![val isEqualToString:@""])
                toggle.on = val.boolValue;
            break;
        }
        default:
            break;
    }
    NSNumber *active = [self.parameterInfo objectForKey:@"active"];
    [self.parameterToggle setOn:active.boolValue];
    [self activeToggle:self.parameterToggle];
}

- (IBAction)activeToggle:(id)sender {
    BOOL state = [self.parameterToggle isOn];
    self.valueLabel.enabled = state;
    UIControl *view  = [self.entryTypeContainer.subviews objectAtIndex:0];
    view.enabled = state;
    self.operatorLabel.enabled = state;
    self.operatorSegment.enabled = state;
    self.parameterToggle.tintColor = [[GlobalAsset sharedInstance] coreTheme];
}

@end
