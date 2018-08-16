//
//  AboutViewController.m
//  CapCalc
//
//  Created by Mark on 6/1/15.
//  Copyright (c) 2015 mark. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutCell.h"

@interface AboutViewController ()
@property (nonatomic, strong) NSArray *sectionHeaders;
@property (nonatomic, strong) NSArray *ourAppIcons;
@property (nonatomic, strong) NSArray *ourAppNames;
@property (nonatomic, strong) NSArray *ourNames;
@property (nonatomic, strong) NSArray *ourRoles;
@property (nonatomic, strong) NSArray *ourTwitterHandles;

@property (nonatomic, strong) NSArray *additionalNames;
@property (nonatomic, strong) NSArray *additionalRoles;
@property (nonatomic, strong) NSArray *additionalTwitterHandles;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set up VC settings
    self.title = @"About";
    
    //UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    //self.tableView = tableView;
    
    //Populate arrays with our info
    
    self.sectionHeaders = @[@"Our Apps", @"Developers", @"Additional Help"];
    self.ourAppIcons = @[@"MC_Icon", @"CC_Icon"];
    self.ourAppNames = @[@"MathCruncher", @"CapCalc"];
    
    self.ourNames = @[@"Mark Disler", @"Matt Panzer"];
    self.ourRoles = @[@"Programmer", @"Designer"];
    self.ourTwitterHandles = @[@"MarkDisler", @"MattPanzer100"];
    
    self.additionalNames = @[@"Chenab", @"Lenny", @"Nate"];
    self.additionalRoles = @[@"Design", @"Design & Debugging", @"Design"];
    self.additionalTwitterHandles = @[@"ChenabKhakh", @"LennyKhazan", @"ProcrastiNate33"];
    
    //Define the backstory
    NSString *backstoryText = @"\nThanks for checking out our app! We hope this made collecting and sorting through team data much easier. If you have any comments or questions, you can contact us by tapping our names above. Enjoy!";
    
    //Format the backstory appropriately
    NSMutableParagraphStyle *padded =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    padded.alignment = NSTextAlignmentCenter;
    padded.firstLineHeadIndent = 5.0f;
    padded.headIndent = 8.0f;
    padded.tailIndent = -8.0f;
    
    NSAttributedString *paddedText = [[NSAttributedString alloc] initWithString:backstoryText attributes:@{ NSParagraphStyleAttributeName : padded}];

    UILabel *backStory = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, self.view.frame.size.width, 0)];
    [backStory setNumberOfLines:0];
    [backStory setFont:[UIFont fontWithName:DESIGN_FONTS_MAINFONT size:16.0f]];
    [backStory setTextAlignment:NSTextAlignmentCenter];
    [backStory setAttributedText:paddedText];
    [backStory sizeToFit];
    
    float x = (self.view.frame.size.width/2) - (backStory.frame.size.width/2);
    float y = 10;
    float w = backStory.frame.size.width;
    float h = backStory.frame.size.height;
    backStory.frame = CGRectMake(x, y, w, h);
    
    //Assign it to the table header
    self.tableView.tableHeaderView = backStory;
    
    [self.tableView registerClass:[AboutCell class] forCellReuseIdentifier:@"aboutCell"];

}

- (UILabel*)createLabel:(NSString*)txt size:(float)s frame:(CGRect)f {
    UILabel *lbl = [[UILabel alloc] initWithFrame:f];
    [lbl setTextAlignment:NSTextAlignmentCenter];
    [lbl setFont:[UIFont fontWithName:DESIGN_FONTS_MAINFONT size:s]];
    [lbl setText:txt];
    return lbl;
}

#pragma mark - Table View Delegate & Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sectionHeaders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return self.ourAppNames.count;
    else if (section == 1)
        return self.ourNames.count;
    else if (section == 2)
        return self.additionalNames.count;
    else
        return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.sectionHeaders objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0)
            [self goToAppStoreForMathCruncher];
        else if (indexPath.row == 1)
            [self goToAppStoreForCapCalc];
    } else if (indexPath.section == 1) {
        [self goToTwitterForHandle:[self.ourTwitterHandles objectAtIndex:indexPath.row]];
    } else if (indexPath.section == 2) {
        [self goToTwitterForHandle:[self.additionalTwitterHandles objectAtIndex:indexPath.row]];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AboutCell *cell;
    if (indexPath.section == 0) {
        cell = [[AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutCell"];
        cell.textLabel.text = [self.ourAppNames objectAtIndex:indexPath.row];
        UIImage *image = [UIImage imageNamed:[self.ourAppIcons objectAtIndex:indexPath.row]];
        cell.imageView.image = image;
        cell.imageView.layer.masksToBounds = YES;
    } else if (indexPath.section == 1) {
        cell = [[AboutCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aboutCell"];
        cell.textLabel.text = [self.ourNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.ourRoles objectAtIndex:indexPath.row];
    } else if (indexPath.section == 2) {
        cell = [[AboutCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"aboutCell"];
        cell.textLabel.text = [self.additionalNames objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.additionalRoles objectAtIndex:indexPath.row];
    }
    return cell;
}

#pragma mark - Go to App Store

- (void)goToAppStoreForMathCruncher {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/mathcruncher/id954637577?mt=8&uo=4"]];
}

- (void)goToAppStoreForCapCalc {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/capcalc-build-custom-calculator/id997128420?mt=8"]];
}

#pragma mark - Go to Twitter

- (void)goToTwitterForHandle:(NSString *)handle {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.twitter.com/%@", handle]]];
}

@end
