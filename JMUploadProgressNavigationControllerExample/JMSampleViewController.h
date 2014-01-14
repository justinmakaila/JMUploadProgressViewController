//
//  PDetailViewController.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JMSampleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *pauseButton;

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *failButton;

@property (weak, nonatomic) IBOutlet UIButton *requestUserPermissionButton;

- (IBAction)startButtonPressed:(UIButton*)sender;
- (IBAction)pauseButtonPressed:(UIButton*)sender;
- (IBAction)cancelButtonPressed:(UIButton*)sender;
- (IBAction)failButtonPressed:(UIButton*)sender;
- (IBAction)requestUserPermissionButtonPressed:(UIButton*)sender;

@end
