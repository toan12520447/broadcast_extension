//
//  ShareData.m
//  Screen-Share
//
//  Created by Tran Van Toan on 04/08/2021.
//

#import "ShareDataUI.h"
#import <ReplayKit/ReplayKit.h>
@implementation ShareDataUI
- (void)processFrame:(CMSampleBufferRef)sampleBuffer{
    NSLog(@"Sample buffer : %@", sampleBuffer);
}
@end
