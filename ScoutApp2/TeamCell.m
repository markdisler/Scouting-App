//
//  TeamCell.m
//  ScoutApp2
//
//  Created by Mark on 7/21/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "TeamCell.h"

@implementation TeamCell

- (void)setUpFrames {
    self.primaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, 300, 31)];
    self.secondaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 41, 300, 21)];
    self.primaryLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:20.0];
    self.secondaryLabel.font = [UIFont fontWithName:@"Avenir-Book" size:17.0];
    [self addSubview:self.primaryLabel];
    [self addSubview:self.secondaryLabel];
}

@end
