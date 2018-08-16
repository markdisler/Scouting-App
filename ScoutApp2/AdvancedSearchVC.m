//
//  AdvancedSearchVC.m
//  ScoutApp2
//
//  Created by Matt Panzer on 1/26/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "AdvancedSearchVC.h"
#import "ScoutingDataVC.h"
#import "SearchParameterCell.h"
#import "ParameterEditVC.h"
#import "TeamCell.h"
#import "PropertyParser.h"

@interface AdvancedSearchVC ()
@property (nonatomic, strong) NSArray *parameters;
@end

@implementation AdvancedSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Advanced Search";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [[GlobalAsset sharedInstance] coreTheme];
    self.navigationController.navigationBar.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:20.0f],
        NSForegroundColorAttributeName: [[GlobalAsset sharedInstance] coreFontColor]
    };
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.parameters = [[CDDataManager sharedInstance] getEntryListForSheet:self.sheet];
    self.teamListForSheet = [[CDDataManager sharedInstance] getTeamListForSheet:self.sheet].mutableCopy;
    [self updateSearchRefinedList];
    self.sortByNumber = [[NSUserDefaults standardUserDefaults] boolForKey:@"sortByNumber"];
    if (!self.constraints) self.constraints = [NSMutableDictionary dictionary];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateSearchRefinedList];
    [self.tableView reloadData];
}

- (void)backToSearch {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sorting
- (void)sortTeams {
    NSSortDescriptor *sortDesc;
    if (self.sortByNumber) {
        self.teamListForSheet = [self.teamListForSheet sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            int first = (int)[[(CDTeam*)a teamNumber] integerValue];
            int second = (int)[[(CDTeam*)b teamNumber] integerValue];
            return (first > second);
        }];
        self.searchRefinedList = [self.searchRefinedList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            int first = (int)[[(CDTeam*)a teamNumber] integerValue];
            int second = (int)[[(CDTeam*)b teamNumber] integerValue];
            return (first > second);
        }].mutableCopy;
    } else {
        sortDesc = [[NSSortDescriptor alloc] initWithKey:@"teamName" ascending:YES];
        self.teamListForSheet = [self.teamListForSheet sortedArrayUsingDescriptors:@[sortDesc]];
        self.searchRefinedList = [self.searchRefinedList sortedArrayUsingDescriptors:@[sortDesc]].mutableCopy;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Parameters";
            break;
        case 1:
            if ([self.searchRefinedList count] > 0) {
                return @"Search Results";
            }else{
                return @"No Results";
            }
            break;
        default:
            return @"";
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    switch (section) {
        case 0:
            rows = [self.parameters count];
            break;
        case 1:
            rows = [self.searchRefinedList count];
        default:
            break;
    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return 44;
            break;
        case 1:
            return 70;
            break;
        default:
            return 44;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SearchParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"parameterCell" forIndexPath:indexPath];
        CDSheetEntry *entry = [self.parameters objectAtIndex:indexPath.row];
        [cell.parameterName setText: entry.title];
        NSString *pred = [self humanConstraintsStringForEntry:entry];
        if ([pred isEqualToString:@"Inactive"]) { [cell.constraints setTextColor:[UIColor grayColor]]; }
        else { [cell.constraints setTextColor:[UIColor blackColor]]; }
        [cell.constraints setText:pred];
        return cell;
    }else if (indexPath.section == 1){
        TeamCell *cell = [[TeamCell alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 52)];
        CDTeam *team = [self.searchRefinedList objectAtIndex:indexPath.row];
        [cell setUpFrames];
        if (self.sortByNumber) {
            [cell.primaryLabel setText:team.teamNumber];
            [cell.secondaryLabel setText:team.teamName];
        } else {
            [cell.primaryLabel setText:team.teamName];
            [cell.secondaryLabel setText:team.teamNumber];
        }
        return cell;
    }else{
        UITableViewCell *cell;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ParameterEditVC *parameterEdit = [self.storyboard instantiateViewControllerWithIdentifier:@"parameterEdit"];
        parameterEdit.sheetEntry = [self.parameters objectAtIndex:indexPath.row];
        parameterEdit.constraints = self.constraints;
        parameterEdit.delegate = self;
        [self.navigationController pushViewController:parameterEdit animated:YES];
    }else if (indexPath.section == 1) {
        ScoutingDataVC *scoutingData = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingData"];
        scoutingData.sheet = self.sheet;
        scoutingData.team = [self.searchRefinedList objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:scoutingData animated:YES];
    }
}

