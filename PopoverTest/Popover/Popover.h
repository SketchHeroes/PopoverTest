//
//  Popover.h
//  PopoverTest
//
//  Created by Yaniv Marshaly on 2/13/13.
//  Copyright (c) 2013 SketchHeroes LTD. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Popover : UIControl

@property (nonatomic, strong) UILabel *textLabel;

- (void)presentPointingAtView:(UIView *)targetView
                       inView:(UIView *)containerView
                     animated:(BOOL)animated;

@end
