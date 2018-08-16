//
//  ManageEntryVC.h
//  ScoutApp2
//
//  Created by Mark on 6/26/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageEntryVC : UICollectionViewController
- (IBAction)selectedEdit:(id)sender;
- (IBAction)selectedDrag:(id)sender;
@property (nonatomic, strong) CDSheet *sheet;
@property (strong, nonatomic) IBOutlet UITextField *sheetNameField;

@end
