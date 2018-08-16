//
//  NewTeamVC.h
//  ScoutApp2
//
//  Created by Matt Panzer on 1/25/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryTypeAssistant.h"

@interface NewTeamVC : UITableViewController <UITextFieldDelegate>
@property (nonatomic, strong) CDSheet *sheet;
@property IBOutlet UITextField *name;
@property IBOutlet UITextField *number;

- (void)cancel;
- (void)create;
@end
