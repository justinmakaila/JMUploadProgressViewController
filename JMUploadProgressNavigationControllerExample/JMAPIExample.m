//
//  JMAPIExample.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/29/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMAPIExample.h"

@interface JMAPIExample () {
    NSTimer *timer;
}

@end

static const float kTimerUpdateDelay = 0.5f;
static const int kProgressIncreaseAmount = 10;

@implementation JMAPIExample

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    static JMAPIExample *sharedClient = nil;
    
    dispatch_once(&onceToken, ^{
        sharedClient = [[JMAPIExample alloc] init];
    });
    
    return sharedClient;
}

#pragma mark - Operations

- (void)startOperation {
    [self resumeTimer];
    self.uploadProgress = @0;
    self.suspended = NO;
    self.running = YES;
}

- (void)suspendOperation {
    [timer invalidate];
    self.suspended = YES;
    self.running = NO;
}

- (void)resumeOperation {
    [self resumeTimer];
    self.suspended = NO;
    self.running = YES;
}

- (void)cancelOperation {
    if (timer.isValid) {
        [timer invalidate];
    }
    
    timer = nil;
    self.running = NO;
    
    self.uploadProgress = @0;
}

- (void)updateProgress:(NSTimer*)sender {
    int progress = [self.uploadProgress intValue] + kProgressIncreaseAmount;
    self.uploadProgress = [NSNumber numberWithInt:progress];
    
    if ([self.uploadProgress isEqual:@100]) {
        [timer invalidate];
        timer = nil;
    }
}

- (void)resumeTimer {
    if (timer.isValid) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:kTimerUpdateDelay
                                             target:self
                                           selector:@selector(updateProgress:)
                                           userInfo:nil
                                            repeats:YES];
}

@end
