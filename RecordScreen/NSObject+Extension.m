//
//  NSObject+Extension.m
//  KDaijiaDriver
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KDaijiaDriver. All rights reserved.
//

#import "NSObject+Extension.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>
#import "NKRecordManager.h"

NSString * kNotificationRecordScreenSaveSuccess = @"kNotificationRecordScreenSaveSuccess";
static NSTimer *autoSaveTimer = nil;
static NSInteger kAutoSaveRecordScreenInterval = 600; // 默认10min保存一次。

@implementation NSObject (Extension)
+ (void)load{
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(onAppDidFinishLaunching:) name:UIApplicationDidFinishLaunchingNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(onAppWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(onAppDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSaveSuccessNotification:) name:kNotificationRecordScreenSaveSuccess object:nil];
}

#pragma mark - Notification
+ (void)onAppDidFinishLaunching:(NSNotification *)aNotification{
    if(![[NKRecordManager sharedInstance] isRecording])
        [[NKRecordManager sharedInstance] startRecording];
    if(!autoSaveTimer){
        autoSaveTimer = [NSTimer scheduledTimerWithTimeInterval:kAutoSaveRecordScreenInterval target:self selector:@selector(onTimerExpired:) userInfo:nil repeats:YES];
    }
}

+ (void)onAppDidBecomeActive:(NSNotification *)aNotification{
    [self onAppDidFinishLaunching:nil];
}

+ (void)onAppWillResignActive:(NSNotification *)aNotification{
    [self onTimerExpired:autoSaveTimer];
}

+ (void)onSaveSuccessNotification:(NSNotification *)aNotification{
    [self onAppDidFinishLaunching:nil];
}

+ (void)onTimerExpired:(NSTimer *)aTimer{
    if([[NKRecordManager sharedInstance] isRecording]){
        if([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive){
            [[NKRecordManager sharedInstance] stopRecording];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self onAppDidFinishLaunching:nil];
            });
        }
    }
    else{
        [self onAppDidFinishLaunching:nil];
    }
}

+ (BOOL)swizzerInstanceMethod:(Class)aClass selector:(SEL)aSelector1 withSelector:(SEL)aSelector2{
    Method m1 = class_getInstanceMethod(aClass, aSelector1);
    IMP imp1 = class_getMethodImplementation(aClass, aSelector1);
    const char * typeEncode1 = method_getTypeEncoding(m1);
    
    Method m2 = class_getInstanceMethod(aClass, aSelector2);
    IMP imp2 = class_getMethodImplementation(aClass, aSelector2);
    const char * typeEncode2 = method_getTypeEncoding(m2);
    if(class_addMethod(aClass, aSelector1, imp2, typeEncode2)){
        class_replaceMethod(aClass, aSelector2, imp1, typeEncode1);
    }
    else{
        method_exchangeImplementations(m1, m2);
    }
    return YES;
}

+ (BOOL)swizzerClassMethod:(Class)aClass selector:(SEL)aSelector1 withSelector:(SEL)aSelector2{
    Method m1 = class_getClassMethod(aClass, aSelector1);
    IMP imp1 = class_getMethodImplementation(aClass, aSelector1);
    const char * typeEncode1 = method_getTypeEncoding(m1);
    
    Method m2 = class_getClassMethod(aClass, aSelector2);
    IMP imp2 = class_getMethodImplementation(aClass, aSelector2);
    const char * typeEncode2 = method_getTypeEncoding(m2);
    Class cls = object_getClass(aClass);
    if(class_addMethod(cls, aSelector1, imp2, typeEncode2)){
        class_replaceMethod(cls, aSelector2, imp1, typeEncode1);
    }
    else{
        method_exchangeImplementations(m1, m2);
    }
    return YES;
}

+ (void)logMessage:(NSString *)aMsg type:(NKLogType)aLogType{
    static NSString *logFilePath = nil;
    static NSDateFormatter *dateFormatter = nil;
    if(!logFilePath){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        logFilePath = [paths.firstObject stringByAppendingString:@"/nkrecordscreen/log.txt"];
    }
    if(!dateFormatter){
        dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
    }
    NSError *error = nil;
    if(![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]){
        NSString *folder = [logFilePath substringToIndex:logFilePath.length-logFilePath.lastPathComponent.length];
        [[NSFileManager defaultManager] createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error){
            [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:nil attributes:nil];
        }
    }
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
    [fileHandler seekToEndOfFile];
    NSDate *date = [NSDate date];
    NSString *record = [NSString stringWithFormat:@"%@:%@\n",[dateFormatter stringFromDate:date],aMsg];
    [fileHandler writeData:[record dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}
@end