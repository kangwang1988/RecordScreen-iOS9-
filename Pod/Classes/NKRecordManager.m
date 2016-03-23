//
//  NKRecordManager.m
//  CLPDemo
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//
#import "NKRecordManager.h"
#import "NSObject+Extension.h"

typedef void (^RPStartRecordCompletionBlock)(NSError *__nullable *error);
typedef void (^RPStopRecordCompletionBlock)(id _Nullable previewViewController, NSError * _Nullable error);

static NKRecordManager *sRecordManager = nil;
@interface NKRecordManager()
{
//    RPScreenRecorder *_recorder;
    id _recorder;
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
//        _recorder = [RPScreenRecorder sharedRecorder];
        id cls = objc_getClass("RPScreenRecorder");
        SEL sel = sel_registerName("sharedRecorder");
        _recorder = ((id (*)(id,SEL))objc_msgSend)(cls,sel);
    }
    return self;
}

- (BOOL)isRecordingSupported{
    return _recorder?YES:NO;
}

- (BOOL)isRecording{
//    return _recorder.isRecording;
    return ((BOOL (*)(id,SEL))objc_msgSend)(_recorder,NSSelectorFromString(@"isRecording"));
}

- (void)startRecording{
    if(!_recorder)
        return;
#ifdef DEBUG_ENABLED
    NSLog(@"[KWLM] %@-%@-recorder:%@",self,NSStringFromSelector(_cmd),_recorder);
#endif
//    [_recorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
//    #ifdef DEBUG_ENABLED
//        NSLog(@"[KWLM] startRecording result:%@",error);
//    #endif
//    }];
    ((void (*)(id,SEL,BOOL,RPStartRecordCompletionBlock))objc_msgSend)(_recorder, NSSelectorFromString(@"startRecordingWithMicrophoneEnabled:handler:"),YES,^(NSError *__nullable *error){
#ifdef DEBUG_ENABLED
        NSLog(@"[KWLM] startRecording result:%@",error);
#endif
    });
}

- (void)stopRecording{
    if(!_recorder)
        return;
#ifdef DEBUG_ENABLED
    NSLog(@"[KWLM] %@-%@-recorder:%@",self,NSStringFromSelector(_cmd),_recorder);
#endif
//    [_recorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
//    #ifdef DEBUG_ENABLED
//        NSLog(@"[KWLM] stopRecordingWithHandler result:%@",error);
//    #endif
//    }];
    ((void (*)(id,SEL,RPStopRecordCompletionBlock))objc_msgSend)(_recorder, NSSelectorFromString(@"stopRecordingWithHandler:"),^(id _Nullable previewViewController, NSError * _Nullable error){
#ifdef DEBUG_ENABLED
        NSLog(@"[KWLM] stopRecordingWithHandler result:%@",error);
#endif
    });
}
@end