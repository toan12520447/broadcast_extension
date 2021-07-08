//
//  ViewController.m
//  Screen-Share
//
//  Created by Toan Tran on 7/7/21.
//

#import "ViewController.h"
#import <ReplayKit/ReplayKit.h>
#import <ReplayKit/RPBroadcast.h>
#import <ReplayKit/RPPreviewViewController.h>
static NSString *kBroadcastExtensionSetupUiBundleId = @"com.sfvn.sample.Screen-Share.ScreenShareSetupUI";
static NSString *kBroadcastExtensionBundleId = @"com.sfvn.sample.Screen-Share.ScreenShare";
static NSString *kStartBroadcastButtonTitle = @"Start Broadcast";
static NSString *kInProgressBroadcastButtonTitle = @"Broadcasting";
static NSString *kStopBroadcastButtonTitle = @"Stop Broadcast";
static NSString *kStartConferenceButtonTitle = @"Start Conference";
static NSString *kStopConferenceButtonTitle = @"Stop Conference";
static NSString *kRecordingAvailableInfo = @"Ready to share the screen in a Broadcast (extension), or Conference (in-app).";
static NSString *kRecordingNotAvailableInfo = @"ReplayKit is not available at the moment. Another app might be recording, or AirPlay may be in use.";
@interface ViewController ()<RPBroadcastControllerDelegate, RPBroadcastActivityViewControllerDelegate>

@end

@implementation ViewController{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupPickerView];
    [self registerNotifications];
}
- (void)setupPickerView{
    RPSystemBroadcastPickerView *pickerView = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
    pickerView.translatesAutoresizingMaskIntoConstraints = false;
    pickerView.preferredExtension = kBroadcastExtensionBundleId;
    [self.view addSubview:pickerView];
    self.broadcastPickerView = pickerView;
    self.broadcastButton.enabled = false;
    self.broadcastButton.titleEdgeInsets = UIEdgeInsetsMake(45, 0, 0, 0);
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:pickerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_broadcastButton attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:centerX];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:pickerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_broadcastButton attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:centerY];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:pickerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_broadcastButton attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    [self.view addConstraint:width];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:pickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_broadcastButton attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.view addConstraint:height];
}

- (IBAction)broadcastButtonTapped:(id)sender{
    if (self.broadcastController) {
        [self.broadcastController finishBroadcastWithHandler:^(NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.spinner stopAnimating];
                [self.broadcastButton setTitle:kStartBroadcastButtonTitle forState:UIControlStateNormal];
                self.broadcastController = nil;
                
            });
        }];
    }else{
        [RPBroadcastActivityViewController loadBroadcastActivityViewControllerWithPreferredExtension:kBroadcastExtensionSetupUiBundleId handler:^(RPBroadcastActivityViewController * _Nullable broadcastActivityViewController, NSError * _Nullable error) {
            if (broadcastActivityViewController) {
                broadcastActivityViewController.delegate = self;
                broadcastActivityViewController.modalPresentationStyle = UIModalPresentationPopover;
                [self presentViewController:broadcastActivityViewController animated:true completion:nil];
            }
        }];
    }
}
- (void)registerNotifications{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(captureDidChange) name:UIScreenCapturedDidChangeNotification object:nil];
}
- (void)captureDidChange{
    if (self.broadcastPickerView) {
        bool isCaptured = UIScreen.mainScreen.captured;
        NSString *title = isCaptured ? kInProgressBroadcastButtonTitle : kStartBroadcastButtonTitle;
        [self.broadcastButton setTitle:title forState:UIControlStateNormal];
        isCaptured ? [self.spinner startAnimating] : [self.spinner stopAnimating];
    }
}
//Thieu add NotificationCenter.default.addObserver(forName: UIScreen.capturedDidChangeNotification, object: UIScreen.main, queue: OperationQueue.main) { (notification) in
//    if self.broadcastPickerView != nil && self.screenTrack == nil {
//        let isCaptured = UIScreen.main.isCaptured
//        let title = isCaptured ? ViewController.kInProgressBroadcastButtonTitle : ViewController.kStartBroadcastButtonTitle
//        self.broadcastButton.setTitle(title, for: .normal)
//        self.conferenceButton?.isEnabled = !isCaptured
//        isCaptured ? self.spinner.startAnimating() : self.spinner.stopAnimating()
//    }
//}
- (void)startBroadcast{
    [self.broadcastController startBroadcastWithHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Broadcast controller failed to start with error:%@", error);
        }else{
            NSLog(@"Broadcast controller started.");
            [self.spinner startAnimating];
            [self.broadcastButton setTitle:kStopBroadcastButtonTitle forState:UIControlStateNormal];
        }
    }];
}

#pragma mark - RPBroadcastControllerDelegate.
- (void)broadcastController:(RPBroadcastController *)broadcastController didFinishWithError:(NSError *)error{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.broadcastController = nil;
        if (self.broadcastPickerView) {
            UIView *picker = self.broadcastPickerView;
            picker.hidden = false;
            self.broadcastButton.hidden = false;
        }else{
            self.broadcastButton.enabled = true;
        }
        [self.broadcastButton setTitle:kStartBroadcastButtonTitle forState:UIControlStateNormal];
        [self.spinner stopAnimating];
        if (error) {
            NSLog(@"Broadcast did finish with error:%@",error);
            self.infoLabel.text = error.localizedDescription;
        }else{
            NSLog(@"Broadcast did finish.");
        }
    });
}
- (void)broadcastController:(RPBroadcastController *)broadcastController didUpdateServiceInfo:(NSDictionary<NSString *,NSObject<NSCoding> *> *)serviceInfo{
    NSLog(@"Broadcast did update service info: %@", serviceInfo);
}
- (void)broadcastController:(RPBroadcastController *)broadcastController didUpdateBroadcastURL:(NSURL *)broadcastURL{
    NSLog(@"Broadcast did update URL: %@", broadcastURL);
}

#pragma mark - RPBroadcastActivityViewControllerDelegate.
- (void)broadcastActivityViewController:(RPBroadcastActivityViewController *)broadcastActivityViewController didFinishWithBroadcastController:(RPBroadcastController *)broadcastController error:(NSError *)error{
    if (broadcastController) {
        self.broadcastController = broadcastController;
        self.infoLabel.text = @"";
        self.broadcastController.delegate = self;
        [broadcastActivityViewController dismissViewControllerAnimated:true completion:^{
            [self startBroadcast];
        }];
    }
    
}
@end
