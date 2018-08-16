//
//  SheetSettingsVC.h
//  ScoutApp2
//
//  Created by Mark on 7/31/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheetSettingsVC : UITableViewController <UIScrollViewDelegate>
@property (nonatomic, strong) CDSheet *sheet;
@property (strong, nonatomic) IBOutlet UITextField *sheetNameField;
@property (strong, nonatomic) IBOutlet UIView *tableHeader;

@end
