//
//  JMUploadProgressViewController.h
//  JMUploadProgressNavigationController
//
//  Created by Justin Makaila on 11/28/13.
//  Copyright (c) 2013 Present, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PProgressView.h"

@protocol JMUploadProgressViewControllerDelegate <PProgressViewDelegate, UINavigationControllerDelegate>
@end

@interface JMUploadProgressViewController : UINavigationController <PProgressViewDelegate, JMUploadProgressViewControllerDelegate>

@property (weak, nonatomic) id <JMUploadProgressViewControllerDelegate> delegate;

@property (nonatomic) BOOL positionBottom;

/**
 *  Indicates whether or not the progress view is displayed
 */
@property (readonly, nonatomic, getter = isShowingUploadProgressView) BOOL showingUploadProgressView;
@property (readonly, nonatomic, getter = isRunning) BOOL running;
@property (readonly, nonatomic, getter = isPaused) BOOL paused;
@property (readonly, nonatomic, getter = isCancelled) BOOL cancelled;
@property (readonly, nonatomic, getter = didFail) BOOL failed;

/**
 *  Called when the upload is started, shows the progress view
 */
- (void)uploadStarted;

/**
 *  Called when an upload is paused
 */
- (void)uploadPaused;

/**
 *  Called when an upload is resumed
 */
- (void)uploadResumed;

/**
 *  Called when an upload is cancelled
 */
- (void)uploadCancelled;

/**
 *  Called when an upload fails
 */
- (void)uploadFailed;

/**
 *  Called when an upload is finished, hides the progress view
 */
- (void)uploadFinished;

/**
 *  Shows the progress view in a state requesting user permission
 */
- (void)requestUploadPermission;

/**
 *  Used to update the progress view
 *
 *  @param progress A number between 0 and 100 representing the progress completed
 */
- (void)setUploadProgress:(float)progress;

/**
 *  Set the progress view image to the image
 *
 *  @param image The image to load
 */
- (void)setProgressViewImage:(UIImage*)image;

/**
 *  Set the progress view image to the image at url
 *
 *  @param url The URL where the image is located
 */
- (void)setProgressViewImageWithURL:(NSURL*)url;

/**
 *  Shows the progress view
 */
- (void)showProgressView;

/**
 *  Hides the progress view
 */
- (void)hideProgressView;

@end
