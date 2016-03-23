//
//  NKRecordManager.h
//  CLPDemo
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKRecordManager : NSObject
+ (instancetype)sharedInstance;
- (BOOL)isRecordingSupported;
- (BOOL)isRecording;
- (void)startRecording;
- (void)stopRecording;
@end
