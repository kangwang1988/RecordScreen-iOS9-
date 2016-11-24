//
//  NKRecordManager.m
//  CLPDemo
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//
#import "NKRecordManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ReplayKit/ReplayKit.h>
#import "UIApplication+RecordScreen.h"

NSString * kNotificationRecordScreenSaveSuccess = @"kNotificationRecordScreenSaveSuccess";

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

- (BOOL)isRecordingSupported{
    return _recorder?YES:NO;
}

- (BOOL)isRecording{
    return _recorder.isRecording;
}

- (void)startRecording{
    if(!_recorder)
        return;
    [_recorder startRecordingWithMicrophoneEnabled:YES handler:^(NSError * _Nullable error) {
        
    }];
}

- (void)stopRecording{
    if(!_recorder)
        return;
    [_recorder stopRecordingWithHandler:^(RPPreviewViewController * _Nullable previewViewController, NSError * _Nullable error) {
        NSURL *aMovieUrl = [previewViewController valueForKey:@"movieURL"];
        [self writeVideoToAlbum:aMovieUrl];
    }];
}

- (void)writeVideoToAlbum:(NSURL *)assetURL{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:assetURL completionBlock:^(NSURL *assetURL, NSError *error){
        if(!error)
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecordScreenSaveSuccess object:assetURL];
    }];
}
@end
