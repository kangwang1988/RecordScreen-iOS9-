//
//  UIResponder+Log.m
//  CLPDemo
//
//  Created by KyleWong on 3/21/16.
//  Copyright © 2016 KyleWong. All rights reserved.
//

#import "UIResponder+Log.h"
#import "NSObject+Extension.h"

@interface NKTouchHintView : UIImageView
- (instancetype)initWithCenterPt:(CGPoint)aCenterPt;
@end

@implementation NKTouchHintView
- (instancetype)initWithCenterPt:(CGPoint)aCenterPt{
    if(self = [super init]){
        [self setBackgroundColor:[UIColor redColor]];
        CGSize size = CGSizeMake(8, 8);
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:size.width/2.f];
        [self setFrame:CGRectMake(aCenterPt.x-size.width/2.f, aCenterPt.y-size.height/2.f, size.width, size.height)];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [self performSelector:@selector(autoRemove) withObject:nil afterDelay:.15f];
}

- (void)autoRemove{
    [self removeFromSuperview];
}
@end

@implementation UIWindow(Log)
+ (void)load{
    Class cls = [UIWindow class];
    [NSObject swizzerInstanceMethod:cls selector:@selector(sendEvent:) withSelector:@selector(nk_sendEvent:)];
}

- (void)nk_sendEvent:(UIEvent *)event{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject logMessage:[NSString stringWithFormat:@"[%@] sendEvent:%@",self,event] type:NKLogTypeDefault];
    });
    NSSet *touches = [event allTouches];
    UIWindow *supWindow = self;
    for(UITouch *touch in touches){
        CGPoint pt = [touch locationInView:supWindow];
        NKTouchHintView *hintView = [[NKTouchHintView alloc] initWithCenterPt:pt];
        [supWindow addSubview:hintView];
        [supWindow bringSubviewToFront:hintView];
    }
    [self nk_sendEvent:event];
}
@end