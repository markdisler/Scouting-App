//
//  TeamListVC.m
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "TeamListVC.h"
#import "TeamCell.h"
#import "ScoutingDataVC.h"
#import "NewTeamVC.h"
#import "AdvancedSearchVC.h"
#import "UISplitViewController+StatusBarImprovement.h"

@interface TeamListVC ()
@property (nonatomic, strong) NSArray *teamListForSheet;
@property (nonatomic, strong) NSMutableArray *searchRefinedList;
@property (nonatomic, assign) BOOL sortByNumber;
@property (nonatomic, assign) BOOL isDown;
@property (nonatomic, assign) BOOL isShowingFavorites;
@property (nonatomic, strong) NSString *filterTag;
@property (nonatomic, strong) FilterVC *filterVC;
@property (nonatomic, strong) UIView *filterDropDown;
@end

@implementation TeamListVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //self.title = VIEWCONTROLLER_TITLES_TEAMLIST;
    self.isDown = NO;
    self.filterTag = @"All";
    self.isShowingFavorites = NO;
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [[GlobalAsset sharedInstance] coreTheme];
    self.navigationController.navigationBar.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationController.navigationBar.titleTextAttributes = @{
                                                                    NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:20.0f],
                                                                    NSForegroundColorAttributeName: [[GlobalAsset sharedInstance] coreFontColor]
                                                                    };
    self.viewControllerTitleLbl.textColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.listModeLbl.textColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.dropDownBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    [self.dropDownBtn addTarget:self action:@selector(showDropDown) forControlEvents:UIControlEventTouchDown];

    //Retreive prefered sorting method, then excecute
    self.sortByNumber = [[NSUserDefaults standardUserDefaults] boolForKey:@"sortByNumber"];
    if (self.sortByNumber) {
        [self changeSortBtnToABCandSortAs123:NO];
    } else {
        [self changeSortBtnTo123andSortAsABC:NO];
    }
    self.searchBar.delegate = self;
    self.searchBar.tintColor= [UIColor whiteColor];
    
    self.splitViewController.delegate = self;
    self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
    
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(closeSheet)];
    close.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    [close setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:18.0]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = close;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDropDown)];
    [self.centerTitleArea addGestureRecognizer:tapGesture];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadSource];
    [self searchBarSearchButtonClicked:self.searchBar];
}

- (void)reloadSource {
    if (self.isShowingFavorites) {
        self.teamListForSheet = [[CDDataManager sharedInstance] getFavoritedTeamListForSheet:self.sheet];
    } else {
        self.teamListForSheet = [[CDDataManager sharedInstance] getTeamListForSheet:self.sheet];
    }
    [self searchBarSearchButtonClicked:self.searchBar];
    [self sortTeams];
    [self.tableView reloadData];
}

