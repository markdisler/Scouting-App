//
//  ThemeSelectorVC.h
//  ScoutApp2
//
//  Created by Mark on 1/24/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+CCColors.h"
#import "SARoundButton.h"

@interface ThemeSelectorVC : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIView *parentView;

@property (nonatomic, strong) IBOutlet UIView *colorSample;

@property (nonatomic, strong) IBOutlet UISlider *redSlider;
@property (nonatomic, strong) IBOutlet UISlider *greenSlider;
@property (nonatomic, strong) IBOutlet UISlider *blueSlider;

@property (nonatomic, strong) IBOutlet UITextField *redField;
@property (nonatomic, strong) IBOutlet UITextField *blueField;
@property (nonatomic, strong) IBOutlet UITextField *greenField;


@end
