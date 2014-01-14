//
//  PDetailViewController.m
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import "JMSampleViewController.h"
#import "JMExampleNavigationController.h"

@interface JMSampleViewController ()

@property (strong, nonatomic) JMExampleNavigationController *navController;

@end

@implementation JMSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"JMUploadProgressViewController";
    self.view.backgroundColor = [UIColor whiteColor];
    self.navController = (JMExampleNavigationController*)self.navigationController;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startUpload {
    [self.navController uploadStarted];
    [self.navController setProgressViewImage:[UIImage imageNamed:@"EQdfPqB.jpg"]];
    [[JMAPIExample sharedClient] startOperation];
}

- (void)cancelUpload {
    [self.navController uploadCancelled];
    [[JMAPIExample sharedClient] cancelOperation];
}

#pragma mark - IBActions

- (IBAction)startButtonPressed:(UIButton *)sender {
    NSLog(@"Start button");
    if (![JMAPIExample sharedClient].isRunning) {
        [[JMAPIExample sharedClient] startOperation];
    }
    
    [self.navController uploadStarted];
    [self.navController setProgressViewImage:[UIImage imageNamed:@"EQdfPqB.jpg"]];
}

- (IBAction)pauseButtonPressed:(UIButton *)sender {
    NSLog(@"Pause button");
    [[JMAPIExample sharedClient] suspendOperation];
    
    [self.navController uploadPaused];
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    NSLog(@"Cancel button");
    [[JMAPIExample sharedClient] cancelOperation];
    
    [self.navController uploadCancelled];
    [self.navController hideProgressView];
}

- (IBAction)failButtonPressed:(UIButton *)sender {
    NSLog(@"Fail button");
    [[JMAPIExample sharedClient] cancelOperation];
    
    [self.navController uploadFailed];
}

- (IBAction)requestUserPermissionButtonPressed:(UIButton *)sender {
    NSLog(@"Request user permission button");
    [self.navController requestUploadPermission];
}

@end