- (void)closeSheet {
    [self.splitViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Sorting

- (void)changeSortBtnToABCandSortAs123:(BOOL)animate {
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"] style:UIBarButtonItemStylePlain target:self action:@selector(addTeam)];
    UIColor *tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    NSArray *images = @[
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_17"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_16"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_15"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_14"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_13"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_12"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_11"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_10"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_09"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_08"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_07"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_06"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_05"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_04"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_03"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_02"]],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_01"]]
                       ];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"SortABC"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.animationImages = images;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = imageView.bounds;
    [button addSubview:imageView];
    [button addTarget:self action:@selector(swapSort) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[addBtn, barButton];
    imageView.animationDuration = .7;
    imageView.animationRepeatCount = 1;
    if (animate) [imageView startAnimating];

}

- (void)changeSortBtnTo123andSortAsABC: (BOOL)animate {
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"] style:UIBarButtonItemStylePlain target:self action:@selector(addTeam)];
    
    UIColor *tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    NSArray *images = @[
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_01.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_02.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_03.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_04.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_05.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_06.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_07.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_08.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_09.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_10.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_11.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_12.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_13.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_14.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_15.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_16.png"] ],
                       [self imageTintedWithColor:tintColor image:[UIImage imageNamed:@"icon_17.png"] ]
                       ];
 
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"Sort123"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
    imageView.animationImages = images;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = imageView.bounds;
    [button addSubview:imageView];
    [button addTarget:self action:@selector(swapSort) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    addBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
   
    self.navigationItem.rightBarButtonItems = @[addBtn, barButton];
    imageView.animationDuration = .7;
    imageView.animationRepeatCount = 1;
    if (animate) [imageView startAnimating];
    
}

- (UIImage *)imageTintedWithColor:(UIColor *)tintColor image:(UIImage *)image {
    CGRect imageBounds = CGRectMake( 0, 0, image.size.width, image.size.height );
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( context, 0, image.size.height );
    CGContextScaleCTM( context, 1.0, -1.0 );
    CGContextClipToMask( context, imageBounds, image.CGImage );
    [tintColor setFill];
    CGContextFillRect( context, imageBounds );
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}

- (void)swapSort {
    if (!self.sortByNumber) {
        [self changeSortBtnToABCandSortAs123:YES];
    } else {
        [self changeSortBtnTo123andSortAsABC:YES];
    }
    self.sortByNumber = !self.sortByNumber;
    [[NSUserDefaults standardUserDefaults] setBool:self.sortByNumber forKey:@"sortByNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self sortTeams];
    
    [self.tableView reloadData];
}

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

#pragma mark - Create Team

- (void)addTeam {
    [self dismissKeyboard];
    NewTeamVC *newTeam = [self.storyboard instantiateViewControllerWithIdentifier:@"newTeam"];
    newTeam.sheet = self.sheet;
    UINavigationController *navWithNew = [[UINavigationController alloc] initWithRootViewController:newTeam];
    navWithNew.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navWithNew animated:YES completion:nil];
    //[self.navigationController pushViewController:newTeam animated:YES];
}

#pragma mark - Advanced Search

- (void)advancedSearchOptions {
    [self dismissKeyboard];
    AdvancedSearchVC *advancedSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"searchParameters"];
    advancedSearch.sheet = self.sheet;
    [self.navigationController pushViewController:advancedSearch animated:YES];
}

- (void)predicateStringFromAdvancedSearch:(NSString *)predicateString {
    self.advancedSearchPredicateString = predicateString;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.searchRefinedList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"teamCell" forIndexPath:indexPath];
    CDTeam *team = [self.searchRefinedList objectAtIndex:indexPath.row];
    if (self.sortByNumber) {
        [cell.primaryLabel setText:team.teamNumber];
        [cell.secondaryLabel setText:team.teamName];
    } else {
        [cell.primaryLabel setText:team.teamName];
        [cell.secondaryLabel setText:team.teamNumber];
    }
    
    if ([team.isFavorited boolValue]) {
        cell.favoritedImg.image = [UIImage imageNamed:@"Unfavorite"];
    } else {
        cell.favoritedImg.image = nil;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CDTeam *teamToDel = [self.searchRefinedList objectAtIndex:indexPath.row];
        [[CDDataManager sharedInstance] removeTeamFromSheet:self.sheet teamID:teamToDel.teamIdentifier];
        self.teamListForSheet = [[CDDataManager sharedInstance] getTeamListForSheet:self.sheet];
        [self.searchRefinedList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //ScoutingDataVC *scoutingData = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingData"];
    //scoutingData.sheet = self.sheet;
    //scoutingData.team = [self.searchRefinedList objectAtIndex:indexPath.row];
    //[self.navigationController pushViewController:scoutingData animated:YES];
    
    [self performSegueWithIdentifier:@"showTeam" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showTeam"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        UINavigationController *nav = segue.destinationViewController;
        ScoutingDataVC *scoutingData = [nav.viewControllers objectAtIndex:0];
        scoutingData.sheet = self.sheet;
        scoutingData.team = [self.searchRefinedList objectAtIndex:indexPath.row];
        [scoutingData reloadData];
        [scoutingData.tableView reloadData];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

#pragma mark - Searching Helper Methods

- (void)updateSearchRefinedList {
    self.searchRefinedList = self.teamListForSheet.mutableCopy;
    if ([self.searchRefinedList count] == 0) {
        self.searchRefinedList = self.teamListForSheet.mutableCopy;
    }
}

#pragma mark - Searching Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *searchString = [searchBar text];
    NSLog(@"SEARCHING: %@", searchString);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(teamName BEGINSWITH[c] %@) || (teamNumber BEGINSWITH %@)", searchString, searchString];
    self.searchRefinedList = [self.teamListForSheet filteredArrayUsingPredicate:predicate].mutableCopy;
    if ([self.searchRefinedList count] == 0) {
        self.searchRefinedList = self.teamListForSheet.mutableCopy;
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar sizeToFit];
    [self.searchBar setShowsCancelButton:YES animated:YES];
    self.tableView.tableHeaderView = self.searchBar;
    UIBarButtonItem *advanced = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Advanced"] style:UIBarButtonItemStylePlain target:self action:@selector(advancedSearchOptions)];
    advanced.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationItem.rightBarButtonItems = @[[UIBarButtonItem alloc], advanced];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchBarSearchButtonClicked:searchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsScopeBar:NO];
    [self.searchBar sizeToFit];
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.tableView.tableHeaderView = self.searchBar;
    
    if (self.sortByNumber) {
        [self changeSortBtnToABCandSortAs123:NO];
    } else {
        [self changeSortBtnTo123andSortAsABC:NO];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setText:@""];
    self.advancedSearchPredicateString = @"";
    self.searchRefinedList = [self.teamListForSheet copy];
    [self.tableView reloadData];
    [self.view endEditing:YES];
}

- (void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}



#pragma mark - Drop Down

- (void)showDropDown {
    if (self.isDown) {
        self.tableView.scrollEnabled = YES;
        [UIView animateWithDuration:0.2 animations:^{   [self transform:self.dropDownBtn angle:0];  }];
        
        if (self.filterVC) {
            [self.filterVC closeByTrigger];
        }
       
    } else {
        self.tableView.scrollEnabled = NO;
        [UIView animateWithDuration:0.2 animations:^{   [self transform:self.dropDownBtn angle:180];   }];
        [self presentDropDown];
    }
    [self.view bringSubviewToFront:self.centerTitleArea];
    self.isDown = !self.isDown;
}

- (void)presentDropDown {
    if (!self.filterVC) { //If the VC isn't created...
        self.filterVC = [[FilterVC alloc] init]; //Create it
        self.filterVC.delegate = self; //set the delegate
        self.filterVC.currentFilterTag = self.filterTag; //Pass in the current filter (Fav or All)
        self.filterVC.providesPresentationContextTransitionStyle = YES;
        self.filterVC.definesPresentationContext = YES;
        [self setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        [self.filterVC setModalPresentationStyle:UIModalPresentationCurrentContext];
    
        [self addChildViewController:self.filterVC];  //add vc as child vc
    
        self.filterDropDown = self.filterVC.view;  //take the view out of the filterVC
        [self.view addSubview:self.filterDropDown];  //add it to this view
    }
}

- (void)destroyDropDownMenu {
    //Teardown of the drop down menu
    [self.filterDropDown removeFromSuperview]; //remove the view from this view controller
    [self.filterVC removeFromParentViewController];  //remove the view controller
    self.filterVC = nil; //nil the filterVC
    self.filterDropDown = nil; //nil the drop down view
}

- (void)dialogClosedByTrigger {
    //Destroy the drop down menu when the user taps the arrow/title area up in the nav bar
    [self destroyDropDownMenu];
}

- (void)dialogClosed {
    //Destroy the drop down menu when the user taps anywhere in the grayed out area
    [self destroyDropDownMenu];
    [self showDropDown]; //Call this so the values catch up
}

- (void)dialogClosedWithSelection:(NSString *)filterTag {
    //Destroy the drop down menu when something was tapped
    [self destroyDropDownMenu];
    
    //Set the selected filter that is displayed up top
    self.filterTag = filterTag;
    [self.listModeLbl setText:self.filterTag];
    
    //Call this so the values (isDown) catches up
    [self showDropDown];
    
    //Check the selected filter tag and decide which list to show
    if ([filterTag isEqualToString:@"All"]) {
        self.isShowingFavorites = NO;
    } else {
        self.isShowingFavorites = YES;
    }
    
    //Reload table view data
    [self reloadSource];
}

- (void)transform:(UIView *)view angle:(float)angle {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = (float)-1/500;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle * M_PI / 180, 5, 0, 0);
    view.layer.transform = rotationAndPerspectiveTransform;
    view.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
}

@end
