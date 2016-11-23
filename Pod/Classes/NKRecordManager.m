//
//  NKRecordManager.m
//  CLPDemo
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//
#import "NKRecordManager.h"
#import <dlfcn.h>
#import <objc/runtime.h>
#import <objc/message.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIApplication+RecordScreen.h"

NSString * kNotificationRecordScreenSaveSuccess = @"kNotificationRecordScreenSaveSuccess";

typedef void (^RPStartRecordCompletionBlock)(NSError *__nullable *error);
typedef void (^RPStopRecordCompletionBlock)(id _Nullable previewViewController, NSError * _Nullable error);

static NKRecordManager *sRecordManager = nil;
@interface NKRecordManager()
{
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
        char *dylibPath = "/System/Library/Framework/ReplayKit.framework/ReplayKit";
        void *libHandle = dlopen(dylibPath, RTLD_NOW);
        if (libHandle != NULL) {
        }
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
    return ((BOOL (*)(id,SEL))objc_msgSend)(_recorder,NSSelectorFromString(@"isRecording"));
}

- (void)startRecording{
    if(!_recorder)
        return;
    ((void (*)(id,SEL,BOOL,RPStartRecordCompletionBlock))objc_msgSend)(_recorder, NSSelectorFromString(@"startRecordingWithMicrophoneEnabled:handler:"),YES,^(NSError *__nullable *error){
    });
}

- (void)stopRecording{
    if(!_recorder)
        return;
    ((void (*)(id,SEL,RPStopRecordCompletionBlock))objc_msgSend)(_recorder, NSSelectorFromString(@"stopRecordingWithHandler:"),^(id _Nullable previewViewController, NSError * _Nullable error){
        NSURL *aMovieUrl = [previewViewController valueForKey:@"movieURL"];
        [self writeVideoToAlbum:aMovieUrl];
    });
}

- (void)writeVideoToAlbum:(NSURL *)assetURL{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:assetURL completionBlock:^(NSURL *assetURL, NSError *error){
        if(!error)
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecordScreenSaveSuccess object:assetURL];
    }];
}
@end
