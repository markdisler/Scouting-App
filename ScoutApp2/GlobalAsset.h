//
//  GlobalAsset.h
//  ScoutApp2
//
//  Created by Mark on 1/24/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GlobalAsset : NSObject

+ (instancetype)sharedInstance;
- (void)determineCoreFontColorBasedOn:(UIColor *)bgColor;
- (void)determineUIComponentColorBasedOnTheme:(UIColor *)themeColor fontColor:(UIColor *)fontColor;
@property (nonatomic, strong) UIColor *coreTheme;
@property (nonatomic, strong) UIColor *coreUIComponentColor;
@property (nonatomic, strong) UIColor *coreFontColor;
@property (nonatomic, assign, readonly) BOOL hasDarkFont;
@end
