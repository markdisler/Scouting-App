//
//  FilterVC.h
//  ScoutApp2
//
//  Created by Mark on 2/23/16.
//  Copyright © 2016 mark. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DropDownDelegate
- (void)dialogClosedWithSelection:(NSString *)filterTag;
- (void)dialogClosed;
- (void)dialogClosedByTrigger;
@end

@interface FilterVC : UIViewController

@property (nonatomic, weak) id<DropDownDelegate> delegate;
@property (nonatomic, strong) NSString *currentFilterTag;

- (void)close;
- (void)closeByTrigger;

@end
