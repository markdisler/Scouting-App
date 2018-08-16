//
//  TeamCell.h
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *primaryLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondaryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *favoritedImg;
- (void)setUpFrames;

@end
