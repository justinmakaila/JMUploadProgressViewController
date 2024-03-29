//
//  JMProgressView.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "PProgressView.h"
#import "PRoundedCornerButton.h"

typedef enum {
    kJMSwipeDirectionUp = 0,
    kJMSwipeDirectionCenter,
    kJMSwipeDirectionLeft,
    kJMSwipeDirectionRight,
    kJMSwipeDirectionDown
} JMSwipeDirection;

/**
 *  Percentage limit to trigger the first action
 */
static CGFloat const kJMStop1 = 0.2;

/**
 *  Percentage limit to trigger the second action
 */
static CGFloat const kJMStop2 = 0.000001;

/**
 *  Maximum bounce amplitude
 */
static CGFloat const kBounceAmplitude = 20.0;

/**
 *  Duration of the first part of the bounce animation
 */
static NSTimeInterval const kBounceDuration1 = 0.2;

/**
 *  Duration of the second part of the bounce animation
 */
static NSTimeInterval const kBounceDuration2 = 0.1;

/**
 *  Lowest duration when swiping the cell to simulate velocity
 */
static NSTimeInterval const kJMDurationLowLimit = 0.25;

/**
 *  Highest duration when swiping the cell to simulate velocity
 */
static NSTimeInterval const kJMDurationHighLimit = 0.1;

typedef enum {
    kActionButtonStyleGo = 700,
    kActionButtonStyleRetry = 800
} JMActionButtonStyleTag;

@interface PProgressView () <UIGestureRecognizerDelegate> {
    JMSwipeDirection direction;
    
    CGFloat currentPercentage;
}

@property (strong, nonatomic) UILabel *statusLabel;

@property (strong, nonatomic) PRoundedCornerButton *cancelButton;
@property (strong, nonatomic) PRoundedCornerButton *actionButton;

@property (strong, nonatomic) UIPanGestureRecognizer *panGesture;

@end

static NSString *const kUploadingMessage = @"Finishing up";
static NSString *const kNoWiFiMessage    = @"Finish up without wifi?";
static NSString *const kPausedMessage    = @"Paused";
static NSString *const kFailedMessage    = @"Can't reach Present";
static NSString *const kCancelledMessage = @"Cancelled";
static NSString *const kFinishedMessage  = @"Finished!";

static NSString *const kRetryButtonText = @"Retry";
static NSString *const kGoButtonText = @"Go";

@implementation PProgressView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit {
    self.clipsToBounds = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    
    self.contentView = [[UIView alloc] init];
    self.contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.contentView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0];
    [self addSubview:self.contentView];
    
    self.cancelButton = [PRoundedCornerButton buttonWithRoundedCorners:(UIRectCornerAllCorners) radius:5.0f backgroundColor:[UIColor colorWithRed:0.905882353 green:0.298039216 blue:0.235294118 alpha:1.0]];
    self.cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    [self.cancelButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.cancelButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(5.6f, 0, 9, 0)];
    [self.cancelButton setTitle:@"x" forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.cancelButton];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
    self.imageView.layer.cornerRadius = 5.0f;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    [self setupProgressView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureReceived:)];
    self.panGesture.delegate = self;
    [self.contentView addGestureRecognizer:self.panGesture];
}

- (void)setupProgressView {
//    self.progressView = [[LDProgressView alloc] init];
//    self.progressView.frame = CGRectMake(71, 23, 239, 25);
//    self.progressView.type = LDProgressSolid;
//    self.progressView.background = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
//    self.progressView.color = [UIColor colorWithRed:0.505882353 green:0.188235294 blue:0.949019608 alpha:1.0];
//    self.progressView.showText = @NO;
//    self.progressView.animate = @YES;
//    self.progressView.showStroke = @NO;
//    self.progressView.flat = @YES;
//    self.progressView.showBackgroundInnerShadow = @NO;
//    self.progressView.borderRadius = @5;
//    self.progressView.clipsToBounds = YES;
//    [self.contentView addSubview:self.progressView];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(81, 23, 239, 25)/*CGRectMake(10, 0, CGRectGetWidth(self.progressView.bounds), CGRectGetHeight(self.progressView.bounds))*/];
    self.statusLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.statusLabel.textColor = [UIColor colorWithRed:0.898039216 green:0.898039216 blue:0.898039216 alpha:1.0];
    //[self.progressView addSubview:self.statusLabel];
    [self.contentView addSubview:self.statusLabel];
    
    self.actionButton = [PRoundedCornerButton buttonWithRoundedCorners:(UIRectCornerAllCorners) radius:5.0f backgroundColor:[UIColor colorWithRed:0.505882353 green:0.188235294 blue:0.949019608 alpha:1.0]];
    self.actionButton.frame = CGRectMake(250, 23, 50, 25);
    self.actionButton.clipsToBounds = YES;
    self.actionButton.titleLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    self.actionButton.hidden = YES;
    [self.actionButton addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.actionButton];
}

- (void)layoutSubviews {
    self.contentView.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), 375, CGRectGetHeight(self.bounds));
    self.cancelButton.frame = CGRectMake(330, 23, 31, 25);
    
    [super layoutSubviews];
}

- (void)setBackgroundImage:(UIImage *)image {
    self.backgroundColor = [UIColor colorWithPatternImage:image];
}

- (void)updateProgressView:(float)progress {
    self.progressView.progress = (progress / 100);
}