#pragma mark - Constraints

- (void)useConstraintWithDictionary:(NSMutableDictionary *)dictonary {
    self.constraints = dictonary;
}

- (NSString*)generatePredicateForEntry:(CDSheetEntry*)entry {
    //If there are constraints defined for this entry, generate a predicate expression
    // Ex: (value.integerValue >= 4)
    //If no constraints, we'll let any value past this check so the predicate is TRUEPREDICATE
    
    NSMutableDictionary *dict = [self.constraints objectForKey:entry.entryId];
    if (dict == nil)return @"TRUEPREDICATE";
    NSMutableString *desc = [NSMutableString stringWithString:@"(value"];
    NSNumber *operatorIndex = [dict objectForKey:@"operator"];
    EntryType type = entry.entryType.integerValue;
    NSString *valueString;
    if ((type == EntryTypeSlider) || (type == EntryTypeStepper) || (type == EntryTypeSegmentedControl) || (type == EntryTypeToggle)) {
        //If the EntryType takes numerical input, we treat it thusly
        if (operatorIndex == nil) {
            [desc appendString:@".integerValue = %@"];
        }else{
            switch (operatorIndex.integerValue) {
                case 0:
                    [desc appendString:@".integerValue <= %@"];
                    break;
                case 1:
                    [desc appendString:@".integerValue = %@"];
                    break;
                case 2:
                    [desc appendString:@".integerValue >= %@"];
                    break;
                case 3:
                    [desc appendString:@".integerValue != %@"];
                    break;
                default:
                    break;
            }
        }
        NSNumber *val = [dict objectForKey:@"value"];
        valueString = [NSString stringWithFormat:@"%ld",(long)[val integerValue]];
    }else if (type == EntryTypeTextField) {
        //For string based comparisons, do this
        switch (operatorIndex.integerValue) {
            case 0:
                [desc appendString:@" BEGINSWITH[cd] '%@'"];
                break;
            case 1:
                [desc appendString:@" CONTAINS[cd] '%@'"];
                break;
            case 2:
                [desc appendString:@" MATCHES[cd] '%@'"];
                break;
            default:
                break;
        }
        valueString = [dict objectForKey:@"value"];
    }
    desc = [NSMutableString stringWithFormat:desc,valueString];
    [desc appendString:@")"];
    NSNumber *active = [dict objectForKey:@"active"];
    if (active.boolValue) return desc;
    else return @"TRUEPREDICATE";
}

