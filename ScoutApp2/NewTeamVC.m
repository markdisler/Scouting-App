//
//  NewTeamVC.m
//  ScoutApp2
//
//  Created by Matt Panzer on 1/25/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "NewTeamVC.h"

@interface NewTeamVC ()

@property (nonatomic, strong) UIBarButtonItem *createBtn;
@end

@implementation NewTeamVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = VIEWCONTROLLER_TITLES_ADDTEAM;
    
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
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Close"] style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    cancel.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    
    self.createBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Check"] style:UIBarButtonItemStylePlain target:self action:@selector(create)];
    self.createBtn.tintColor = [[GlobalAsset sharedInstance] coreFontColor];;
    self.createBtn.enabled = NO;
    self.navigationItem.leftBarButtonItem = cancel;
    self.navigationItem.rightBarButtonItem = self.createBtn;
    
    self.name.delegate = self;
    self.number.delegate = self;
    
    [self.name addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.number addTarget:self action:@selector(textValueChanged:) forControlEvents:UIControlEventEditingChanged];
    
    UITapGestureRecognizer *tapToDismiss = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [tapToDismiss setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tapToDismiss];
}

- (void)textValueChanged:(id)sender {
    if (self.name.text.length > 0 && self.number.text.length > 0) {
        self.createBtn.enabled = YES;
    } else {
        self.createBtn.enabled = NO;
    }
}

- (void)cancel {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)create {
    [self.view endEditing:YES];
    NSString *name = self.name.text;
    NSString *number = self.number.text;
    
    if (![name isEqualToString:@""] && ![number isEqualToString:@""]) {
        NSString *teamID = [[CDDataManager sharedInstance] addTeamToSheet:self.sheet teamName:name teamNumber:number];
        NSArray *sheetFields = [[CDDataManager sharedInstance] getEntryListForSheet:self.sheet];
        
        for (CDSheetEntry *sheetEntry in sheetFields) {
            EntryType entryType = (EntryType)sheetEntry.entryType.integerValue;
            NSString *value = [EntryTypeAssistant getDefaultValueForEntryType:entryType];
            [[CDDataManager sharedInstance] updateAttribute:sheetEntry.entryId withValue:value forTeam:teamID sheet:self.sheet];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)dismiss:(UITapGestureRecognizer *)gesture  {
    [self.view endEditing:YES];
}

@end
