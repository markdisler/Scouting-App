//
//  FilterVC.m
//  ScoutApp2
//
//  Created by Mark on 2/23/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import "FilterVC.h"

@interface FilterVC ()
@property (strong, nonatomic) UIView *dropDownView;
@end

@implementation FilterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.dropDownView = [[UIView alloc] initWithFrame:CGRectZero];
    self.dropDownView.translatesAutoresizingMaskIntoConstraints = NO;
    self.dropDownView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.dropDownView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    }];
    
    //All Teams
    UIView *leftButton = [self createButtonWithTitle:@"All" imageName:@"All" index:0];
    UIView *rightButton = [self createButtonWithTitle:@"Favorites" imageName:@"Unfavorite" index:1];
    [self.dropDownView addSubview:leftButton];
    [self.dropDownView addSubview:rightButton];
    
    [self.dropDownView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.dropDownView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor].active = YES;
    [self.dropDownView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor].active = YES;
    
    NSLayoutConstraint *hC = [self.dropDownView.bottomAnchor constraintEqualToAnchor:rightButton.bottomAnchor];
    [self.dropDownView addConstraint:hC];
    
    [self.view layoutIfNeeded];
    
    [leftButton.widthAnchor constraintEqualToAnchor:self.dropDownView.widthAnchor multiplier:0.5].active = YES;
    [leftButton.leftAnchor constraintEqualToAnchor:self.dropDownView.leftAnchor].active = YES;
    [leftButton.topAnchor constraintEqualToAnchor:self.dropDownView.topAnchor].active = YES;
    
    [rightButton.widthAnchor constraintEqualToAnchor:self.dropDownView.widthAnchor multiplier:0.5].active = YES;
    [rightButton.rightAnchor constraintEqualToAnchor:self.dropDownView.rightAnchor].active = YES;
    [rightButton.topAnchor constraintEqualToAnchor:self.dropDownView.topAnchor].active = YES;
    
   
    self.dropDownView.clipsToBounds = NO;
    
    [self doAnimation:hC];
}

- (void)doAnimation:(NSLayoutConstraint *)hC {
    [UIView animateWithDuration:5.0 animations:^{
        self.dropDownView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.dropDownView.layer.shadowOffset = CGSizeMake(0, 3);
        self.dropDownView.layer.shadowOpacity = .4;
    } completion:^(BOOL finished) {
        
    }];
}

- (UIView *)createButtonWithTitle:(NSString *)title imageName:(NSString *)imgName index:(NSInteger)index {
    //Create parent view
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Create components on screen and set properties
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectZero];
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imgName]];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    [btn setTag:index];
    [btn addTarget:self action:@selector(filterSelect:) forControlEvents:UIControlEventTouchDown];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setText:title];
    [lbl setFont:[UIFont fontWithName:DESIGN_FONTS_MAINFONT_MEDIUM size:20.0]];
    [lbl sizeToFit];
    
    //Disable the autoresizing mask to constraints
    view.translatesAutoresizingMaskIntoConstraints = NO;
    lbl.translatesAutoresizingMaskIntoConstraints = NO;
    img.translatesAutoresizingMaskIntoConstraints = NO;
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    
    //Add to view
    [view addSubview:lbl];
    [view addSubview:img];
    [view addSubview:btn];
    
    //Set autolayout constraints
    [img.widthAnchor constraintEqualToConstant:36].active = YES;
    [img.heightAnchor constraintEqualToConstant:36].active = YES;
    [img.centerXAnchor constraintEqualToAnchor:view.centerXAnchor].active = YES;
    [img.topAnchor constraintEqualToAnchor:view.topAnchor constant:8].active = YES;
    
    [lbl.widthAnchor constraintEqualToConstant:lbl.frame.size.width].active = YES;
    [lbl.heightAnchor constraintEqualToConstant:lbl.frame.size.height].active = YES;
    [lbl.centerXAnchor constraintEqualToAnchor:view.centerXAnchor].active = YES;
    [lbl.topAnchor constraintEqualToAnchor:img.bottomAnchor constant:0].active = YES;
    
    [btn.topAnchor constraintEqualToAnchor:view.topAnchor constant:8].active = YES;
    [btn.leftAnchor constraintEqualToAnchor:view.leftAnchor constant:8].active = YES;
    [btn.rightAnchor constraintEqualToAnchor:view.rightAnchor constant:-8].active = YES;
    [btn.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:-8].active = YES;
    
    if ([title isEqualToString:self.currentFilterTag]) {
        [btn setBackgroundColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.1]];
        btn.layer.shadowColor = [UIColor blackColor].CGColor;
        btn.layer.shadowOffset = CGSizeMake(0, 3);
        btn.layer.shadowOpacity = .4;
    }
    [view.bottomAnchor constraintEqualToAnchor:lbl.bottomAnchor constant:10].active = YES;
    return view;
}

- (void)filterSelect:(UIButton *)sender {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.dropDownView.alpha = 0.0;
    } completion:^(BOOL finished) {
        NSInteger tag = sender.tag;
        if (tag == 0) {
            [self.delegate dialogClosedWithSelection:@"All"];
        } else {
            [self.delegate dialogClosedWithSelection:@"Favorites"];
        }
    }];

}

- (void)close {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.dropDownView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.delegate dialogClosed];
    }];
}

- (void)closeByTrigger {
    [UIView animateWithDuration:0.3 animations:^{
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.dropDownView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.delegate dialogClosedByTrigger];
    }];
}

@end
