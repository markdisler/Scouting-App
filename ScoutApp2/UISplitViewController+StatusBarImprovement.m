//
//  UISplitViewController+StatusBarImprovement.m
//  ScoutApp2
//
//  Created by Mark on 2/16/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "UISplitViewController+StatusBarImprovement.h"

@implementation UISplitViewController (StatusBarImprovement)

- (UIStatusBarStyle)preferredStatusBarStyle {
    if ([[[GlobalAsset sharedInstance] coreFontColor] isEqual:[UIColor blackColor]]) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

@end
