//
//  ThemeSelectorVC.m
//  ScoutApp2
//
//  Created by Mark on 1/24/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "ThemeSelectorVC.h"

@interface ThemeSelectorVC ()

@property (nonatomic, assign) float r;
@property (nonatomic, assign) float g;
@property (nonatomic, assign) float b;
@property (nonatomic, assign) BOOL isPortrait;
@end

@implementation ThemeSelectorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = VIEWCONTROLLER_TITLES_THEMESELECTOR;
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1.0f];

    [self createUI];
    self.isPortrait = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToCloseKeyboard:)];
    [self.view addGestureRecognizer:singleTap];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    UIColor *themeColor = [UIColor colorWithRed:self.r/255.0 green:self.g/255.0 blue:self.b/255.0 alpha:1.0];
    NSString *hexVal = [UIColor hexStringForColor:themeColor];
    [[NSUserDefaults standardUserDefaults] setValue:hexVal forKey:@"theme"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)createUI {
    self.colorSample = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 60, 60)];
    self.colorSample.layer.borderColor = [UIColor whiteColor].CGColor;
    self.colorSample.layer.borderWidth = 2.0;
    self.colorSample.translatesAutoresizingMaskIntoConstraints = NO;
    self.colorSample.layer.cornerRadius = self.colorSample.frame.size.width/2;
    [self.view addSubview:self.colorSample];
    
    self.parentView = [[UIView alloc] initWithFrame:CGRectZero];
  //  self.parentView.backgroundColor = [UIColor darkGrayColor];
    self.parentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.parentView];

    self.redSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.redSlider addTarget:self action:@selector(redSliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.redSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.redSlider.minimumTrackTintColor = [UIColor redColor];
    self.redSlider.maximumValue = 255;
    [self.parentView addSubview:self.redSlider];
    
    self.greenSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.greenSlider addTarget:self action:@selector(greenSliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.greenSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.greenSlider.minimumTrackTintColor = [UIColor greenColor];
    self.greenSlider.maximumValue = 255;
    [self.parentView addSubview:self.greenSlider];
    
    self.blueSlider = [[UISlider alloc] initWithFrame:CGRectZero];
    [self.blueSlider addTarget:self action:@selector(blueSliderChanged:) forControlEvents:UIControlEventValueChanged];
    self.blueSlider.translatesAutoresizingMaskIntoConstraints = NO;
    self.blueSlider.minimumTrackTintColor = [UIColor blueColor];
    self.blueSlider.maximumValue = 255;
    [self.parentView addSubview:self.blueSlider];
    
    self.redField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.redField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.redField setDelegate:self];
    [self.redField addTarget:self action:@selector(redFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.redField.translatesAutoresizingMaskIntoConstraints = NO;
    self.redField.textAlignment = NSTextAlignmentCenter;
    self.redField.keyboardType = UIKeyboardTypeNumberPad;
    self.redField.text = [NSString stringWithFormat:@"%g", self.redSlider.value];
    self.redField.font = [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:16.0];
    [self.parentView addSubview:self.redField];
    
    self.greenField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.greenField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.greenField setDelegate:self];
    [self.greenField addTarget:self action:@selector(greenFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.greenField.translatesAutoresizingMaskIntoConstraints = NO;
    self.greenField.textAlignment = NSTextAlignmentCenter;
    self.greenField.keyboardType = UIKeyboardTypeNumberPad;
    self.greenField.text = [NSString stringWithFormat:@"%g", self.greenSlider.value];
    self.greenField.font = [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:16.0];
    [self.parentView addSubview:self.greenField];
    
    self.blueField = [[UITextField alloc] initWithFrame:CGRectZero];
    [self.blueField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.blueField setDelegate:self];
    [self.blueField addTarget:self action:@selector(blueFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
    self.blueField.translatesAutoresizingMaskIntoConstraints = NO;
    self.blueField.textAlignment = NSTextAlignmentCenter;
    self.blueField.keyboardType = UIKeyboardTypeNumberPad;
    self.blueField.text = [NSString stringWithFormat:@"%g", self.blueSlider.value];
    self.blueField.font = [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:16.0];
    [self.parentView addSubview:self.blueField];
    
    UIColor *startColor = [[GlobalAsset sharedInstance] coreTheme];
    const CGFloat *components = CGColorGetComponents(startColor.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    self.r = (NSInteger)(r * 255.0);
    self.g = (NSInteger)(g * 255.0);
    self.b = (NSInteger)(b * 255.0);
    self.redField.text = [NSString stringWithFormat:@"%g", self.r];
    self.greenField.text = [NSString stringWithFormat:@"%g", self.g];
    self.blueField.text = [NSString stringWithFormat:@"%g", self.b];
    [self.redSlider setValue:self.r animated:YES];
    [self.greenSlider setValue:self.g animated:YES];
    [self.blueSlider setValue:self.b animated:YES];
    
    self.colorSample.backgroundColor = [UIColor colorWithRed: self.r/255.0 green:self.g/255.0 blue:self.b/255.0 alpha:1.0];

    [self.colorSample.centerYAnchor constraintEqualToAnchor:self.parentView.centerYAnchor].active = YES;
    [self.colorSample.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:15.0].active = YES;
    [self.colorSample.widthAnchor constraintEqualToConstant:self.colorSample.frame.size.width].active = YES;
    [self.colorSample.heightAnchor constraintEqualToConstant:self.colorSample.frame.size.height].active = YES;
    
    
    [self.redField.topAnchor constraintEqualToAnchor:self.parentView.topAnchor constant:20.0].active = YES;
    [self.redField.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor constant:-15].active = YES;
    [self.redField.heightAnchor constraintEqualToConstant:30.0].active = YES;
    [self.redField.widthAnchor constraintEqualToConstant:60.0].active = YES;
    
    [self.redSlider.topAnchor constraintEqualToAnchor:self.parentView.topAnchor constant:20].active = YES;
    [self.redSlider.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor constant:15].active = YES;
    [self.redSlider.rightAnchor constraintEqualToAnchor:self.redField.leftAnchor constant:-15].active = YES;
    
   
    [self.greenField.topAnchor constraintEqualToAnchor:self.redField.bottomAnchor constant:10.0].active = YES;
    [self.greenField.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor constant:-15].active = YES;
    [self.greenField.heightAnchor constraintEqualToConstant:30.0].active = YES;
    [self.greenField.widthAnchor constraintEqualToConstant:60.0].active = YES;
    
    [self.greenSlider.topAnchor constraintEqualToAnchor:self.redSlider.bottomAnchor constant:10].active = YES;
    [self.greenSlider.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor constant:15].active = YES;
    [self.greenSlider.rightAnchor constraintEqualToAnchor:self.greenField.leftAnchor constant:-15].active = YES;

    
    [self.blueField.topAnchor constraintEqualToAnchor:self.greenField.bottomAnchor constant:10.0].active = YES;
    [self.blueField.rightAnchor constraintEqualToAnchor:self.parentView.rightAnchor constant:-15].active = YES;
    [self.blueField.heightAnchor constraintEqualToConstant:30.0].active = YES;
    [self.blueField.widthAnchor constraintEqualToConstant:60.0].active = YES;
    
    [self.blueSlider.topAnchor constraintEqualToAnchor:self.greenSlider.bottomAnchor constant:10].active = YES;
    [self.blueSlider.leftAnchor constraintEqualToAnchor:self.parentView.leftAnchor constant:15].active = YES;
    [self.blueSlider.rightAnchor constraintEqualToAnchor:self.blueField.leftAnchor constant:-15].active = YES;
    
    [self.parentView.topAnchor constraintEqualToAnchor:self.topLayoutGuide.bottomAnchor constant:15].active = YES;
    [self.parentView.bottomAnchor constraintEqualToAnchor:self.blueField.bottomAnchor constant:20].active = YES;
    [self.parentView.leftAnchor constraintEqualToAnchor:self.colorSample.rightAnchor constant:0].active = YES;
    [self.parentView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    
    UIView *colorArea = [[UIView alloc] initWithFrame:CGRectZero];
    colorArea.translatesAutoresizingMaskIntoConstraints = NO;
    colorArea.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:colorArea];
    
    UIView *colorContainer = [[UIView alloc] initWithFrame:CGRectZero];
    colorContainer.translatesAutoresizingMaskIntoConstraints = NO;
    colorContainer.backgroundColor = [UIColor whiteColor];
    [colorArea addSubview:colorContainer];
    
    [colorArea.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [colorArea.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [colorArea.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    [colorArea.topAnchor constraintEqualToAnchor:self.parentView.bottomAnchor constant:20].active = YES;
    
    NSArray *colorList = [UIColor getSAColors];
    NSInteger numberOfRows = 4;
    NSInteger numberOfCols = colorList.count / numberOfRows;
    
    NSInteger counter = 0;
    NSMutableArray *mutableButtonList = [NSMutableArray array];
    for (NSInteger i = 0; i < numberOfRows; i++) {
        NSMutableArray *insideArray = [NSMutableArray array];
        for (NSInteger j = 0; j < numberOfCols; j++) {
        
            UIColor *color = [colorList objectAtIndex:counter];
            SARoundButton *colorBtn = [[SARoundButton alloc] initWithFrame:CGRectZero];
            [colorBtn addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            colorBtn.layer.cornerRadius = colorBtn.frame.size.width/2;
            colorBtn.layer.borderColor = [UIColor blackColor].CGColor;
            colorBtn.layer.borderWidth = 0.5;
            colorBtn.backgroundColor = color;
            colorBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [colorContainer addSubview:colorBtn];
            
            [insideArray addObject:colorBtn];
            if (counter < colorList.count - 1)
                counter++;
            else
                j = numberOfCols;
        }
        [mutableButtonList addObject:insideArray.copy];
    }
    
    float btnSize = 60;
    
    for (NSInteger j = 0; j < mutableButtonList.count; j++) {
        NSArray *innerArray = [mutableButtonList objectAtIndex:j];
        for (NSInteger i = 0; i < innerArray.count; i++) {
            SARoundButton *btn = [innerArray objectAtIndex:i];
            
            [btn.widthAnchor constraintEqualToConstant:btnSize].active = YES;
            [btn.heightAnchor constraintEqualToConstant:btnSize].active = YES;
            
            if (i == 0) {
                [btn.leftAnchor constraintEqualToAnchor:colorContainer.leftAnchor constant:5].active = YES;
            } else {
                UIButton *btnToLeft = [innerArray objectAtIndex:i - 1];
                [btn.leftAnchor constraintEqualToAnchor:btnToLeft.rightAnchor constant:5].active = YES;
            }
    
            if (j == 0) {
                [btn.topAnchor constraintEqualToAnchor:colorContainer.topAnchor constant:5].active = YES;
            } else {
                UIButton *btnAbove = [[mutableButtonList objectAtIndex:j - 1] objectAtIndex:i];
                [btn.topAnchor constraintEqualToAnchor:btnAbove.bottomAnchor constant:5].active = YES;
            }
            
            if (j == mutableButtonList.count - 1 && i == innerArray.count - 1) {
                [colorContainer.bottomAnchor constraintEqualToAnchor:btn.bottomAnchor constant:5].active = YES;
                [colorContainer.rightAnchor constraintEqualToAnchor:btn.rightAnchor constant:5].active = YES;
            }
            
        }
    }
    
    [colorContainer.centerXAnchor constraintEqualToAnchor:colorArea.centerXAnchor].active = YES;
    [colorContainer.centerYAnchor constraintEqualToAnchor:colorArea.centerYAnchor].active = YES;
    
}

#pragma mark - Slider Values Changed

- (void)redSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.redField.text = [NSString stringWithFormat:@"%ld", (long)slider.value];
    self.r = (NSInteger)slider.value;
    [self updateColor];
}

- (void)greenSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.greenField.text = [NSString stringWithFormat:@"%ld", (long)slider.value];
    self.g = (NSInteger)slider.value;
    [self updateColor];
}

- (void)blueSliderChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    self.blueField.text = [NSString stringWithFormat:@"%ld", (long)slider.value];
    self.b = (NSInteger)slider.value;
    [self updateColor];
}

#pragma mark - Text Field Values Changed

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 3) ? NO : YES;
}

- (void)redFieldValueChanged:(id)sender {
    UITextField *field = (UITextField *)sender;
    float num = field.text.floatValue;
    if (num <= 255) {
        self.r = num;
        [self.redSlider setValue:self.r animated:YES];
        [self updateColor];
    }
}

- (void)greenFieldValueChanged:(id)sender {
    UITextField *field = (UITextField *)sender;
    float num = field.text.floatValue;
    if (num <= 255) {
        self.g = num;
        [self.greenSlider setValue:self.g animated:YES];
        [self updateColor];
    }
}

- (void)blueFieldValueChanged:(id)sender {
    UITextField *field = (UITextField *)sender;
    float num = field.text.floatValue;
    if (num <= 255) {
        self.b = num;
        [self.blueSlider setValue:self.b animated:YES];
        [self updateColor];
    }
}

#pragma mark - Buttons

- (void)selectButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    UIColor *background = [btn backgroundColor];
    const CGFloat *components = CGColorGetComponents(background.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    self.r = (NSInteger)(r * 255.0);
    self.g = (NSInteger)(g * 255.0);
    self.b = (NSInteger)(b * 255.0);
    
    self.redField.text = [NSString stringWithFormat:@"%ld", (long)self.r];
    self.greenField.text = [NSString stringWithFormat:@"%ld", (long)self.g];
    self.blueField.text = [NSString stringWithFormat:@"%ld", (long)self.b];
    [self.redSlider setValue:self.r animated:YES];
    [self.greenSlider setValue:self.g animated:YES];
    [self.blueSlider setValue:self.b animated:YES];
    [self updateColor];
}

- (void)updateColor {
    UIColor *themeColor = [UIColor colorWithRed:self.r/255.0 green:self.g/255.0 blue:self.b/255.0 alpha:1.0];
    self.colorSample.backgroundColor = themeColor;
    self.navigationController.navigationBar.barTintColor = self.colorSample.backgroundColor;

    
    [[GlobalAsset sharedInstance] setCoreTheme:themeColor];
    [[GlobalAsset sharedInstance] determineCoreFontColorBasedOn:themeColor];
    [[GlobalAsset sharedInstance] determineUIComponentColorBasedOnTheme:[[GlobalAsset sharedInstance] coreTheme] fontColor:[[GlobalAsset sharedInstance] coreFontColor]];

    self.navigationController.navigationBar.tintColor = [[GlobalAsset sharedInstance] coreFontColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [[GlobalAsset sharedInstance] coreFontColor],
                                                                    NSFontAttributeName: [UIFont fontWithName:DESIGN_FONTS_MAINFONT size:20.0f]};
    
    if ([[[GlobalAsset sharedInstance] coreFontColor] isEqual:[UIColor blackColor]]) {
        self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    } else {
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }

}

- (void)tapToCloseKeyboard:(UITapGestureRecognizer *)gesture {
    [self.view endEditing:YES]; //end editing to close keyboard
}

@end
