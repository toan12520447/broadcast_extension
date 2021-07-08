//
//  SampleHandler.m
//  ScreenShare
//
//  Created by Toan Tran on 7/7/21.
//


#import "SampleHandler.h"
@implementation SampleHandler{
    UIImage *image;
}

- (void)broadcastStartedWithSetupInfo:(NSDictionary<NSString *,NSObject *> *)setupInfo {
    // User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.
    NSLog(@"[SF_LOG] User has requested to start the broadcast. Setup info from the UI extension can be supplied but optional.");
}

- (void)broadcastPaused {
    // User has requested to pause the broadcast. Samples will stop being delivered.
    NSLog(@"[SF_LOG] User has requested to pause the broadcast. Samples will stop being delivered.");
}

- (void)broadcastResumed {
    // User has requested to resume the broadcast. Samples delivery will resume.
    NSLog(@"[SF_LOG] User has requested to resume the broadcast. Samples delivery will resume.");
}

- (void)broadcastFinished {
    // User has requested to finish the broadcast.
    NSLog(@"[SF_LOG] User has requested to finish the broadcast");
}

- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    
    switch (sampleBufferType) {
        case RPSampleBufferTypeVideo:
            // Handle video sample buffer
            NSLog(@"[SF_LOG]: Handle video sample buffer");
            CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
             if (pixelBuffer == nil) {
              return;
             }else{
                 CIImage *ciImage = [CIImage imageWithCVPixelBuffer:pixelBuffer];
                 CIContext *temporaryContext = [CIContext contextWithOptions:nil];
                 CGImageRef videoImage = [temporaryContext
                                    createCGImage:ciImage
                                    fromRect:CGRectMake(0, 0,
                                           CVPixelBufferGetWidth(pixelBuffer),
                                           CVPixelBufferGetHeight(pixelBuffer))];

                 UIImage *uiImage = [UIImage imageWithCGImage:videoImage];
                 NSLog(@"[SF_LOG] image: %@", NSStringFromCGSize(uiImage.size));
                 CGImageRelease(videoImage);
             }
            break;
        case RPSampleBufferTypeAudioApp:
            // Handle audio sample buffer for app audio
            NSLog(@"[SF_LOG]: Handle audio sample buffer for app audio");
            break;
        case RPSampleBufferTypeAudioMic:
            // Handle audio sample buffer for mic audio
            NSLog(@"[SF_LOG]: Handle audio sample buffer for mic audio");
            break;
            
        default:
            break;
    }
}
@end
