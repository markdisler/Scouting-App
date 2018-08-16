//
//  GlobalAsset.m
//  ScoutApp2
//
//  Created by Mark on 1/24/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "GlobalAsset.h"
#import "UIColor+CCColors.h"

@interface GlobalAsset ()
@property (nonatomic, assign, readwrite) BOOL hasDarkFont;
@end

@implementation GlobalAsset

+ (instancetype)sharedInstance {
    static GlobalAsset *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalAsset alloc] init];
    });
    return sharedInstance;
}

- (void)determineCoreFontColorBasedOn:(UIColor *)bgColor {
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    [bgColor getRed:&red green:&green blue:&blue alpha:&alpha];

    red *= 255;
    green *= 255;
    blue *= 255;
    
    float threshold = 200;
    float brightness = sqrtf((0.241 * red * red) + (0.691 * green  * green) + (0.068 * blue * blue));

    if (brightness > threshold) {
        self.hasDarkFont = YES;
        self.coreFontColor = [UIColor blackColor];
    } else {
        self.hasDarkFont = NO;
        self.coreFontColor = [UIColor whiteColor];
    }
}

- (void)determineUIComponentColorBasedOnTheme:(UIColor *)themeColor fontColor:(UIColor *)fontColor {
    if ([fontColor isEqual:[UIColor blackColor]]) {
        self.coreUIComponentColor = fontColor;
    } else {
        self.coreUIComponentColor = themeColor;
    }
}

@end
