//
//  ViewController.h
//  Screen-Share
//
//  Created by Toan Tran on 7/7/21.
//

#import <UIKit/UIKit.h>
#import <ReplayKit/ReplayKit.h>
#import <ReplayKit/RPBroadcast.h>
@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIButton *broadcastButton;
@property (strong, nonatomic) RPBroadcastController *broadcastController;
@property (strong, nonatomic) UIView *broadcastPickerView;

@end

