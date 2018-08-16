//
//  SheetCell.h
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheetCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *sheetTitle;
@property (strong, nonatomic) IBOutlet UILabel *sheetLastEdit;
@property (strong, nonatomic) IBOutlet UIImageView *sheetThumbnail;
@property (strong, nonatomic) IBOutlet UIView *sheetThumbnailArea;
@property (strong, nonatomic) IBOutlet UIView *sheetImageArea;
@property (strong, nonatomic) IBOutlet UIView *sharingIndicator;
@end
