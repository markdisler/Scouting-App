//
//  SheetsVC.m
//  ScoutApp2
//
//  Created by Mark on 6/26/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "SheetsVC.h"

@interface SheetsVC ()
@property (nonatomic, strong) NSArray *sheets;
@property (nonatomic, strong) UILabel *noSheetsLbl;
@property (nonatomic, assign) BOOL editMode;
@end

@implementation SheetsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Configure some values
    self.title = VIEWCONTROLLER_TITLES_SHEETLIST;
    self.editMode = NO;
    
    //Check if it is the first time the app is running
    BOOL isFirst = ![[NSUserDefaults standardUserDefaults] boolForKey:@"firstUse"];
    
    if (isFirst) {
        [[NSUserDefaults standardUserDefaults] setValue:@"#1565C0" forKey:@"theme"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstUse"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSString *themeHexString = [[NSUserDefaults standardUserDefaults] valueForKey:@"theme"];
    [[GlobalAsset sharedInstance] setCoreTheme:colorHex(themeHexString)];
    [[GlobalAsset sharedInstance] determineCoreFontColorBasedOn:colorHex(themeHexString)];
    [[GlobalAsset sharedInstance] determineUIComponentColorBasedOnTheme:[[GlobalAsset sharedInstance] coreTheme] fontColor:[[GlobalAsset sharedInstance] coreFontColor]];
    //Create the Bar Buttons
    [self changeButtonToEdit];
    
    UIBarButtonItem *settingsBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Settings"] style:UIBarButtonItemStylePlain target:self action:@selector(goToAppSettings)];
    settingsBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationItem.leftBarButtonItem = settingsBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    //Set appearance for nav bar
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationController.navigationBar.barTintColor = [[GlobalAsset sharedInstance] coreTheme];
    self.navigationController.navigationBar.titleTextAttributes = @{
        NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:20.0f],
        NSForegroundColorAttributeName: [[GlobalAsset sharedInstance] coreFontColor]
    };
    self.navigationItem.leftBarButtonItem.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    for (UIBarButtonItem *btn in self.navigationItem.rightBarButtonItems) {
        btn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    }
    
    if ([[[GlobalAsset sharedInstance] coreFontColor] isEqual:[UIColor blackColor]]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPress.delegate = self;
    longPress.delaysTouchesBegan = YES;
    [self.collectionView addGestureRecognizer:longPress];
    
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.editMode)
        [self endEditMode];
}

- (void)reloadData {
    self.sheets = [[CDDataManager sharedInstance] getSheetList];
    [self.collectionView reloadData];
}

#pragma mark - Change Edit Status

- (void)changeButtonToEdit {
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"] style:UIBarButtonItemStylePlain
                                                              target:self action:@selector(addNewSheet)];
    
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Edit"] style:UIBarButtonItemStylePlain
                                                            target:self action:@selector(startEditMode)];
    
    [edit setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:18.0]} forState:UIControlStateNormal];
    
    addBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    edit.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    
    self.navigationItem.rightBarButtonItems = @[addBtn, edit];
    
}

- (void)changeButtonToDone {
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Add"] style:UIBarButtonItemStylePlain
                                                              target:self action:@selector(addNewSheet)];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Check"] style:UIBarButtonItemStylePlain
                                                            target:self action:@selector(endEditMode)];
    
    addBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    done.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    
    self.navigationItem.rightBarButtonItems = @[addBtn, done];
}

- (void)startEditMode {
    [self changeButtonToDone];
    [self startShaking];
    self.editMode = YES;
}

- (void)endEditMode {
    [self changeButtonToEdit];
    [self stopShaking];
    self.editMode = NO;
}

- (void)startShaking {
    NSInteger delayV = 0;
    for (SheetCell *cell in self.collectionView.visibleCells) {
        if ([cell isKindOfClass:SheetCell.class]) {
            [UIView animateWithDuration:0.15
                                  delay:delayV/10.0
                                options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 [self transform:cell angle:6 x:5];
                                 [self transform:cell angle:-6 x:5];
                             }
                             completion:nil];
            delayV ++;
            if (delayV == 3) delayV = 0;
        }
    }
}

- (void)transform:(UIView*)view angle:(float)angle x:(float)x {
    CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
    rotationAndPerspectiveTransform.m34 = (float)-1/500;
    rotationAndPerspectiveTransform = CATransform3DRotate(rotationAndPerspectiveTransform, angle * M_PI / 180, x, 0, 0);
    view.layer.transform = rotationAndPerspectiveTransform;
    view.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
}

- (void)stopShaking {
    for (SheetCell *cell in self.collectionView.visibleCells) {
        [cell.layer removeAllAnimations];
        [self transform:cell angle:0 x:5];
    }
}

