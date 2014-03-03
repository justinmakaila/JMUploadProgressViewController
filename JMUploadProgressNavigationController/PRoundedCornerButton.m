//
//  PRoundedCornerButton.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 1/14/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import "PRoundedCornerButton.h"

@implementation PRoundedCornerButton

+ (instancetype)buttonWithRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    return [self buttonWithRoundedCorners:corners radius:radius backgroundColor:[UIColor clearColor]];
}

+ (instancetype)buttonWithRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor {
    PRoundedCornerButton *button = [PRoundedCornerButton buttonWithType:UIButtonTypeCustom];
    button.cornersToRound = corners;
    button.cornerRadius = radius;
    button.fillColor = backgroundColor;
    
    [button setNeedsDisplay];
    
    return button;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPathRef clippingPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.cornersToRound cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)].CGPath;
    CGContextAddPath(context, clippingPath);
    
    CGContextClip(context);
    
    CGColorRef fillColor = self.fillColor.CGColor;
    CGContextSetFillColorWithColor(context, fillColor);
    CGContextAddRect(context, self.bounds);
    CGContextDrawPath(context, kCGPathEOFill);
}


@end
