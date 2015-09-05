//
//  PaddedLabel.m
//  Simple Calc
//
//  Created by Liu Teng Hou on 9/4/15.
//  Copyright (c) 2015 NoLabel. All rights reserved.
//

#import "PaddedLabel.h"

@implementation PaddedLabel

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 5.0f, 0, 5.0f};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