#pragma mark - Handling the Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.sheets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SheetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sheetCell" forIndexPath:indexPath];
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 0.4;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowRadius = 2;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeZero;
   
    cell.sheetImageArea.layer.shadowColor = [[GlobalAsset sharedInstance] coreTheme].CGColor;
    cell.sheetImageArea.layer.borderColor = [[GlobalAsset sharedInstance] coreTheme].CGColor;
    cell.sheetImageArea.layer.borderWidth = 0.5;
    cell.sheetImageArea.layer.cornerRadius = cell.sheetImageArea.frame.size.width/2;
    cell.sheetImageArea.layer.shadowOpacity = 0.3;
    cell.sheetImageArea.layer.shadowOffset = CGSizeZero;
    cell.sheetImageArea.layer.shadowRadius = 3;
    cell.sheetThumbnail.clipsToBounds = YES;
    
    cell.sharingIndicator.backgroundColor = [[GlobalAsset sharedInstance] coreTheme];
    
    CDSheet *sheet = [self.sheets objectAtIndex:indexPath.row];
    [cell.sheetTitle setText:sheet.name];
    [cell.sheetTitle setTextColor:[UIColor blackColor]];
    [cell.sheetLastEdit setTextColor:[UIColor blackColor]];
    [cell.sharingIndicator setHidden:YES];//!sheet.isSharing.boolValue];
    [cell.sheetLastEdit setText:sheet.isSharing.boolValue ? @"Shared" : @"Local"];
    [cell.sheetThumbnail setImage:(![sheet.imageName isEqualToString:@""]) ? [UIImage imageNamed:sheet.imageName] : nil];
  
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editMode) {
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        [self showEditActionSheet:indexPath.row cell:cell];
    } else
        [self selectToOpenSheet:indexPath.row];
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    float inset = 80/3;
    return UIEdgeInsetsMake(inset,inset,inset,inset);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(150, 220); //(self.view.frame.size.width-80)/2
}

#pragma mark - Sheet Accessing

- (void)selectToOpenSheet:(NSInteger)index {
    //UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
    
    UISplitViewController *splitViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"splitView"];
    
    CDSheet *sheet = [self.sheets objectAtIndex:index];
    UINavigationController *nav = [splitViewController.viewControllers objectAtIndex:0];
    TeamListVC *teamList = [nav.viewControllers objectAtIndex:0];
    //[self.storyboard instantiateViewControllerWithIdentifier:@"teamList"];
    teamList.sheet = sheet;
    //[self.navigationController pushViewController:teamList animated:YES];
    //ScoutingDataVC *scoutingData = [self.storyboard instantiateViewControllerWithIdentifier:@"scoutingData"];
    //UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:teamList];
    //UINavigationController *detailNav = [self.storyboard instantiateViewControllerWithIdentifier:@"teamNav"];
    //splitViewController.viewControllers = @[rootNav, detailNav];
    [self presentViewController:splitViewController animated:YES completion:nil];
}

- (void)selectToEditSheet:(NSInteger)index {
    [self endEditMode];
    ManageEntryVC *manageEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"manageEntryVC"];
    manageEntryVC.sheet = [self.sheets objectAtIndex:index];
    UINavigationController *navWithEdit = [[UINavigationController alloc] initWithRootViewController:manageEntryVC];
    [self presentViewController:navWithEdit animated:YES completion:nil];
}

- (void)selectToAccessSheetSettings:(NSInteger)index {
    [self endEditMode];
    SheetSettingsVC *sheetSettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sheetSettingsVC"];
    sheetSettingsVC.sheet = [self.sheets objectAtIndex:index];
    UINavigationController *navWithSheetSettings = [[UINavigationController alloc] initWithRootViewController:sheetSettingsVC];
    [self presentViewController:navWithSheetSettings animated:YES completion:nil];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    if (indexPath) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        [self showEditActionSheet:indexPath.row cell:cell];
    }

}

- (void)showEditActionSheet:(NSInteger)index cell:(UICollectionViewCell *)cell {
    UIAlertController *sheetActions = [UIAlertController alertControllerWithTitle:nil message:nil
                                                                   preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *editSheet = [UIAlertAction actionWithTitle:@"Modify Sheet"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {
                                                          [self selectToEditSheet:index];
                                                      }];
    UIAlertAction *sheetSettings = [UIAlertAction actionWithTitle:@"Sheet Settings"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *action) {
                                                              [self selectToAccessSheetSettings:index];
                                                          }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [sheetActions addAction:editSheet];
    [sheetActions addAction:sheetSettings];
    [sheetActions addAction:cancel];
    sheetActions.popoverPresentationController.sourceView = self.collectionView;
    sheetActions.popoverPresentationController.permittedArrowDirections = 1;
    sheetActions.popoverPresentationController.sourceRect = CGRectMake(cell.frame.origin.x + cell.frame.size.width/2, cell.frame.origin.y + cell.frame.size.height, 1.0, 1.0);
    [self presentViewController:sheetActions animated:YES completion:nil];
}


#pragma mark - Bar Button Selectors

- (void)addNewSheet {
    CDSheet *newSheet = [[CDDataManager sharedInstance] addSheet:@"Untitled"];
    
    ManageEntryVC *manageEntryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"manageEntryVC"];
    manageEntryVC.sheet = newSheet;
    UINavigationController *navWithCreate = [[UINavigationController alloc] initWithRootViewController:manageEntryVC];
    [self presentViewController:navWithCreate animated:YES completion:nil];
}

- (void)goToAppSettings {
    MainAppSettingsVC *appSettings = [self.storyboard instantiateViewControllerWithIdentifier:@"AppSettings"];
    UINavigationController *navWithSettings = [[UINavigationController alloc] initWithRootViewController:appSettings];
    [self presentViewController:navWithSettings animated:YES completion:nil];
}

@end
