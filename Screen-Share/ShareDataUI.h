//
//  ShareData.h
//  Screen-Share
//
//  Created by Tran Van Toan on 04/08/2021.
//

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShareDataUI : NSObject
- (void)processFrame:(CMSampleBufferRef)sampleBuffer;
@end

NS_ASSUME_NONNULL_END
