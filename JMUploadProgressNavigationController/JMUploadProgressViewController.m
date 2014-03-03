//
//  JMUploadProgressViewController.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMUploadProgressViewController.h"
#import "PProgressView.h"

static CGFloat kProgressViewHeight = 70.0f;

@interface JMUploadProgressViewController ()

@property (strong, nonatomic) PProgressView *progressView;

@end

@implementation JMUploadProgressViewController

- (void)viewDidLoad {
    _showingUploadProgressView = NO;
    self.delegate = self;
    
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews {
    if (!self.progressView) {
        if (!self.positionBottom) {
            self.progressView = [[PProgressView alloc] initWithFrame:CGRectMake(0, kProgressViewHeight, 320, 0)];
        }else {
            self.progressView = [[PProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), 320, 0)];
        }
        
        self.progressView.delegate = self;
    }
    
    [super viewDidLayoutSubviews];
}

- (void)uploadStarted {
    [self.progressView start];
    
    if (!self.isShowingUploadProgressView) {
        [self showProgressView];
    }
    
    _paused = NO;
    _running = YES;
}

- (void)uploadCancelled {
    [self.progressView cancel];
    
    _cancelled = YES;
    _running = NO;
}

- (void)uploadResumed {
    [self.progressView start];
    
    _running = YES;
    _paused = NO;
}

- (void)uploadPaused {
    [self.progressView pause];
    
    _paused = YES;
    _running = NO;
}

- (void)uploadFailed {
    [self.progressView failed];
    
    _failed = YES;
    _running = NO;
}

- (void)requestUploadPermission {
    if (!self.isShowingUploadProgressView) {
        [self showProgressView];
    }
    
    [self.progressView requestUploadPermission];
}

- (void)setUploadProgress:(float)progress {
    [self.progressView updateProgressView:progress];
}

- (void)setProgressViewImage:(UIImage *)image {
    self.progressView.imageView.image = image;
}

- (void)setProgressViewImageWithURL:(NSURL*)url {
    [self.progressView.imageView setImageWithURL:url placeholderImage:nil];
}

- (void)uploadFinished {
    [self hideProgressView];
    
    _running = NO;
    _paused = NO;
}

#pragma mark - PProgressViewDelegate

- (void)cancelButtonPressed {
    [self.delegate cancelButtonPressed];
}

- (void)retryButtonPressed {
    [self.delegate cancelButtonPressed];
}

- (void)goButtonPressed {
    [self.delegate goButtonPressed];
}

#pragma mark - Animation Methods

- (void)showProgressView {
    if (!self.progressView.superview) {
        [self.view insertSubview:self.progressView belowSubview:self.navigationBar];
    }
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (self.positionBottom) {
                             self.progressView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - kProgressViewHeight, 320, kProgressViewHeight);
                         }else {
                             self.progressView.frame = CGRectMake(0, kProgressViewHeight, 320, 60);
                         }
                         
                         _showingUploadProgressView = YES;
                     }completion:nil];
}

- (void)hideProgressView {
    [UIView animateWithDuration:0.5
                     animations:^{
                         if (self.positionBottom) {
                             self.progressView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds), 320, kProgressViewHeight);
                         }else {
                             self.progressView.frame = CGRectMake(0, kProgressViewHeight, 320, 0);
                         }
                     }completion:^(BOOL finished) {
                         [self setUploadProgress:0.0f];
                         _showingUploadProgressView = NO;
                         if (self.progressView.isOpen) {
                             [self.progressView animateToClose];
                         }
                         [self.progressView removeFromSuperview];
                     }];
}

@end