- (NSString*)humanConstraintsStringForEntry:(CDSheetEntry*)entry {
    NSMutableDictionary *dict = [self.constraints objectForKey:entry.entryId];
    if (dict == nil)return @"Inactive";
    NSMutableString *desc = [NSMutableString stringWithString:@""];
    NSNumber *val = [dict objectForKey:@"value"];
    NSNumber *operatorIndex = [dict objectForKey:@"operator"];
    EntryType type = entry.entryType.integerValue;
    NSString *valueString;
    if ((type == EntryTypeSlider) || (type == EntryTypeStepper)) {
        if (operatorIndex != nil) {
            switch (operatorIndex.integerValue) {
                case 0:
                    [desc appendString:@"Less than or equal to %@"];
                    break;
                case 1:
                    [desc appendString:@"Equal to %@"];
                    break;
                case 2:
                    [desc appendString:@"Greater than or equal to %@"];
                    break;
                case 3:
                    [desc appendString:@"Not equal to %@"];
                    break;
                default:
                    break;
            }
        }
        valueString = val.stringValue;
    }else if (type == EntryTypeSegmentedControl) {
        [desc appendString:@"%@"];
        NSDictionary *propDict = [PropertyParser parseDictionaryForProperties:entry.entryProperties];
        switch (val.integerValue) {
            case 0:
                valueString = [propDict objectForKey:KEYS_ENTRYTYPE_SEGMENT_FIRST];
                break;
            case 1:
                valueString = [propDict objectForKey:KEYS_ENTRYTYPE_SEGMENT_SECOND];
                break;
            case 2:
                valueString = [propDict objectForKey:KEYS_ENTRYTYPE_SEGMENT_THIRD];
                break;
            case 3:
                valueString = [propDict objectForKey:KEYS_ENTRYTYPE_SEGMENT_FOURTH];
                break;
            default:
                break;
        }
    }else if (type == EntryTypeToggle) {
        [desc appendString:@"%@"];
        switch (val.integerValue) {
            case 0:
                valueString = @"False";
                break;
            case 1:
                valueString = @"True";
                break;
            default:
                break;
        }
    }else if (type == EntryTypeTextField) {
        switch (operatorIndex.integerValue) {
            case 0:
                [desc appendString:@"Starts With '%@'"];
                break;
            case 1:
                [desc appendString:@"Contains '%@'"];
                break;
            case 2:
                [desc appendString:@"Equals '%@'"];
                break;
            default:
                break;
        }
        valueString = (NSString*)val;
    }
    desc = [NSMutableString stringWithFormat:desc,valueString];
    NSNumber *active = [dict objectForKey:@"active"];
    if (active.boolValue) return desc;
    else return @"Inactive";
}

- (void)updateSearchRefinedList {
    //Huge complicated scary-looking method
    //Set up array for all attributes, and an array of all attributes separated by team
    // (The second will come in handy later)
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    NSMutableArray *separatedTeamAttributes = [[NSMutableArray alloc] init];
    //For every team in the sheet, get all of its attributes. Put those into the two arrays.
    for (CDTeam *team in self.teamListForSheet) {
        NSArray *teamAttributes = [[CDDataManager sharedInstance] getAttributesForTeam:team.teamIdentifier sheet:self.sheet];
        [attributes addObjectsFromArray:teamAttributes];
        [separatedTeamAttributes addObject:teamAttributes];
    }
    //For every entry generate a predicate string.
    NSMutableArray *passingTeamAttributes = [[NSMutableArray alloc] init];
    for (CDSheetEntry *entry in self.parameters) {
        NSString *predForEntry = [self generatePredicateForEntry:entry];
        //Then generate compound predicate checking that
        // 1. the Team Attribute entryID matches
        // 2. the constraint is met (aka, check value)
        //This process generates an array of passing team attributes
        NSPredicate *idCheck = [NSPredicate predicateWithFormat:@"(entryId MATCHES %@)",entry.entryId];
        NSString *valueCheckString = [NSString stringWithFormat:@"%@", predForEntry];
        NSPredicate *valueCheck = [NSPredicate predicateWithFormat: valueCheckString];
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[idCheck, valueCheck]];
        [passingTeamAttributes addObjectsFromArray:[attributes filteredArrayUsingPredicate:predicate]];
    }
    
    //Now we're going to use the separatedTeamAttributes array that we made a while ago.
    //This checks that all of the team's attributes passed our inspection
    //Put these into a disposable array
    NSMutableArray *tempResults = [[NSMutableArray alloc] init];
    for (NSArray *teamAttributes in separatedTeamAttributes) {
        BOOL isSubset = [[NSSet setWithArray: teamAttributes] isSubsetOfSet: [NSSet setWithArray: passingTeamAttributes]];
        if (isSubset) {
            if (teamAttributes.count > 0) {
                CDTeam *passingTeam = ((CDTeamAttribute*)[teamAttributes objectAtIndex:0]).parentTeam;
                [tempResults addObject:passingTeam];
            }
        }
    }
    self.searchRefinedList = tempResults.copy;
}



@end
