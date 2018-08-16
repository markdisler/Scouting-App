//
//  AboutCell.m
//  CapCalc
//
//  Created by Mark on 10/6/15.
//  Copyright © 2015 mark. All rights reserved.
//

#import "AboutCell.h"

@implementation AboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)layoutSubviews {
    [super layoutSubviews];

    CGPoint oldCenter = self.imageView.center;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, self.imageView.frame.size.width * 0.6, self.imageView.frame.size.height * 0.6);
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width/2;
    self.imageView.center = oldCenter;
}
@end
