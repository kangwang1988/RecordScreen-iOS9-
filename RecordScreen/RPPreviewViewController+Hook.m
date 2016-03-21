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

@implementation RPPreviewViewController (Hook)
+ (void)load{
    [NSObject swizzerClassMethod:[RPPreviewViewController class] selector:NSSelectorFromString(@"loadPreviewViewControllerWithMovieURL:completion:") withSelector:@selector(nk_loadPreviewViewControllerWithMovieURL:completion:)];
    [NSObject swizzerClassMethod:[RPPreviewViewController class] selector:NSSelectorFromString(@"loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:") withSelector:@selector(nk_loadPreviewViewControllerWithMovieURL:attachmentURL:overrideShareMessage:completion:)];
}

+ (void)nk_loadPreviewViewControllerWithMovieURL:(NSURL *)aMovieUrl attachmentURL:(NSURL *)aAttachmentUrl overrideShareMessage:(NSString *)aShareMessage completion:(id)aBlock{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:aMovieUrl completionBlock:^(NSURL *assetURL, NSError *error){
        
    }];
}

+ (void)nk_loadPreviewViewControllerWithMovieURL:(NSURL *)aUrl completion:(id)aBlock{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeVideoAtPathToSavedPhotosAlbum:aUrl completionBlock:^(NSURL *assetURL, NSError *error){
        
    }];
}
@end