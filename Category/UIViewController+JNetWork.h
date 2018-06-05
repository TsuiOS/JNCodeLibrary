//
//  UIViewController+JNetWork.h
//  JNCodeLibrary
//
//  Created by xuning on 2018/6/5.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EMNetworkView : UIImageView

@end

@interface UIViewController (JNetWork)


/**
 黑名单功能

 @param list 控制器列表
 */
+ (void)addNetworkBlackList:(NSArray <NSString *>*)list;

+ (UIViewController*)currentViewController;
/**
 显示无网络
 */
-(void)showNoNetwork;


/**
 隐藏无网络
 */
-(void)hiddenNoNetwork;


/**
 刷新
 */
- (void)reloadRequest;

@end
