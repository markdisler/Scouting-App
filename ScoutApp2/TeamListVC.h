//
//  TeamListVC.h
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvancedSearchVC.h"
#import "FilterVC.h"

@interface TeamListVC : UITableViewController <UISearchBarDelegate, UISplitViewControllerDelegate, DropDownDelegate>

@property (strong, nonatomic) IBOutlet UIView *centerTitleArea;
@property (strong, nonatomic) IBOutlet UILabel *viewControllerTitleLbl;
@property (strong, nonatomic) IBOutlet UILabel *listModeLbl;
@property (strong, nonatomic) IBOutlet UIButton *dropDownBtn;


@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) CDSheet *sheet;
@property (nonatomic, strong) NSString *advancedSearchPredicateString;
@end
