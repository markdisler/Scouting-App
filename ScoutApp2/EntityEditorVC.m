//
//  PropertyEditorVC.m
//  ScoutApp2
//
//  Created by Mark on 6/26/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "EntityEditorVC.h"
#import "PropertyParser.h"
#import "PropertyCell.h"
#import "UIColor+CCColors.h"

@interface EntityEditorVC ()
@property (nonatomic, strong) UIBarButtonItem *saveBtn;
@property (nonatomic, assign) BOOL shouldShowProperties;
@property (nonatomic, assign) BOOL propertiesAreFilledOut;
@property (nonatomic, strong) NSString *entryTitle;
@property (nonatomic, assign) EntryType entryType;
@property (nonatomic, strong) NSArray *entryProperties;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, strong) NSArray *viewsToPick;
@property (nonatomic, strong) NSArray *enumParallelArray;
@property (nonatomic, strong) NSArray *sectionTitles;
@property (nonatomic, assign) NSInteger numberOfFilledOutProperties;
@property (nonatomic, assign) BOOL entryTypeWasChangedDuringEdit;
@end

@implementation EntityEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set appearance for nav bar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [[GlobalAsset sharedInstance] coreTheme];
    self.navigationController.navigationBar.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:20.0f],
                                                                    NSForegroundColorAttributeName: [[GlobalAsset sharedInstance] coreFontColor]
                                                                    };
    if ([[[GlobalAsset sharedInstance] coreFontColor] isEqual:[UIColor blackColor]]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
    //Create the Bar Buttons
    self.saveBtn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)]; //save
    self.saveBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    [self.saveBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:DESIGN_FONTS_MAINFONT size:18.0],  NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = self.saveBtn;
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close)];
    close.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    [close setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:DESIGN_FONTS_MAINFONT size:18.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = close;
    
    self.saveBtn.enabled = NO;
    self.entryTypeWasChangedDuringEdit = NO;
    
    //Set up view controller
    self.title = VIEWCONTROLLER_TITLES_ENTITYEDITOR;
    self.entryType = EntryTypeNone;
    self.selectedIndex = -1;
    self.shouldShowProperties = NO;
    
    if (self.sheetEntry) {
        self.sectionTitles = @[@"Title", @"Input Type", @"", @""];
    } else {
        self.sectionTitles = @[@"Title", @"Input Type", @""];
    }
    
    [self.txtTitle addTarget:self action:@selector(textFieldUpdated:) forControlEvents:UIControlEventEditingChanged];
    
    //Create the elements that the user can chose from
    UIStepper *stepper = [[UIStepper alloc] init];
    UISwitch *toggle = [[UISwitch alloc] init];
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"1", @"2", @"3"]];
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    UITextField *text = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    
    //Set any properties that the user should see when picking
    slider.value = 0.5;
    text.borderStyle = UITextBorderStyleRoundedRect;
    text.placeholder = @"Text";
    text.textAlignment = NSTextAlignmentCenter;
    toggle.on = YES;
    stepper.tintColor = [[GlobalAsset sharedInstance] coreTheme];
    toggle.onTintColor = [[GlobalAsset sharedInstance] coreTheme];
    toggle.tintColor = [[GlobalAsset sharedInstance] coreTheme];
    seg.tintColor = [[GlobalAsset sharedInstance] coreTheme];
    slider.tintColor = [[GlobalAsset sharedInstance] coreTheme];
    
   // [stepper.layer setTransform:CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(0.8, 0.8))];
    
    //Create an array of these views so they can be loaded for the user
    self.viewsToPick = @[slider, stepper, toggle, text, seg];
    self.enumParallelArray = @[@0, @1, @2, @3, @4];
    
    //Make the collection view
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    //Create gesture recognizer to dismiss keyboard
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [tapToDismiss setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapToDismiss];
    
    //Try to fill out the sheet entry editor if one exists already
    [self fillOutSheetIfEditing];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)fillOutSheetIfEditing {
    if (self.sheetEntry) {
        [self.txtTitle setText:self.sheetEntry.title];
        self.selectedIndex = self.sheetEntry.entryType.integerValue;
        [self setEntryTypeBasedOnSelectionIndex:self.selectedIndex];
        self.properties = [PropertyParser parseDictionaryForProperties:self.sheetEntry.entryProperties];
        self.propertiesAreFilledOut = YES;
        [self checkForSaveRequirements];
        [self.collectionView reloadData];
    }
}

