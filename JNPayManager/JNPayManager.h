//
//  JNPayManager.h
//  JNCodeLibrary
//
//  Created by xuning on 2018/5/15.
//  Copyright © 2018年 Hsu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 支付状态码
 */
typedef NS_ENUM(NSInteger, JNPayCode) {
    WXSUCESS            = 1001,   /**成功*/
    WXERROR             = 1002,   /**失败*/
    WXSCANCEL           = 1003,   /**取消*/
    
    ALIPAYSUCESS        = 1101,   /**支付宝支付成功*/
    ALIPAYERROR         = 1102,   /**支付宝支付错误*/
    ALIPAYCANCEL        = 1103,   /**支付宝支付取消*/
    
    APPSTOREPAYSUCESS   = 1201,   /**内购支付成功*/
    APPSTOREPAYERROR    = 1202,   /**内购支付出错*/
    APPSTOREPAYCANCEL   = 1203,   /**内购支付取消*/
};

@interface JNPayManager : NSObject

/**
 支付管理类
 */
+ (instancetype)sharedPayManager;

/**
 微信支付
 
 @param dict 微信订单字典(全部由后台拼接好给iOS端)
 @param successBlock 成功的回调
 @param failureBolck 失败的回调
 */
- (void)WXPayWithPayDict:(NSDictionary *)dict
                    success:(void(^)(JNPayCode code))successBlock
                    failure:(void(^)(JNPayCode code))failureBolck;


/**
 支付宝支付
 
 @param params 支付宝支付参数(全部由后台拼接好给iOS端)
 @param successBlock 成功的回调
 @param failureBolck 失败的回调
 */
- (void)ALIPayWithPayParams:(NSString *)params
                       success:(void(^)(JNPayCode code))successBlock
                       failure:(void(^)(JNPayCode code))failureBolck;




/**
 支付宝授权

 @param infoStr 授权字符串
 @param successBlock 成功的回调
 @param failureBolck 失败的回调
 */
- (void)ALIAuth_V2WithInfo:(NSString *)infoStr
                      success:(void(^)(void))successBlock
                      failure:(void(^)(void))failureBolck;

@end