- (void)start {
    if (!self.actionButton.isHidden) {
        self.actionButton.hidden = YES;
    }
    
    self.statusLabel.text = kUploadingMessage.uppercaseString;
}

- (void)cancel {
    if (!self.actionButton.isHidden) {
        self.actionButton.hidden = YES;
    }
    
    self.statusLabel.text = kCancelledMessage.uppercaseString;
}

- (void)pause {
    if (!self.actionButton.isHidden) {
        self.actionButton.hidden = YES;
    }
    
    self.statusLabel.text = kPausedMessage.uppercaseString;
}

- (void)failed {
    self.actionButton.tag = kActionButtonStyleRetry;
    [self.actionButton setTitle:kRetryButtonText.uppercaseString forState:UIControlStateNormal];
    if (self.actionButton.isHidden) {
        self.actionButton.hidden = NO;
    }
    
    self.statusLabel.text = kFailedMessage.uppercaseString;
}

- (void)requestUploadPermission {
    self.actionButton.tag = kActionButtonStyleGo;
    [self.actionButton setTitle:kGoButtonText.uppercaseString forState:UIControlStateNormal];
    if (self.actionButton.isHidden) {
        self.actionButton.hidden = NO;
    }
    
    self.statusLabel.text = kNoWiFiMessage.uppercaseString;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer == self.panGesture) {
        CGPoint translation = [self.panGesture translationInView:self.contentView];
        return fabs(translation.x) > fabs(translation.y);
    }else {
        return YES;
    }
}

- (void)panGestureReceived:(UIPanGestureRecognizer*)gesture {
    UIGestureRecognizerState state = gesture.state;
    CGPoint translation = [gesture translationInView:self.contentView];
    CGPoint velocity = [gesture velocityInView:self.contentView];
    CGFloat percentage = [self percentageWithOffset:CGRectGetMinX(self.contentView.frame) relativeToDimension:CGRectGetWidth(self.bounds)];
    direction = [self directionWithPercentage:percentage];
    
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged) {
        self.dragging = YES;
        
        if ((direction == kJMSwipeDirectionCenter || direction == kJMSwipeDirectionRight) && (velocity.x > 0 && self.contentView.center.x >= self.center.x)) {
            return;
        }
        
        CGPoint newContentViewCenter = { self.contentView.center.x + translation.x, self.contentView.center.y };
        self.contentView.center = newContentViewCenter;
        
        [gesture setTranslation:CGPointZero inView:self];
    }else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateEnded) {
        self.dragging = NO;
        
        currentPercentage = percentage;
        
        if (direction == kJMSwipeDirectionLeft && self.contentView.center.x < self.center.x) {
            [self animateToOpen];
        }else {
            [self animateToClose];
        }
    }
}

#pragma mark - IBActions

- (void)actionButtonPressed:(UIButton*)sender {
    switch (sender.tag) {
        case kActionButtonStyleGo:
            [_delegate goButtonPressed];
            break;
        case kActionButtonStyleRetry:
            [_delegate retryButtonPressed];
            break;
        default:
            break;
    }
}

- (void)cancelButtonPressed:(UIButton*)sender {
    [_delegate cancelButtonPressed];
}

#pragma mark - Utilities

- (CGFloat)percentageWithOffset:(CGFloat)offset relativeToDimension:(CGFloat)dimension {
    CGFloat percentage = offset / dimension;
    
    if (percentage < -1.0) {
        percentage = -1.0;
    }else if (percentage > 1.0) {
        percentage = 1.0;
    }
    
    return percentage;
}

- (NSTimeInterval)animationDurationWithVelocity:(CGPoint)velocity {
    CGFloat height = CGRectGetHeight(self.bounds);
    NSTimeInterval animationDurationDiff = kJMDurationHighLimit - kJMDurationLowLimit;
    CGFloat verticalVelocity = velocity.y;
    
    if (verticalVelocity < -height) {
        verticalVelocity = -height;
    }else if (verticalVelocity > height) {
        verticalVelocity = height;
    }
    
    return (kJMDurationHighLimit + kJMDurationLowLimit) - fabs(((verticalVelocity / height) * animationDurationDiff));
}

- (JMSwipeDirection)directionWithPercentage:(CGFloat)percentage {
    if (percentage < -kJMStop1) {
        return kJMSwipeDirectionLeft;
    }else if (percentage > kJMStop2) {
        return kJMSwipeDirectionRight;
    }else {
        return kJMSwipeDirectionCenter;
    }
}

#pragma mark - Animations

-(void)animateToClose {
    CGFloat bounceDistance = kBounceAmplitude * currentPercentage;
    [UIView animateWithDuration:kBounceDuration1
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CGRect frame = self.contentView.frame;
                         frame.origin.x = -bounceDistance;
                         self.contentView.frame = frame;
                         
                         self.open = NO;
                     }completion:^(BOOL finished) {
                         [UIView animateWithDuration:kBounceDuration2
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              CGRect frame = self.contentView.frame;
                                              frame.origin.x = 0;
                                              self.contentView.frame = frame;
                                          }completion:nil];
                     }];
}

-(void)animateToOpen {
    [UIView animateWithDuration:kBounceDuration1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGPoint contentViewCenter = { self.center.x - 35, self.contentView.center.y };
                         self.contentView.center = contentViewCenter;
                         
                         self.open = YES;
                     }completion:nil];
}

@end
