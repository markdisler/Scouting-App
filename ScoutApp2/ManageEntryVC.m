//
//  ManageEntryVC.m
//  ScoutApp2
//
//  Created by Mark on 6/26/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "ManageEntryVC.h"
#import "EntityEditorVC.h"
#import "NewEntityCell.h"
#import "AddEntryCell.h"
#import "PropertyParser.h"
#import "SheetSettingsVC.h"
#import "UIColor+CCColors.h"

@interface ManageEntryVC ()
@property NSArray *entries;
@end

@implementation ManageEntryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //View Controller Setup
    self.title = VIEWCONTROLLER_TITLES_CREATESHEET;
    
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
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Check"] style:UIBarButtonItemStylePlain
                                                            target:self action:@selector(close)];
    done.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationItem.rightBarButtonItem = done;
    
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [tapToDismiss setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapToDismiss];
}

- (void)viewWillAppear:(BOOL)animated {
    [self reloadData];
}

- (void)reloadData {
    self.entries = [[CDDataManager sharedInstance] getEntryListForSheet:self.sheet];
    [self.collectionView reloadData];
}

#pragma mark - Handling the Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.entries count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.entries.count) {
        AddEntryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"addEntry" forIndexPath:indexPath];
        CAShapeLayer *border = [CAShapeLayer layer];
        border.strokeColor = [UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1].CGColor;
        border.fillColor = nil;
        border.lineDashPattern = @[@10, @10];
        border.lineWidth = 1;
        [cell.layer addSublayer:border];
        border.path = [UIBezierPath bezierPathWithRect:cell.bounds].CGPath;
        border.frame = cell.bounds;
        return cell;
    } else {
        NewEntityCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.clipsToBounds = NO;
        cell.backgroundColor = [UIColor whiteColor];
        cell.layer.shadowOpacity = 0.4;
        cell.layer.shadowColor = [UIColor blackColor].CGColor;
        cell.layer.shadowRadius = 4;
        cell.layer.shadowOffset = CGSizeZero;
        
        CDSheetEntry *entry = [self.entries objectAtIndex:indexPath.row];
        EntryType entryType = (EntryType)entry.entryType.integerValue;
        NSString *title = entry.title;
        NSDictionary *propDict = [PropertyParser parseDictionaryForProperties:entry.entryProperties];
        [cell.title setText:title];
        [cell.title setTextColor:[[GlobalAsset sharedInstance] coreFontColor]];
        [cell setInputElement:entryType properties:propDict];
        [cell.editButton setCorrespondingEntryID:entry.entryId];
        [cell.dragButton setCorrespondingEntryID:entry.entryId];
        [cell.editButton setTintColor:[[GlobalAsset sharedInstance] coreFontColor]];
        [cell.dragButton setTintColor:[[GlobalAsset sharedInstance] coreFontColor]];
        
        [cell.headingArea setBackgroundColor:[[GlobalAsset sharedInstance] coreTheme]];
       
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(beginReorderGesture:)];
        [cell.dragButton addGestureRecognizer:longPress];
        [cell.headingArea addGestureRecognizer:longPress];
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //[self editEntryAtIndex:indexPath.row];
    if (indexPath.row == self.entries.count) {
        [self addNewField];
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width - 20, 125);
}

- (void)beginReorderGesture:(id)sender {
    
    UILongPressGestureRecognizer *longPress = (UILongPressGestureRecognizer *)sender;
    UIGestureRecognizerState gestureState = longPress.state;
    
    CGPoint locationOfGesture = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:locationOfGesture];
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (gestureState) {
        case UIGestureRecognizerStateBegan: {
            if (indexPath) {
                sourceIndexPath = indexPath;
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
                
                snapshot = [self makeRegularViewFromCell:cell];
                CGPoint center = cell.center;
                snapshot.center = center;
                snapshot.alpha = 0.0;
                [self.collectionView addSubview:snapshot];
                
                [UIView beginAnimations:@"" context:nil];
                [UIView setAnimationDuration:0.2];
                center.y = locationOfGesture.y;
                snapshot.center = center;
                snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                snapshot.alpha = 0.98;
                cell.alpha = 0.0; // Fade out.
                [UIView commitAnimations];
            }
            break;
        }
            
        case UIGestureRecognizerStateChanged: {
            CGPoint center = snapshot.center;
            center.y = locationOfGesture.y;
            snapshot.center = center;
            
            if (indexPath && ![indexPath isEqual:sourceIndexPath] && indexPath.row != self.entries.count) {
                NSMutableArray *mutableObjects = [NSMutableArray arrayWithArray:self.entries];
                [mutableObjects exchangeObjectAtIndex:indexPath.row withObjectAtIndex:sourceIndexPath.row];
                self.entries = [mutableObjects copy];

                [self.collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:indexPath];
                sourceIndexPath = indexPath;
                
                UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
                cell.alpha = 0.0;
            }
            break;
        }
            
        default: {
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            [UIView animateWithDuration:0.2 animations:^{
                snapshot.center = cell.center;
                snapshot.transform = CGAffineTransformIdentity;
                snapshot.alpha = 0.0;
                cell.alpha = 1.0; // Undo the fade-out effect we did.
            } completion:^(BOOL finished) {
                [snapshot removeFromSuperview];
                snapshot = nil;
            }];
            CDSheetEntry *entry = [self.entries objectAtIndex:sourceIndexPath.row];
            [[CDDataManager sharedInstance] changePositionOnListOfEntry:entry.entryId onSheet:self.sheet newPosition:sourceIndexPath.row];
            [self reloadData];
            sourceIndexPath = nil;
            break;
        }
    }
}

#pragma mark - Helper methods

- (UIView *)makeRegularViewFromCell:(UIView *)cell {
    
    // Take a picture of the cell
    UIGraphicsBeginImageContextWithOptions(cell.bounds.size, NO, 0);
    [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Make a new view with that picture
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}


- (IBAction)selectedEdit:(id)sender {
    EntryButton *editBtn = (EntryButton *)sender;
    [self editEntryWithIdentifier:editBtn.correspondingEntryID];
}

- (IBAction)selectedDrag:(id)sender {
    
}

#pragma mark - Go Into Edit Mode

- (void)editEntryWithIdentifier:(NSString *)identifier {
     EntityEditorVC *entityEditorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"entityEditor"];
     entityEditorVC.sheet = self.sheet;
     entityEditorVC.sheetEntry = [[CDDataManager sharedInstance] getEntry:identifier sheet:self.sheet];
     UINavigationController *navWithEditor = [[UINavigationController alloc] initWithRootViewController:entityEditorVC];
     [self presentViewController:navWithEditor animated:YES completion:nil];
}

#pragma mark - Bar Button Selectors

- (void)openSettings {
    SheetSettingsVC *sheetSettingsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sheetSettingsVC"];
    sheetSettingsVC.sheet = self.sheet;
    [self.navigationController pushViewController:sheetSettingsVC animated:YES];
}

- (void)addNewField {
    EntityEditorVC *entityEditorVC = [self.storyboard instantiateViewControllerWithIdentifier:@"entityEditor"];
    entityEditorVC.sheet = self.sheet;
    UINavigationController *navWithEditor = [[UINavigationController alloc] initWithRootViewController:entityEditorVC];
    [self presentViewController:navWithEditor animated:YES completion:nil];
}

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismiss:(UITapGestureRecognizer *)gesture  {
    [self.view endEditing:YES];
}

@end
