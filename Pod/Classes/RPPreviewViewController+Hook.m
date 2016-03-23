//
//  RPPreviewViewController+Hook.m
//  CLPDemo
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "RPPreviewViewController+Hook.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSObject+Extension.h"
#import <objc/runtime.h>
#import <dlfcn.h>

UIKIT_STATIC_INLINE void nk_loadPreviewViewControllerWithMovieURL_completion(id self,SEL _cmd,NSURL *aMovieUrl,id aBlock){
#ifdef DEBUG_ENABLED
    NSLog(@"[KWLM] %@-%@",self,NSStringFromSelector(_cmd));
#endif
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:aMovieUrl completionBlock:^(NSURL *assetURL, NSError *error){
#ifdef DEBUG_ENABLED
        NSLog(@"[KWLM] %@-%@-%@",@"loadPreviewViewControllerWithMovieURL:completion:",assetURL,error);
#endif
        if(!error)
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecordScreenSaveSuccess object:assetURL];
    }];
}

UIKIT_STATIC_INLINE void nk_loadPreviewViewControllerWithMovieURL_attachmentURL_overrideShareMessage_completion(id self,SEL _cmd,NSURL *aMovieUrl,NSURL *aAttachmentUrl,NSString * aShareMessage,id aBlock){
#ifdef DEBUG_ENABLED
    NSLog(@"[KWLM] %@-%@",self,NSStringFromSelector(_cmd));
#endif
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:aMovieUrl completionBlock:^(NSURL *assetURL, NSError *error){
#ifdef DEBUG_ENABLED
        NSLog(@"[KWLM] %@-%@-%@",@"loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:",assetURL,error);
#endif
        if(!error)
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecordScreenSaveSuccess object:assetURL];
    }];
}

@implementation UIViewController (RPPreviewViewController_Hook)
+ (void)load{
    char *dylibPath = "/System/Library/Framework/ReplayKit.framework/ReplayKit";
    void *libHandle = dlopen(dylibPath, RTLD_NOW);
    if (libHandle != NULL) {
        // This assumes your dylib’s init function is called init,
        //    if not change the name in "".
        void (*init)() = dlsym(libHandle, "init");
        if (init != NULL)  {
            init();
        }
    }
    Class RPPreviewVCClass = NSClassFromString(@"RPPreviewViewController");
    Class metaClass = object_getClass(RPPreviewVCClass);
    
    SEL sel1 = NSSelectorFromString(@"loadPreviewViewControllerWithMovieURL:completion:");
    SEL sel2 = NSSelectorFromString(@"nk_loadPreviewViewControllerWithMovieURL:completion:");
    Method m1 = class_getClassMethod(metaClass, sel1);
    IMP imp1 = class_getMethodImplementation(metaClass, sel1);
    const char * typeEncode1 = method_getTypeEncoding(m1);
    class_addMethod(metaClass,sel2,nk_loadPreviewViewControllerWithMovieURL_completion,typeEncode1);
    [NSObject swizzerClassMethod:RPPreviewVCClass selector:NSSelectorFromString(@"loadPreviewViewControllerWithMovieURL:completion:") withSelector:NSSelectorFromString(@"nk_loadPreviewViewControllerWithMovieURL:completion:")];
    
    sel1 = NSSelectorFromString(@"loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:");
    sel2 = NSSelectorFromString(@"nk_loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:");
    m1 = class_getClassMethod(metaClass, sel1);
    imp1 = class_getMethodImplementation(metaClass, sel1);
    typeEncode1 = method_getTypeEncoding(m1);
    class_addMethod(metaClass,sel2,nk_loadPreviewViewControllerWithMovieURL_completion,typeEncode1);
    
    [NSObject swizzerClassMethod:RPPreviewVCClass selector:NSSelectorFromString(@"loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:") withSelector:@selector(nk_loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:)];
}
//+ (void)nk_loadPreviewViewControllerWithMovieURL:(NSURL *)aMovieUrl completion:(id)aBlock{
//#ifdef DEBUG_ENABLED
//    NSLog(@"[KWLM] %@-%@",self,NSStringFromSelector(_cmd));
//#endif
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeVideoAtPathToSavedPhotosAlbum:aMovieUrl completionBlock:^(NSURL *assetURL, NSError *error){
//    #ifdef DEBUG_ENABLED
//        NSLog(@"[KWLM] %@-%@-%@",@"loadPreviewViewControllerWithMovieURL:completion:",assetURL,error);
//    #endif
//        if(!error)
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecordScreenSaveSuccess object:assetURL];
//    }];
//}

//+ (void)nk_loadPreviewViewControllerWithMovieURL:(NSURL *)aMovieUrl attachmentURL:(NSURL *)aAttachmentUrl overrideShareMessage:(NSString *)aShareMessage completion:(id)aBlock{
//#ifdef DEBUG_ENABLED
//    NSLog(@"[KWLM] %@-%@",self,NSStringFromSelector(_cmd));
//#endif
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeVideoAtPathToSavedPhotosAlbum:aMovieUrl completionBlock:^(NSURL *assetURL, NSError *error){
//    #ifdef DEBUG_ENABLED
//        NSLog(@"[KWLM] %@-%@-%@",@"loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:",assetURL,error);
//    #endif
//        if(!error)
//            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRecordScreenSaveSuccess object:assetURL];
//    }];
//}
//
@end