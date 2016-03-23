//
//  NSObject+Extension.h
//  KDaijiaDriver
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KDaijiaDriver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <objc/message.h>

#define DEBUG_ENABLED

typedef NS_ENUM(NSInteger,NKLogType){
    NKLogTypeDefault
};
FOUNDATION_EXPORT NSString *kNotificationRecordScreenSaveSuccess;

@interface NSObject (Extension)
+ (BOOL)swizzerClassMethod:(Class)aClass selector:(SEL)aSelector1 withSelector:(SEL)aSelector2;
+ (BOOL)swizzerInstanceMethod:(Class)aClass selector:(SEL)aSelector1 withSelector:(SEL)aSelector2;
+ (void)logMessage:(NSString *)aMsg type:(NKLogType)aLogType;
@end