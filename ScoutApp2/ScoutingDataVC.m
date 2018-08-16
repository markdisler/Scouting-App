//
//  ScoutingDataVC.m
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "ScoutingDataVC.h"
#import "ScoutingDataCell.h"
#import "PropertyParser.h"
#import "UISplitViewController+StatusBarImprovement.h"

@interface ScoutingDataVC ()
@property (nonatomic, strong) NSArray *sheetFields;
@property (nonatomic, strong) NSArray *scoutingDataForTeam;
@property (nonatomic, assign) BOOL isFavorited;
@property (nonatomic, assign) BOOL hasLoadedASheet;
@end

@implementation ScoutingDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [[GlobalAsset sharedInstance] coreTheme];
    self.navigationController.navigationBar.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:20.0f],
        NSForegroundColorAttributeName: [[GlobalAsset sharedInstance] coreFontColor]
    };

    self.tableView.allowsSelection = NO;
    self.hasLoadedASheet = NO;
    
    self.isFavorited = [self.team.isFavorited boolValue];
    if (self.isFavorited) {
        [self showFavoritedButton];
    } else {
        [self showUnfavoritedButton];
    }

    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [tapToDismiss setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapToDismiss];    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.sheet) {
        self.title = self.team.teamName;
        self.sheetFields = [[CDDataManager sharedInstance] getEntryListForSheet:self.sheet];
        self.scoutingDataForTeam = [[CDDataManager sharedInstance] getAttributesForTeam:self.team.teamIdentifier sheet:self.sheet];
    } else {
        self.title = @"";
        self.sheetFields = @[];
        self.scoutingDataForTeam = @[];
    }
    [self.tableView reloadData];
}

- (void)reloadData {
    if (self.hasLoadedASheet) {
         [self updateStoredData];
    }
    
    if (self.sheet) {
        self.hasLoadedASheet = YES;
        self.title = self.team.teamName;
        self.sheetFields = [[CDDataManager sharedInstance] getEntryListForSheet:self.sheet];
        self.scoutingDataForTeam = [[CDDataManager sharedInstance] getAttributesForTeam:self.team.teamIdentifier sheet:self.sheet];
    } else {
        self.title = @"";
        self.sheetFields = @[];
        self.scoutingDataForTeam = @[];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.sheet) {
        [self updateStoredData];
    }
}

- (void)showFavoritedButton {
    UIBarButtonItem *favoritedBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Unfavorite"] style:UIBarButtonItemStylePlain target:self action:@selector(unmarkTeamAsFavorite)];
    favoritedBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationItem.rightBarButtonItem = favoritedBtn;
}

- (void)showUnfavoritedButton {
    UIBarButtonItem *unfavoritedBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Favorite"] style:UIBarButtonItemStylePlain target:self action:@selector(markTeamAsFavorite)];
    unfavoritedBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationItem.rightBarButtonItem = unfavoritedBtn;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.sheetFields count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoutingDataCell *cell = [tableView dequeueReusableCellWithIdentifier:@"infoCell" forIndexPath:indexPath];
    CDSheetEntry *entry = [self.sheetFields objectAtIndex:indexPath.row];
    CDTeamAttribute *correspondingAttribute = [[CDDataManager sharedInstance] getAttributeWithIdentifier:entry.entryId forTeam:self.team.teamIdentifier sheet:self.sheet];
    
    EntryType entryType = (EntryType)entry.entryType.integerValue;
    NSDictionary *propDict = [PropertyParser parseDictionaryForProperties:entry.entryProperties];
    [cell.title setText:entry.title];
    
    NSString *attribValueStr = @"";
    if (correspondingAttribute) attribValueStr = correspondingAttribute.value;
    [cell setInputElement:entryType properties:propDict value:attribValueStr];
    return cell;
}

- (void)dismiss:(UITapGestureRecognizer *)gesture  {
    [self.view endEditing:YES];
}

#pragma mark - Updating

- (void)updateStoredData {
    for (NSInteger i = 0; i < self.sheetFields.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ScoutingDataCell *cell = (ScoutingDataCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        CDSheetEntry *entry = [self.sheetFields objectAtIndex:indexPath.row];
        EntryType entryType = (EntryType)entry.entryType.integerValue;
        
        UIView *inputView = [cell.inputArea.subviews objectAtIndex:0];
        
        NSString *value = [EntryTypeAssistant getValueFromView:inputView ofEntryType:entryType];
        [[CDDataManager sharedInstance] updateAttribute:entry.entryId withValue:value forTeam:self.team.teamIdentifier sheet:self.sheet];
    }
    
    [[CDDataManager sharedInstance] setFavoritedTeam:self.team.teamIdentifier favorited:self.isFavorited];
}

#pragma mark - Team Favoriting

- (void)markTeamAsFavorite {
    self.isFavorited = YES;
    [self showFavoritedButton];
}

- (void)unmarkTeamAsFavorite {
    self.isFavorited = NO;
    [self showUnfavoritedButton];
}

@end
