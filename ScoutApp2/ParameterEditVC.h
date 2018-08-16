//
//  ParameterEditVC.h
//  ScoutApp2
//
//  Created by Matt Panzer on 1/27/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConstraintProtocol <NSObject>
- (void)useConstraintWithDictionary:(NSMutableDictionary*)dictonary;
@end

@interface ParameterEditVC : UITableViewController

@property (nonatomic, weak) id<ConstraintProtocol> delegate;
@property (nonatomic, strong) IBOutlet UISwitch *parameterToggle;
@property (nonatomic, strong) IBOutlet UILabel *valueLabel;
@property (nonatomic, strong) IBOutlet UIView *entryTypeContainer;
@property (nonatomic, strong) IBOutlet UILabel *operatorLabel;
@property (nonatomic, strong) IBOutlet UISegmentedControl *operatorSegment;
@property (nonatomic, retain) CDSheetEntry *sheetEntry;
@property (nonatomic, retain) NSMutableDictionary *constraints;
@property (nonatomic, retain) NSMutableDictionary *parameterInfo;

- (IBAction)activeToggle:(id)sender;

@end
