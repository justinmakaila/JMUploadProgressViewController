//
//  PRoundedCornerButton.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 1/14/14.
//  Copyright (c) 2014 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PRoundedCornerButton : UIButton

@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) UIRectCorner cornersToRound;
@property (strong, nonatomic) UIColor *fillColor;

+ (instancetype)buttonWithRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
+ (instancetype)buttonWithRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius backgroundColor:(UIColor *)backgroundColor;

@end
