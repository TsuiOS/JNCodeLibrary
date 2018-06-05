//
//  UIViewController+JNetWork.m
//  JNCodeLibrary
//
//  Created by xuning on 2018/6/5.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import "UIViewController+JNetWork.h"
#import <objc/runtime.h>

@implementation EMNetworkView

- (instancetype)init {
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"wuwangluo"];
        self.backgroundColor = [UIColor whiteColor];
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"wuwangluo"];
        self.backgroundColor = [UIColor whiteColor];;
        self.contentMode = UIViewContentModeCenter;
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end

static const void *NetworkArrayKey = &NetworkArrayKey;

static const void *BlackViewControllerKey = &BlackViewControllerKey;

@implementation UIViewController (JNetWork)


+ (void)setNetworkArray:(NSArray <NSString *>*)networkArray {
    objc_setAssociatedObject(self, NetworkArrayKey, networkArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSArray <NSString *>*)networkArray {

    return objc_getAssociatedObject(self, NetworkArrayKey);
}



- (void)showNoNetwork {
    


    if (![UIViewController needShowNetworkView]) {
        return;
    }
    
    
    NSInteger tag = 0;
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[EMNetworkView class]]) {
            tag ++;
        }
    }
    if(tag > 0)return;
    EMNetworkView *networkView = [[EMNetworkView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(reloadRequest)];
    [networkView addGestureRecognizer:tap];
    [self.view addSubview:networkView];
    
}

- (void)hiddenNoNetwork {
    
    for (UIView* view in self.view.subviews) {
        if ([view isKindOfClass:[EMNetworkView class]]) {
            [view removeFromSuperview];
        }
    }
    
}

/**
 刷新
 */
- (void)reloadRequest {
    
}



+ (void)addNetworkBlackList:(NSArray <NSString *>*)list {
    
    [self setNetworkArray:list];
    
}

+ (BOOL)needShowNetworkView {
    
    NSString *vcStr = NSStringFromClass([self currentViewController].class);
    
    return ![[self networkArray] containsObject:vcStr];
}

//获取Window当前显示的ViewController
+ (UIViewController*)currentViewController{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

@end
