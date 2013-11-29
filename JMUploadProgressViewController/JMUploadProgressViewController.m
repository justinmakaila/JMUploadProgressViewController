//
//  JMUploadProgressViewController.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMUploadProgressViewController.h"
#import "JMProgressView.h"

@interface JMUploadProgressViewController ()

@property (strong, nonatomic) JMProgressView *progressView;

@end

@implementation JMUploadProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.progressView = [[JMProgressView alloc] initWithFrame:CGRectMake(0, 64, 320, 0)];
    self.progressView.delegate = self;
    self.progressView.dynamic = NO;
}

- (void)uploadStarted {
    [self.progressView start];
    [self showProgressView];
}

- (void)uploadCancelled {
    [self.progressView cancel];
    [self hideProgressView];
}

- (void)uploadResumed {
    [self.progressView start];
}

- (void)uploadPaused {
    [self.progressView pause];
}

- (void)uploadFailed {
    [self.progressView failed];
}

- (void)setUploadProgress:(float)progress {
    [self.progressView updateProgressView:progress];
}

#pragma mark - JMProgressViewDelegate

- (void)uploadFinished {
    [self hideProgressView];
}

- (void)cancelButtonPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:JMCancelUploadNotification object:nil];
}

- (void)retryButtonPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:JMRetryUploadNotification object:nil];
}

#pragma mark - Animation Methods

- (void)showProgressView {
    if (!self.progressView.superview) {
        [self.view insertSubview:self.progressView belowSubview:self.navigationBar];
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.progressView.frame = CGRectMake(0, 64, 320, 44);
                         _showingUploadProgressView = YES;
                     }completion:^(BOOL finished) {
                         self.progressView.dynamic = YES;
                     }];
}

- (void)hideProgressView {
    self.progressView.dynamic = NO;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.progressView.frame = CGRectMake(0, 64, 320, 0);
                     }completion:^(BOOL finished) {
                         [self setUploadProgress:0.0f];
                         _showingUploadProgressView = NO;
                         [self.progressView removeFromSuperview];
                     }];
}

@end

NSString *const JMCancelUploadNotification = @"JMCancelUploadNotification";
NSString *const JMRetryUploadNotification = @"JMRetryUploadNotification";
