//
//  EntityEditorVC.h
//  ScoutApp2
//
//  Created by Mark on 6/26/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntityEditorVC : UITableViewController <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSDictionary *properties;

@property (strong, nonatomic) CDSheet *sheet;
@property (strong, nonatomic) CDSheetEntry *sheetEntry;
@end
