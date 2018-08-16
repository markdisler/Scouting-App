//
//  MainAppSettingsVC.m
//  ScoutApp2
//
//  Created by Mark on 1/24/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "MainAppSettingsVC.h"

@interface MainAppSettingsVC ()
@property (nonatomic, strong) UIBarButtonItem *closeBtn;
@end

@implementation MainAppSettingsVC

#pragma mark - View State

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
   
    self.closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    [self.closeBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:DESIGN_FONTS_MAINFONT size:18.0], NSFontAttributeName, nil]forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = self.closeBtn;

    self.title = VIEWCONTROLLER_TITLES_APPSETTINGS;
    
    self.colorThumbnail.layer.cornerRadius = self.colorThumbnail.frame.size.width/2;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.barTintColor = [[GlobalAsset sharedInstance] coreTheme];
    self.colorThumbnail.backgroundColor = [[GlobalAsset sharedInstance] coreTheme];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.closeBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
}

#pragma mark - TableView Delegate/Data Source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    self.colorThumbnail.backgroundColor = [[GlobalAsset sharedInstance] coreTheme];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ThemeSelectorVC *themeSelector = [[ThemeSelectorVC alloc] init];
            [self.navigationController pushViewController:themeSelector animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            AboutViewController *aboutVC = [[AboutViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:aboutVC animated:YES];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; //deselect the cell after tap
}

#pragma mark - Bar Button Actions

- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
