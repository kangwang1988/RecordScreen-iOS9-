//
//  NKRecordManager.m
//  CLPDemo
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "NKRecordManager.h"
#import "NSObject+Extension.h"
#import <ReplayKit/ReplayKit.h>

static NKRecordManager *sRecordManager = nil;
@interface NKRecordManager()
{
    RPScreenRecorder *_recorder;
}
@end
@implementation NKRecordManager
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sRecordManager = [NKRecordManager new];
    });
    return sRecordManager;
}

- (instancetype)init{
    if(self = [super init]){
        _recorder = [RPScreenRecorder sharedRecorder];
    }
    return self;
}

- (BOOL)isRecording{
    return _recorder.isRecording;
}

- (void)startRecording{
#ifdef DEBUG_ENABLED
    NSLog(@"[KWLM] %@-%@-recorder:%@",self,NSStringFromSelector(_cmd),_recorder);
#endif
    [_recorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
    #ifdef DEBUG_ENABLED
        NSLog(@"[KWLM] startRecording result:%@",error);
    #endif
    }];
}

- (void)stopRecording{
#ifdef DEBUG_ENABLED
    NSLog(@"[KWLM] %@-%@-recorder:%@",self,NSStringFromSelector(_cmd),_recorder);
#endif
    [_recorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
    #ifdef DEBUG_ENABLED
        NSLog(@"[KWLM] stopRecordingWithHandler result:%@",error);
    #endif
    }];
}
@end