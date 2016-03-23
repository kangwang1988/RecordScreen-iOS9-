//
//  NSObject+Extension.m
//  KDaijiaDriver
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KDaijiaDriver. All rights reserved.
//

#import "NSObject+Extension.h"
dispatch_queue_t syncQueue = NULL;

@implementation NSObject (Extension)
+ (void)load{
    syncQueue = dispatch_queue_create("com.wecoop.recordscreen.log", DISPATCH_QUEUE_SERIAL);
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
    dispatch_sync(syncQueue, ^{
        static NSString *logFilePath = nil;
        static NSDateFormatter *dateFormatter = nil;
        if(!logFilePath){
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            logFilePath = [[NSString alloc] initWithString:[paths.firstObject stringByAppendingString:@"/nkrecordscreen/log.txt"]];
        }
        if(!dateFormatter){
            dateFormatter = [NSDateFormatter new];
            [dateFormatter setDateFormat:@"YY-MM-dd HH:mm:ss"];
        }
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSFileHandle *fileHandler = [NSFileHandle fileHandleForWritingAtPath:logFilePath];
        if(!fileHandler){
            NSString *folder = [logFilePath substringToIndex:logFilePath.length-logFilePath.lastPathComponent.length];
            [fileManager createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
            if(!error){
                [fileManager createFileAtPath:logFilePath contents:nil attributes:nil];
            }
        }
        
        [fileHandler seekToEndOfFile];
        NSDate *date = [NSDate date];
        NSString *record = [NSString stringWithFormat:@"%@:%@\n",[dateFormatter stringFromDate:date],aMsg];
        [fileHandler writeData:[record dataUsingEncoding:NSUTF8StringEncoding]];
        [fileHandler closeFile];
    });
}
@end