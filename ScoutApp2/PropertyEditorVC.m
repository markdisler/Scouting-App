//
//  PropertyEditor.m
//  ScoutApp2
//
//  Created by Mark on 7/3/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "PropertyEditorVC.h"

@interface PropertyEditorVC ()
@property (nonatomic, strong) NSArray *propertiesList;
@end

@implementation PropertyEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = VIEWCONTROLLER_TITLES_PROPERTYEDITOR;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    [self checkDictionary];
    self.propertiesList = [self generatePropertyFields];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *cells = [self.tableView visibleCells];
    NSMutableDictionary *mutableProps = [NSMutableDictionary dictionary];
    for (PropertyCell *cell in cells) {
        UITextField *textField = cell.textField;
        [mutableProps setObject:textField.text forKey:textField.placeholder];
    }
    [self.delegate usePropertyData:[mutableProps copy]];
}

#pragma mark - Main Generations

- (void)checkDictionary {
    if (!self.properties) {
        self.properties = [NSDictionary dictionary];
    }
}

- (NSArray *)generatePropertyFields {
    NSArray *properties;
    if (self.entryType == EntryTypeSlider) {
        properties = @[KEYS_ENTRYTYPE_SLIDER_MINVALUE, KEYS_ENTRYTYPE_SLIDER_MAXVALUE];
    } else if (self.entryType == EntryTypeStepper) {
        properties = @[KEYS_ENTRYTYPE_STEPPER_MINVALUE, KEYS_ENTRYTYPE_STEPPER_MAXVALUE];
    } else if (self.entryType == EntryTypeToggle) {
        properties = @[];
    } else if (self.entryType == EntryTypeTextField) {
        properties = @[KEYS_ENTRYTYPE_TEXTFIELD_PLACEHOLDER];
    } else if (self.entryType == EntryTypeSegmentedControl) {
        properties = @[KEYS_ENTRYTYPE_SEGMENT_FIRST, KEYS_ENTRYTYPE_SEGMENT_SECOND, KEYS_ENTRYTYPE_SEGMENT_THIRD, KEYS_ENTRYTYPE_SEGMENT_FOURTH];
    } else {
        properties = @[];
    }
    return properties;
}

#pragma mark - Table View Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Entity Properties";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.propertiesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"property" forIndexPath:indexPath];
    NSString *placeholderKey = [self.propertiesList objectAtIndex:indexPath.row];
    cell.textField.placeholder = placeholderKey;
    
    if([self.properties valueForKey:placeholderKey] != nil) {
        cell.textField.text = [self.properties valueForKey:placeholderKey];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
