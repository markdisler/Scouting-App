//
//  SheetSettingsVC.m
//  ScoutApp2
//
//  Created by Mark on 7/31/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "SheetSettingsVC.h"
#import "UIColor+CCColors.h"
@interface SheetSettingsVC ()
@property (nonatomic, strong) UIButton *selectedImageBtn;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) float imageBtnSize;
@property (nonatomic, strong) NSArray *imageNames;
@property (nonatomic, assign, getter=isSharing) BOOL sharing;
@end

@implementation SheetSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEWCONTROLLER_TITLES_SHEETSETTINGS;
    self.sharing = self.sheet.isSharing.boolValue;
    
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
    UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveSettings)];
    close.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    [close setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:18.0]}
                         forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = close;
    
    //Load in the values
    self.sheetNameField.text = self.sheet.name;
    [self createScroller];
}

- (void)createScroller {
    
    self.imageBtnSize = self.tableHeader.frame.size.height - 30;
    
    self.imageNames = @[@"",@"balls",@"bars",@"blocks",@"cross",@"diamond",@"hexagon",@"pentagon",@"plus",@"poles",@"ramp",@"rings",@"sections",@"seesaw",@"target",@"triangle"];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < self.imageNames.count; i++) {
        NSString *imageName = [self.imageNames objectAtIndex:i];
        
        UIButton *image = [[UIButton alloc] init];
        if (![imageName isEqualToString:@""])
            [image setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        image.tag = i;
        image.layer.borderColor = [UIColor blackColor].CGColor;
        image.layer.borderWidth = 0.5;
        image.frame = CGRectMake(0, 0, self.imageBtnSize, self.imageBtnSize);
        image.layer.cornerRadius = self.imageBtnSize/2;
        [imageArray addObject:image];
    }
    
    
    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:CGRectZero];
    scroller.delegate = self;
    scroller.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableHeader addSubview:scroller];
    
    [scroller.leftAnchor constraintEqualToAnchor:self.tableHeader.leftAnchor].active = YES;
    [scroller.topAnchor constraintEqualToAnchor:self.tableHeader.topAnchor].active = YES;
    [scroller.rightAnchor constraintEqualToAnchor:self.tableHeader.rightAnchor].active = YES;
    [scroller.bottomAnchor constraintEqualToAnchor:self.tableHeader.bottomAnchor].active = YES;
    
    scroller.contentSize = CGSizeMake((self.imageNames.count * self.imageBtnSize) + (self.imageNames.count * 15) + 30, self.tableHeader.frame.size.height);
    
    for (NSInteger i = 0; i < imageArray.count; i++) {
        UIButton *imgBtn = [imageArray objectAtIndex:i];
        [imgBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
        CGRect rect = imgBtn.frame;
        rect.origin.x = (i * imgBtn.frame.size.width) + (i * 15) + 15;
        rect.origin.y = 15;
        imgBtn.frame = rect;
        [scroller addSubview:imgBtn];
    }
    
    NSString *previousImage = self.sheet.imageName;
    for (NSInteger i = 0; i < self.imageNames.count; i++) {
        NSString *imageName = [self.imageNames objectAtIndex:i];
        if (previousImage && [previousImage isEqualToString:imageName]) {
            UIButton *image = [imageArray objectAtIndex:i];
            self.selectedImageBtn = image;
            self.selectedIndex = i;
            [self focusInOnButton:image];
            i = self.imageNames.count;
        }
    }

}

- (void)selectButton:(id)sender {
    if (self.selectedImageBtn) {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedImageBtn.layer.borderWidth = 0.5;
            self.selectedImageBtn.layer.borderColor = [UIColor blackColor].CGColor;
            [self.selectedImageBtn.layer setTransform:CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(1.0, 1.0))];
        }];
    }
    
    UIButton *tappedBtn = (UIButton *)sender;
    [self focusInOnButton:tappedBtn];
}

- (void)focusInOnButton:(UIButton *)b {
    UIButton *tappedBtn = b;
    [UIView animateWithDuration:0.2 animations:^{
        [b.layer setTransform:CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(1.2, 1.2))];
        tappedBtn.layer.borderWidth = 2.0;
        tappedBtn.layer.borderColor = [[GlobalAsset sharedInstance] coreTheme].CGColor;
    }];
    
    self.selectedImageBtn = tappedBtn;
    self.selectedIndex = tappedBtn.tag;
}


#pragma mark - Table View Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self askToDeleteSheet];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //deselect the cell after tap
}

- (void)askToDeleteSheet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Scouting Sheet"
                                                                   message:@"Please confirm this permenant action."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *resetAction = [UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        [[CDDataManager sharedInstance] removeSheet:self.sheet];
        [self exit];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {}];
    [alert addAction:resetAction]; //provide the action to reset
    [alert addAction:cancelAction]; //provide the action to cancel this action
    [self presentViewController:alert animated:YES completion:nil]; //show alert to user
}


#pragma mark - Keyboard dismiss

- (void)dismiss:(UITapGestureRecognizer *)gesture  {
    [self.view endEditing:YES];
}

#pragma mark - Exit and Save

- (void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveSettings {
    NSString *originalName = self.sheet.name;
    NSString *potentialNewName = self.sheetNameField.text;
    if (![originalName isEqualToString:potentialNewName])
        [[CDDataManager sharedInstance] renameSheet:self.sheet newName:potentialNewName];
    
    NSString *originalImage = self.sheet.imageName;
    NSString *potentialNewImage = [self.imageNames objectAtIndex:self.selectedIndex];
    if (![originalImage isEqualToString:potentialNewImage])
        [[CDDataManager sharedInstance] setImageForSheet:self.sheet imageName:potentialNewImage];
    
    [self exit];
}

@end
