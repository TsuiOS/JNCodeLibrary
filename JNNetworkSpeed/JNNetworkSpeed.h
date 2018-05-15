//
//  JNNetworkSpeed.h
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/15.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  @{@"received":@"100kB/s"}
 */
FOUNDATION_EXTERN NSString *const kNetworkReceivedSpeedNotification;
/**
 *  @{@"send":@"100kB/s"}
 */
FOUNDATION_EXTERN NSString *const kNetworkSendSpeedNotification;

@interface JNNetworkSpeed : NSObject


@property (nonatomic, copy, readonly) NSString * receivedNetworkSpeed;

@property (nonatomic, copy, readonly) NSString * sendNetworkSpeed;

+ (instancetype)shareNetworkSpeed;
- (void)startMonitoringNetworkSpeed;
- (void)stopMonitoringNetworkSpeed;

@end
