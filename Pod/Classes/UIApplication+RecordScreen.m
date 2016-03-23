//
//  UIApplication+RecordScreen.m
//  OneTravel
//
//  Created by KyleWong on 3/22/16.
//  Copyright © 2016 Didi.Inc. All rights reserved.
//

#import "UIApplication+RecordScreen.h"
#import "NKRecordManager.h"

NSString * kNotificationRecordScreenSaveSuccess = @"kNotificationRecordScreenSaveSuccess";
static NSTimer *autoSaveTimer = nil;
static NSInteger kAutoSaveRecordScreenInterval = 600; // 默认10min保存一次。
static UIApplicationState preAppState;
@implementation UIApplication (RecordScreen)
+ (void)load{
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(onAppDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaveSuccessNotification:) name:kNotificationRecordScreenSaveSuccess object:nil];
}

#pragma mark - Notification
+ (void)onAppDidBecomeActive:(NSNotification *)aNotification{
    if(![[NKRecordManager sharedInstance] isRecordingSupported]){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationRecordScreenSaveSuccess object:nil];
        [autoSaveTimer invalidate];
        autoSaveTimer = nil;
        return;
    }
    if(![[NKRecordManager sharedInstance] isRecording])
        [[NKRecordManager sharedInstance] startRecording];
    if(!autoSaveTimer){
        autoSaveTimer = [NSTimer scheduledTimerWithTimeInterval:kAutoSaveRecordScreenInterval target:self selector:@selector(onTimerExpired:) userInfo:nil repeats:YES];
    }
    if(preAppState == UIApplicationStateBackground)
    {
        [self onTimerExpired:autoSaveTimer];
        preAppState = UIApplicationStateActive;
    }
}

+ (void)onAppDidEnterBackground:(NSNotification *)aNotification{
    preAppState = UIApplicationStateBackground;
}

+ (void)onSaveSuccessNotification:(NSNotification *)aNotification{
    [self onAppDidBecomeActive:nil];
}

+ (void)onTimerExpired:(NSTimer *)aTimer{
#ifdef DEBUG_ENABLED
    NSLog(@"[KWLM] %@-%@",self,NSStringFromSelector(_cmd));
#endif
    if([[NKRecordManager sharedInstance] isRecording]){
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            [[NKRecordManager sharedInstance] stopRecording];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onAppDidBecomeActive:nil];
            });
        }
    }
    else{
        [self onAppDidBecomeActive:nil];
    }
}
@end