- (void)textFieldUpdated:(id)sender {
    [self checkForSaveRequirements];
}

- (void)propertyTextFieldUpdated:(UITextField *)sender {
    if ([self checkIfPropertiesAreFillOut]) {
        self.propertiesAreFilledOut = YES;
    } else {
        self.propertiesAreFilledOut = NO;
    }
    [self checkForSaveRequirements];
}

- (BOOL)checkIfPropertiesAreFillOut {
    BOOL isFilledOutCompletely = YES;
    NSArray *cells = [self.tableView visibleCells];
    for (PropertyCell *cell in cells) {
        if ([cell isKindOfClass:[PropertyCell class]]) {
            UITextField *textField = cell.textField;
            if (textField.text.length == 0) {
                isFilledOutCompletely = NO;
            }
        }
    }
    return isFilledOutCompletely;
}

- (void)checkForSaveRequirements {
    BOOL meetsPropertyRequirement = NO;
    if (self.selectedIndex != -1) {
        if (self.shouldShowProperties && self.propertiesAreFilledOut) {
            meetsPropertyRequirement = YES;
        } else if (!self.shouldShowProperties) {
            meetsPropertyRequirement = YES;
        }
    }
    
    //was working here 02/15/16
    if (self.txtTitle.text.length > 0 && meetsPropertyRequirement) {
        self.saveBtn.enabled = YES;
    } else {
        self.saveBtn.enabled = NO;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.tableView.scrollEnabled = NO;
    float shift = (textField.tag+1) * (textField.frame.size.height);
    [self.tableView setContentOffset:CGPointMake(0,shift) animated:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.tableView.scrollEnabled = YES;
    [self.tableView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - UITableView Delegate Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        PropertyCell *cell = [[PropertyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"propertyCell"];
        cell.textField = [[UITextField alloc] initWithFrame:CGRectZero];
        cell.textField.font = [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:14.0];
        cell.textField.translatesAutoresizingMaskIntoConstraints = NO;
        cell.textField.tag = indexPath.row;
        cell.textField.delegate = self;
        [cell.contentView addSubview:cell.textField];
        
        [cell.textField.leftAnchor constraintEqualToAnchor:cell.contentView.leftAnchor constant:15].active = YES;
        [cell.textField.rightAnchor constraintEqualToAnchor:cell.contentView.rightAnchor constant:10].active = YES;
        [cell.textField.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:10].active = YES;
        [cell.textField.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:-10].active = YES;
        
        [cell.textField addTarget:self action:@selector(propertyTextFieldUpdated:) forControlEvents:UIControlEventEditingChanged];
        
        NSString *placeholderKey = [[self generatePropertyFields] objectAtIndex:indexPath.row];
        cell.textField.placeholder = placeholderKey;
        
        if ([self.properties valueForKey:placeholderKey] != nil) {
            cell.textField.text = [self.properties valueForKey:placeholderKey];
        }
        
        return cell;
    } else {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0) {
        [self askToDeleteEntry];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 45;
    }
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitles count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return [[self generatePropertyFields] count];
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    } else {
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

#pragma mark - Handling the Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.viewsToPick count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.borderWidth = 1.0f;
    
    for (UIView *sv in cell.subviews) {
        [sv removeFromSuperview];
    }
    
    UIView *viewToPlace = [self.viewsToPick objectAtIndex:indexPath.row];
    viewToPlace.frame = CGRectMake(0, 0, cell.frame.size.width - 20, 30);
    viewToPlace.userInteractionEnabled = NO;
    viewToPlace.center = CGPointMake(cell.frame.size.width/2, cell.frame.size.height/2);
    [cell addSubview:viewToPlace];
    
    if (indexPath.row == self.selectedIndex) {
        cell.layer.borderColor = [[GlobalAsset sharedInstance] coreTheme].CGColor;
        cell.layer.borderWidth = 2.0f;
    } else {
        cell.layer.borderColor = [UIColor blackColor].CGColor;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(100, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.sheetEntry) {  //Existing entry to save
        [self warnUserOfPotentialDataLoss:indexPath];
        self.entryTypeWasChangedDuringEdit = YES;
    } else {    //New, unsaved entry
        [self selectEntryTypeAtIndexPath:indexPath];
        [self.tableView reloadData];
        [collectionView reloadData];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

#pragma mark - Property Editor

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

#pragma mark - Manage Selection

- (void)selectEntryTypeAtIndexPath:(NSIndexPath *)indexPath {
    self.properties = nil;
    self.propertiesAreFilledOut = NO;
    self.numberOfFilledOutProperties = 0;
    self.selectedIndex = indexPath.row;
    [self setEntryTypeBasedOnSelectionIndex:self.selectedIndex];
    [self checkForSaveRequirements];
}

- (void)setEntryTypeBasedOnSelectionIndex:(NSInteger)selected {
    UIView *selectedView = [self.viewsToPick objectAtIndex:selected];
    self.shouldShowProperties = NO;
    if ([selectedView isKindOfClass:UISlider.class]) {
        self.entryType = EntryTypeSlider;
        self.shouldShowProperties = YES;
    } else if ([selectedView isKindOfClass:UIStepper.class]) {
        self.entryType = EntryTypeStepper;
        self.shouldShowProperties = YES;
    } else if ([selectedView isKindOfClass:UISwitch.class]) {
        self.entryType = EntryTypeToggle;
    } else if ([selectedView isKindOfClass:UITextField.class]) {
        self.entryType = EntryTypeTextField;
        self.shouldShowProperties = YES;
    } else if ([selectedView isKindOfClass:UISegmentedControl.class]) {
        self.entryType = EntryTypeSegmentedControl;
        self.shouldShowProperties = YES;
    } else {
        self.entryType = EntryTypeNone;
    }
}

#pragma mark - Keyboard dismiss

- (void)dismiss:(UITapGestureRecognizer *)gesture  {
    [self.view endEditing:YES];
}

#pragma mark - Warnings

- (void)askToDeleteEntry {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Sheet Entry"
                                                                   message:@"Deleting this entry WILL result in data loss if you've already collected team data for this topic."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [[CDDataManager sharedInstance] removeEntryFromSheet:self.sheet entry:self.sheetEntry.entryId];
        [self close];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    [alert addAction:resetAction];
    [alert addAction:cancelAction]; //provide the action to cancel this action
    [self presentViewController:alert animated:YES completion:nil]; //show alert to user
}

- (void)warnUserOfPotentialDataLoss:(NSIndexPath *)potentialNewEntryIndex {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Potential Data Loss"
                                                                   message:@"Changing the input type WILL result in data loss if you've already collected team data."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *changeAction = [UIAlertAction actionWithTitle:@"Change"  style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [self selectEntryTypeAtIndexPath:potentialNewEntryIndex];
        [self.tableView reloadData];
        [self.collectionView reloadData];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    
    [alert addAction:changeAction]; //provide the action to continue
    [alert addAction:cancelAction]; //provide the action to cancel this action
    [self presentViewController:alert animated:YES completion:nil]; //show alert to user
}

#pragma mark - Main Generations

- (NSDictionary *)constructDictionaryOfProperties {
    NSArray *cells = [self.tableView visibleCells];
    NSMutableDictionary *mutableProps = [NSMutableDictionary dictionary];
    for (PropertyCell *cell in cells) {
        if ([cell isKindOfClass:[PropertyCell class]]) {
            UITextField *textField = cell.textField;
            [mutableProps setObject:textField.text forKey:textField.placeholder];
        }
    }
    return [mutableProps copy];
}

#pragma mark - Bar Button Selectors

- (void)save {
    self.entryTitle = self.txtTitle.text; //title
    self.properties = [self constructDictionaryOfProperties];
    NSString *propertyString = [PropertyParser createStringForProperties:self.properties];
    
    if (self.sheetEntry) {
        //Exists, so just update the one passed in
        [[CDDataManager sharedInstance] changeTitleOfEntry:self.sheetEntry.entryId onSheet:self.sheet newTitle:self.entryTitle];
        [[CDDataManager sharedInstance] changeTypeOfEntry:self.sheetEntry.entryId onSheet:self.sheet newType:self.entryType];
        [[CDDataManager sharedInstance] setPropertiesOfEntry:self.sheetEntry.entryId onSheet:self.sheet properties:propertyString];
    } else {
        //Doesn't exist, so create a new one
        NSString *entryID = [[CDDataManager sharedInstance] addSheetEntryToSheet:self.sheet title:self.entryTitle entryType:self.entryType];
        [[CDDataManager sharedInstance] setPropertiesOfEntry:entryID onSheet:self.sheet properties:propertyString];
    }
    [self close];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
