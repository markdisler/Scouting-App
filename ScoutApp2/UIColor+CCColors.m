//
//  UIColor+CCColors.m
//  CapCalc
//
//  Created by Mark on 5/19/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "UIColor+CCColors.h"

@implementation UIColor (CCColors)

#pragma mark - Reds
+ (UIColor *)CCRed1 { return colorHex(@"#EF9A9A"); }
+ (UIColor *)CCRed2 { return colorHex(@"#F44336"); }
+ (UIColor *)CCRed3 { return colorHex(@"#C62828"); }
+ (UIColor *)SARed1 { return colorHex(@"#FF2E2E"); }

#pragma mark - Oranges
+ (UIColor *)CCOrange1 { return colorHex(@"#FFCC80"); }
+ (UIColor *)CCOrange2 { return colorHex(@"#FF9800"); }
+ (UIColor *)CCOrange3 { return colorHex(@"#EF6C00"); }

#pragma mark - Yellows
+ (UIColor *)CCYellow1 { return colorHex(@"#FFF59D"); }
+ (UIColor *)CCYellow2 { return colorHex(@"#FFEB3B"); }
+ (UIColor *)CCYellow3 { return colorHex(@"#FBC02D"); }

#pragma mark - Greens
+ (UIColor *)CCGreen1 { return colorHex(@"#A5D6A7"); }
+ (UIColor *)CCGreen2 { return colorHex(@"#4CAF50"); }
+ (UIColor *)CCGreen3 { return colorHex(@"#2E7D32"); }
+ (UIColor *)SAGreen1 { return colorHex(@"#13E000"); }

#pragma mark - Blues
+ (UIColor *)CCBlue1 { return colorHex(@"#90CAF9"); }
+ (UIColor *)CCBlue2 { return colorHex(@"#2196F3"); }
+ (UIColor *)CCBlue3 { return colorHex(@"#1565C0"); }
+ (UIColor *)SABlue1 { return colorHex(@"#1565C0"); }

#pragma mark - Indigos
+ (UIColor *)CCIndigo1 { return colorHex(@"#9FA8DA"); }
+ (UIColor *)CCIndigo2 { return colorHex(@"#3F51B5"); }
+ (UIColor *)CCIndigo3 { return colorHex(@"#283593"); }

#pragma mark - Purples
+ (UIColor *)CCPurple1 { return colorHex(@"#B39DDB"); }
+ (UIColor *)CCPurple2 { return colorHex(@"#673AB7"); }
+ (UIColor *)CCPurple3 { return colorHex(@"#4527A0"); }

#pragma mark - Pinks
+ (UIColor *)CCPink1 { return colorHex(@"#F48FB1"); }
+ (UIColor *)CCPink2 { return colorHex(@"#E91E63"); }
+ (UIColor *)CCPink3 { return colorHex(@"#AD1457"); }

#pragma mark - Blue Grays
+ (UIColor *)CCBlueGray1 { return colorHex(@"#B0BEC5"); }
+ (UIColor *)CCBlueGray2 { return colorHex(@"#607D8B"); }
+ (UIColor *)CCBlueGray3 { return colorHex(@"#37474F"); }

#pragma mark - Browns
+ (UIColor *)CCBrown1 { return colorHex(@"#BCAAA4"); }
+ (UIColor *)CCBrown2 { return colorHex(@"#795548"); }
+ (UIColor *)CCBrown3 { return colorHex(@"#4E342E"); }

#pragma mark - Grays
+ (UIColor *)CCGray1 { return colorHex(@"#EEEEEE"); }
+ (UIColor *)CCGray2 { return colorHex(@"#9E9E9E"); }
+ (UIColor *)CCGray3 { return colorHex(@"#424242"); }

#pragma mark - Teals
+ (UIColor *)CCTeal1 { return colorHex(@"#80CBC4"); }
+ (UIColor *)CCTeal2 { return colorHex(@"#009688"); }
+ (UIColor *)CCTeal3 { return colorHex(@"#00695C"); }

+ (UIColor *)SARed          { return colorHex(@"#F44336"); }
+ (UIColor *)SAPink         { return colorHex(@"#E91E63"); }
+ (UIColor *)SAPurple       { return colorHex(@"#9C27B0"); }
+ (UIColor *)SADeepPurple   { return colorHex(@"#673AB7"); }
+ (UIColor *)SAIndigo       { return colorHex(@"#3F51B5"); }
+ (UIColor *)SABlue         { return colorHex(@"#2196F3"); }
+ (UIColor *)SALightBlue    { return colorHex(@"#03A9F4"); }
+ (UIColor *)SACyan         { return colorHex(@"#00BCD4"); }
+ (UIColor *)SATeal         { return colorHex(@"#009688"); }
+ (UIColor *)SAGreen        { return colorHex(@"#4CAF50"); }
+ (UIColor *)SALightGreen   { return colorHex(@"#8BC34A"); }
+ (UIColor *)SALime         { return colorHex(@"#CDDC39"); }
+ (UIColor *)SAYellow       { return colorHex(@"#FFEB3B"); }
+ (UIColor *)SAAmber        { return colorHex(@"#FFC107"); }
+ (UIColor *)SAOrange       { return colorHex(@"#FF9800"); }
+ (UIColor *)SADeepOrange   { return colorHex(@"#FF5722"); }
+ (UIColor *)SABrown        { return colorHex(@"#795548"); }
+ (UIColor *)SAGray         { return colorHex(@"#9E9E9E"); }
+ (UIColor *)SABlueGray     { return colorHex(@"#607D8B"); }
+ (UIColor *)SABlack        { return colorHex(@"#000000"); }
#pragma mark - Methods

+ (NSArray *)getMediumColors {
    return @[[UIColor CCRed2], [UIColor CCOrange2], [UIColor CCYellow2], [UIColor CCGreen2], [UIColor CCBlue2], [UIColor CCBlueGray2], [UIColor CCIndigo2], [UIColor CCPurple2], [UIColor CCPink2], [UIColor CCTeal2], [UIColor CCBrown2], [UIColor CCGray2]];
}

+ (NSArray *)getSAColors {
    return @[[UIColor SARed],
             [UIColor SAPink],
             [UIColor SAPurple],
             [UIColor SADeepPurple],
             [UIColor SAIndigo],
             [UIColor SABlue],
             [UIColor SALightBlue],
             [UIColor SACyan],
             [UIColor SATeal],
             [UIColor SAGreen],
             [UIColor SALightGreen],
             [UIColor SALime],
             [UIColor SAYellow],
             [UIColor SAAmber],
             [UIColor SAOrange],
             [UIColor SADeepOrange],
             [UIColor SABrown],
             [UIColor SAGray],
             [UIColor SABlueGray],
             [UIColor SABlack]];
}

+ (UIColor *)textColorForBG:(UIColor*)c {
    CGFloat hue, saturation, brightness, alpha;
    [c getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    
    if (brightness > 0.8f)   return [UIColor blackColor];
    return [UIColor whiteColor];
}

+ (NSString *)hexStringForColor:(UIColor*)c {
    const CGFloat *components = CGColorGetComponents(c.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    NSString *hexString = [NSString stringWithFormat:@"#%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
    return hexString;
}

UIColor* colorHex (NSString* hexString) {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    CGFloat r = ((rgbValue & 0xFF0000) >> 16);
    CGFloat g = ((rgbValue & 0xFF00) >> 8);
    CGFloat b = (rgbValue & 0xFF);
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
}

UIColor* colorRGB (int r, int g, int b){
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f];
}

@end
